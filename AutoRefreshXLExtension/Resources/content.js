// Auto Refresh XL - iOS Safari Content Script

(function () {
  let currentTabState = null;
  let overlayElement = null;
  let overlayShadow = null;
  let isDragging = false;
  let dragOffsetX = 0;
  let dragOffsetY = 0;
  let hasTriggeredTarget = false;
  let monitorIntervalId = null;
  let monitorObserver = null;
  let monitorCheckTimer = null;
  let audioUnlocked = false;
  let preStartSoundHost = null;
  let preStartSoundShadow = null;

  let sharedAudioCtx = null;

  function logDebug(category, message, type = 'info') {
    console.log(`[AutoRefreshXL Content] [${category}] [${type}] ${message}`);
  }

  function getUnlockedAudioContext() {
    try {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (!AudioCtx) return null;
      if (!sharedAudioCtx) {
        sharedAudioCtx = new AudioCtx();
      }
      if (sharedAudioCtx.state === 'suspended') {
        sharedAudioCtx.resume().catch(() => {});
      }
      return sharedAudioCtx;
    } catch (e) {
      return null;
    }
  }

  // Unlock AudioContext on user touch
  const unlockAudioOnTouch = () => {
    const context = getUnlockedAudioContext();
    if (context) {
      const markUnlocked = () => {
        audioUnlocked = context.state === 'running';
        updateSoundEnableControl();
        updatePreStartSoundControl();
      };
      if (context.state === 'running') {
        markUnlocked();
      } else {
        context.resume().then(markUnlocked).catch(() => {});
      }
    }
    window.removeEventListener('touchstart', unlockAudioOnTouch, true);
    window.removeEventListener('click', unlockAudioOnTouch, true);
  };
  window.addEventListener('touchstart', unlockAudioOnTouch, { capture: true, passive: true });
  window.addEventListener('click', unlockAudioOnTouch, { capture: true, passive: true });

  chrome.runtime.sendMessage({ type: 'GET_TAB_STATE' }, (response) => {
    if (chrome.runtime.lastError || !response || !response.state) return;
    currentTabState = response.state;

    if (currentTabState.enabled) {
      initContentFeatures();
    }
  });

  chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === 'COUNTDOWN_TICK') {
      currentTabState = request.state;
      if (currentTabState && currentTabState.overlayEnabled && !overlayElement) {
        renderFloatingOverlay();
      }
      updateOverlayCountdown(request.remainingSeconds, request.refreshCount, request.maxRefreshes);
      initContentFeatures();
    } else if (request.type === 'REFRESH_STARTED') {
      currentTabState = request.state;
      hasTriggeredTarget = false;
      getUnlockedAudioContext();
      removePreStartSoundControl();
      initContentFeatures();
    } else if (request.type === 'STATE_SYNC') {
      currentTabState = request.state;
      initContentFeatures();
    } else if (request.type === 'REFRESH_STOPPED') {
      if (currentTabState) currentTabState.enabled = false;
      stopMonitoringLoop();
      removeOverlay();
    } else if (request.type === 'TEST_SOUND') {
      playAlertSound();
    } else if (request.type === 'SHOW_PRESTART_SOUND_CONTROL') {
      renderPreStartSoundControl();
      sendResponse({ success: true });
    } else if (request.type === 'FETCH_MONITOR_CHECK') {
      currentTabState = request.state || currentTabState;
      fetchAndCheckCurrentPage()
        .then((matched) => sendResponse({ success: true, matched }))
        .catch((error) => {
          logDebug('FETCH', 'Fetch check failed: ' + error.message, 'error');
          sendResponse({ success: false, error: error.message });
        });
      return true;
    }
  });

  function initContentFeatures() {
    if (!currentTabState) return;

    const needsSoundControl = currentTabState.monitorEnabled &&
      currentTabState.targetText &&
      currentTabState.actionSound !== false &&
      !audioUnlocked;

    // iOS requires a control inside the webpage to unlock audio. Show the
    // compact widget for that control even when the optional timer overlay is off.
    if ((currentTabState.overlayEnabled !== false || needsSoundControl) && !overlayElement) {
      renderFloatingOverlay();
    }

    if (currentTabState.monitorEnabled && currentTabState.targetText && currentTabState.actionSound !== false) {
      updateSoundEnableControl();
    }

    if (currentTabState.stopOnInteraction) {
      setupUserInteractionListener();
    }
  }

  function stopMonitoringLoop() {
    if (monitorIntervalId) {
      clearInterval(monitorIntervalId);
      monitorIntervalId = null;
    }
    if (monitorObserver) {
      monitorObserver.disconnect();
      monitorObserver = null;
    }
    if (monitorCheckTimer) {
      clearTimeout(monitorCheckTimer);
      monitorCheckTimer = null;
    }
  }

  function queueMonitoringCheck() {
    if (monitorCheckTimer || hasTriggeredTarget) return;
    monitorCheckTimer = setTimeout(() => {
      monitorCheckTimer = null;
      if (currentTabState && Number(currentTabState.refreshCount || 0) > 0 && currentTabState.monitorEnabled && !hasTriggeredTarget) {
        checkPageMonitoring();
      }
    }, 100);
  }

  async function fetchAndCheckCurrentPage() {
    if (!currentTabState || hasTriggeredTarget) return false;

    logDebug('FETCH', 'Fetching a fresh copy of ' + window.location.href);
    const response = await fetch(window.location.href, {
      method: 'GET',
      cache: 'no-store',
      credentials: 'include',
      redirect: 'follow'
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status} ${response.statusText}`.trim());
    }

    const html = await response.text();
    const fetchedDocument = new DOMParser().parseFromString(html, 'text/html');
    return checkPageMonitoring(fetchedDocument, true);
  }

  function checkPageMonitoring(sourceDocument = document, isFetchedCopy = false) {
    if (!currentTabState) {
      return false;
    }

    const target = String(currentTabState.targetText || '').trim();
    if (!target) {
      logDebug('SCAN', 'Target text is empty');
      return false;
    }

    logDebug('SCAN', 'Scanning page for target "' + target + '" (refreshCount: ' + currentTabState.refreshCount + ')');

    let matchedNode = null;
    let isFound = false;

    if (currentTabState.matchType === 'xpath') {
      try {
        const result = sourceDocument.evaluate(target, sourceDocument, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        matchedNode = result.singleNodeValue;
        isFound = !!matchedNode;
      } catch (e) {
        logDebug('SCAN', 'Invalid XPath: ' + target, 'error');
      }
    } else if (currentTabState.matchType === 'regex') {
      try {
        const regex = new RegExp(target, 'i');
        const bodyText = getPageText(sourceDocument);
        isFound = regex.test(bodyText);
        if (isFound) {
          matchedNode = findTextNodeMatching(regex, sourceDocument);
        }
      } catch (e) {
        logDebug('SCAN', 'Invalid Regex: ' + target, 'error');
      }
    } else {
      const bodyText = getPageText(sourceDocument);
      isFound = bodyText.toLowerCase().includes(target.toLowerCase());
      if (isFound) {
        matchedNode = findTextNodeMatching(new RegExp(escapeRegExp(target), 'i'), sourceDocument);
      }
    }

    const conditionMet = (currentTabState.condition === 'appears' && isFound) ||
                         (currentTabState.condition === 'disappears' && !isFound);

    if (!conditionMet) {
      logDebug('SCAN', 'Target condition NOT met yet (isFound: ' + isFound + ')');
      return false;
    }

    logDebug('SCAN', '🎯 TARGET CONDITION MET! Target: "' + target + '"', 'success');

    hasTriggeredTarget = true;
    stopMonitoringLoop();

    // 1. Highlight exact matching text in webpage DOM
    let highlightedEl = null;
    try {
      if (!isFetchedCopy && currentTabState.actionHighlight !== false) {
        logDebug('HIGHLIGHT', 'Executing highlightMatchingText...');
        highlightedEl = highlightMatchingText(currentTabState.targetText, currentTabState.matchType);
        if (highlightedEl) {
          logDebug('HIGHLIGHT', '🟢 Word highlighted successfully!', 'success');
        } else {
          logDebug('HIGHLIGHT', '⚠️ Word highlight returned null', 'warn');
        }
      }
    } catch (e) {
      logDebug('HIGHLIGHT', '🔴 Highlight Error: ' + e.message, 'error');
    }

    // 2. Play Audio Alert Chime
    try {
      if (currentTabState.actionSound !== false) {
        logDebug('SOUND', 'Executing playAlertSound...');
        playAlertSound();
      }
    } catch (e) {
      logDebug('SOUND', '🔴 Sound Error: ' + e.message, 'error');
    }

    // 3. Show On-Screen Alert Banner
    try {
      logDebug('BANNER', 'Rendering target alert banner...');
      showTargetAlertBanner(currentTabState.targetText);
      logDebug('BANNER', '🟢 Alert banner rendered!', 'success');
    } catch (e) {
      logDebug('BANNER', '🔴 Banner Error: ' + e.message, 'error');
    }

    // 4. Auto-Scroll to Highlighted Element
    try {
      const targetToScroll = isFetchedCopy ? null : (highlightedEl || matchedNode);
      if (targetToScroll && currentTabState.actionScroll !== false) {
        logDebug('SCROLL', 'Scrolling to target element...');
        targetToScroll.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    } catch (e) {}

    // 5. Send message to background service worker
    try {
      logDebug('NOTIFY', 'Sending TARGET_DETECTED message to background.js...');
      chrome.runtime.sendMessage({ type: 'TARGET_DETECTED', targetText: currentTabState.targetText }, (res) => {
        if (chrome.runtime.lastError) {
          logDebug('NOTIFY', '🔴 Background Message Error: ' + chrome.runtime.lastError.message, 'error');
        } else if (!res || res.success !== true) {
          logDebug('NOTIFY', '🔴 Native alert failed: ' + ((res && res.error) || 'Unknown error'), 'error');
        } else {
          logDebug('NOTIFY', 'Native alert completed successfully', 'success');
        }
      });
    } catch (e) {
      logDebug('NOTIFY', '🔴 Background Message Error: ' + e.message, 'error');
    }

      if (overlayShadow) {
        const statusBadge = overlayShadow.querySelector('.arp-status-badge');
        if (statusBadge) {
          statusBadge.textContent = 'TARGET DETECTED!';
          statusBadge.className = 'arp-status-badge arp-detected';
        }
      }
      return true;
    }

  function showTargetAlertBanner(targetText) {
    if (document.getElementById('arp-target-alert-banner')) return;

    const banner = document.createElement('div');
    banner.id = 'arp-target-alert-banner';
    banner.style.cssText = `
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 2147483647;
      background: linear-gradient(135deg, #0f172a, #1e293b);
      color: #f8fafc;
      border: 2px solid #00f2fe;
      border-radius: 16px;
      padding: 16px 24px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.6), 0 0 20px rgba(0,242,254,0.4);
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", Roboto, sans-serif;
      text-align: center;
      min-width: 280px;
    `;

    banner.innerHTML = `
      <div style="font-size: 18px; font-weight: 800; color: #00f2fe; margin-bottom: 4px;">
        🎯 TARGET DETECTED!
      </div>
      <div style="font-size: 13px; color: #cbd5e1; margin-bottom: 12px;">
        Keyword <strong style="color: #fff;">"${escapeHTML(targetText)}"</strong> was detected on this page.
      </div>
      <button id="arp-banner-dismiss" style="
        background: linear-gradient(135deg, #00f2fe, #0284c7);
        color: #000;
        border: none;
        padding: 8px 18px;
        border-radius: 8px;
        font-weight: 800;
        font-size: 13px;
        cursor: pointer;
      ">Dismiss Alert</button>
    `;

    document.body.appendChild(banner);

    document.getElementById('arp-banner-dismiss')?.addEventListener('click', () => {
      banner.remove();
    });
  }

  function getPageText(sourceDocument = document) {
    const root = sourceDocument.body || sourceDocument.documentElement;
    if (!root) return '';
    return `${root.innerText || ''} ${root.textContent || ''}`;
  }

  function escapeHTML(str) {
    return str.replace(/[&<>'"]/g, tag => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[tag] || tag));
  }

  function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  function highlightMatchingText(targetText, matchType) {
    if (!targetText || !document.body) return null;

    let regex;
    try {
      if (matchType === 'regex') {
        regex = new RegExp(targetText, 'gi');
      } else if (matchType === 'xpath') {
        return null;
      } else {
        regex = new RegExp(escapeRegExp(targetText), 'gi');
      }
    } catch (e) {
      return null;
    }

    injectHighlightStyles();

    const walker = document.createTreeWalker(
      document.body,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode: function (node) {
          regex.lastIndex = 0;
          if (!node.nodeValue || !regex.test(node.nodeValue)) {
            return NodeFilter.FILTER_REJECT;
          }
          const parent = node.parentElement;
          if (!parent) return NodeFilter.FILTER_REJECT;
          if (parent.closest('#arp-target-alert-banner') || parent.closest('#arp-floating-overlay-host') || parent.closest('.arp-exact-word-highlight')) {
            return NodeFilter.FILTER_REJECT;
          }
          const tag = parent.tagName.toLowerCase();
          if (tag === 'script' || tag === 'style' || tag === 'noscript' || tag === 'textarea' || tag === 'mark') {
            return NodeFilter.FILTER_REJECT;
          }
          return NodeFilter.FILTER_ACCEPT;
        }
      },
      false
    );

    const matchingTextNodes = [];
    let textNode;
    while ((textNode = walker.nextNode())) {
      matchingTextNodes.push(textNode);
    }

    let firstHighlightedEl = null;

    matchingTextNodes.forEach(tNode => {
      const parent = tNode.parentElement;
      if (!parent) return;

      const text = tNode.nodeValue;
      regex.lastIndex = 0;
      const match = regex.exec(text);
      if (!match) return;

      const matchedStr = match[0];
      const matchIndex = match.index;

      const beforeText = text.substring(0, matchIndex);
      const afterText = text.substring(matchIndex + matchedStr.length);

      const mark = document.createElement('mark');
      mark.className = 'arp-exact-word-highlight';
      mark.style.cssText = `
        background: #facc15 !important;
        color: #000000 !important;
        font-weight: 900 !important;
        padding: 2px 6px !important;
        border-radius: 4px !important;
        box-shadow: 0 0 12px #facc15, 0 0 4px #000 !important;
        outline: 2px solid #eab308 !important;
        display: inline-block !important;
        animation: arpHighlightPulse 1.2s infinite alternate !important;
      `;
      mark.textContent = matchedStr;

      const frag = document.createDocumentFragment();
      if (beforeText) frag.appendChild(document.createTextNode(beforeText));
      frag.appendChild(mark);
      if (afterText) frag.appendChild(document.createTextNode(afterText));

      parent.replaceChild(frag, tNode);

      if (!firstHighlightedEl) {
        firstHighlightedEl = mark;
      }
    });

    return firstHighlightedEl;
  }

  function injectHighlightStyles() {
    if (document.getElementById('arp-highlight-style')) return;
    const style = document.createElement('style');
    style.id = 'arp-highlight-style';
    style.textContent = `
      @keyframes arpHighlightPulse {
        0% { transform: scale(1); box-shadow: 0 0 8px #facc15; }
        100% { transform: scale(1.1); box-shadow: 0 0 18px #facc15, 0 0 6px #eab308; }
      }
    `;
    document.head.appendChild(style);
  }

  function findTextNodeMatching(regex, sourceDocument = document) {
    const root = sourceDocument.body || sourceDocument.documentElement;
    if (!root) return null;
    const walker = sourceDocument.createTreeWalker(root, NodeFilter.SHOW_TEXT, null, false);
    let node;
    while ((node = walker.nextNode())) {
      regex.lastIndex = 0;
      if (regex.test(node.nodeValue) && node.parentElement) {
        return node.parentElement;
      }
    }
    return null;
  }

  function getChimeAudioURI() {
    try {
      const sampleRate = 11025;
      const numSamples = Math.floor(sampleRate * 0.45);
      const buffer = new Uint8Array(44 + numSamples);
      buffer[0] = 82; buffer[1] = 73; buffer[2] = 70; buffer[3] = 70;
      const fileSize = 36 + numSamples;
      buffer[4] = fileSize & 0xff; buffer[5] = (fileSize >> 8) & 0xff;
      buffer[6] = (fileSize >> 16) & 0xff; buffer[7] = (fileSize >> 24) & 0xff;
      buffer[8] = 87; buffer[9] = 65; buffer[10] = 86; buffer[11] = 69;
      buffer[12] = 102; buffer[13] = 109; buffer[14] = 116; buffer[15] = 32;
      buffer[16] = 16; buffer[17] = 0; buffer[18] = 0; buffer[19] = 0;
      buffer[20] = 1; buffer[21] = 0; buffer[22] = 1; buffer[23] = 0;
      buffer[24] = sampleRate & 0xff; buffer[25] = (sampleRate >> 8) & 0xff;
      buffer[26] = 0; buffer[27] = 0;
      buffer[28] = sampleRate & 0xff; buffer[29] = (sampleRate >> 8) & 0xff;
      buffer[30] = 0; buffer[31] = 0;
      buffer[32] = 1; buffer[33] = 0; buffer[34] = 8; buffer[35] = 0;
      buffer[36] = 100; buffer[37] = 97; buffer[38] = 116; buffer[39] = 97;
      buffer[40] = numSamples & 0xff; buffer[41] = (numSamples >> 8) & 0xff;
      buffer[42] = (numSamples >> 16) & 0xff; buffer[43] = (numSamples >> 24) & 0xff;

      for (let i = 0; i < numSamples; i++) {
        const t = i / sampleRate;
        const freq = i < numSamples * 0.5 ? 880 : 1320;
        const sample = Math.sin(2 * Math.PI * freq * t);
        const decay = 1 - (i / numSamples);
        buffer[44 + i] = Math.floor(128 + sample * 110 * decay);
      }

      let binary = '';
      for (let i = 0; i < buffer.byteLength; i++) {
        binary += String.fromCharCode(buffer[i]);
      }
      return 'data:audio/wav;base64,' + btoa(binary);
    } catch (e) {
      return '';
    }
  }

  function playAlertSound() {
    logDebug('SOUND', 'Attempting audio playback (HTML5 Audio + Web Audio API)...');

    try {
      const uri = getChimeAudioURI();
      if (uri) {
        const audio = new Audio(uri);
        audio.volume = 1.0;
        audio.play().then(() => {
          logDebug('SOUND', '🔊 HTML5 Audio played successfully!', 'success');
        }).catch(e => {
          logDebug('SOUND', '🔴 HTML5 Audio.play() Error: ' + e.name + ' - ' + e.message, 'error');
        });
      }
    } catch (e) {
      logDebug('SOUND', '🔴 HTML5 Audio Exception: ' + e.message, 'error');
    }

    try {
      const ctx = getUnlockedAudioContext();
      if (ctx) {
        logDebug('SOUND', 'Web AudioContext state: ' + ctx.state);
        if (ctx.state === 'suspended') {
          ctx.resume().then(() => {
            logDebug('SOUND', 'Web AudioContext resumed', 'success');
          }).catch(e => {
            logDebug('SOUND', '🔴 AudioContext resume Error: ' + e.message, 'error');
          });
        }
        const now = ctx.currentTime;
        const osc1 = ctx.createOscillator();
        const gain1 = ctx.createGain();
        osc1.type = 'sine';
        osc1.frequency.setValueAtTime(1046.5, now);
        gain1.gain.setValueAtTime(0.4, now);
        gain1.gain.exponentialRampToValueAtTime(0.001, now + 0.35);
        osc1.connect(gain1);
        gain1.connect(ctx.destination);
        osc1.start(now);
        osc1.stop(now + 0.35);
        logDebug('SOUND', '🔊 Web Audio Oscillator tone triggered!', 'success');
      } else {
        logDebug('SOUND', '⚠️ Web AudioContext unavailable', 'warn');
      }
    } catch (e) {
      logDebug('SOUND', '🔴 Web Audio Exception: ' + e.message, 'error');
    }
  }

  function showWebNotification(title, message) {
    if (typeof Notification === 'undefined') return;

    if (Notification.permission === 'granted') {
      try {
        new Notification(title, { body: message });
      } catch (e) {
        console.warn('Notification error:', e);
      }
    } else if (Notification.permission !== 'denied') {
      Notification.requestPermission().then((permission) => {
        if (permission === 'granted') {
          try {
            new Notification(title, { body: message });
          } catch (e) {}
        }
      });
    }
  }

  function renderFloatingOverlay() {
    if (overlayElement) return;

    overlayElement = document.createElement('div');
    overlayElement.id = 'auto-refresh-plus-widget-host';
    overlayElement.style.position = 'fixed';
    overlayElement.style.top = '15px';
    overlayElement.style.right = '15px';
    overlayElement.style.zIndex = '2147483647';

    overlayShadow = overlayElement.attachShadow({ mode: 'open' });

    const style = document.createElement('style');
    style.textContent = `
      :host {
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", Roboto, sans-serif;
        font-size: 13px;
        color: #f8fafc;
        user-select: none;
        -webkit-user-select: none;
      }
      .arp-widget {
        width: 200px;
        background: rgba(15, 23, 42, 0.94);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(0, 242, 254, 0.2);
        border-radius: 14px;
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.5);
        overflow: hidden;
      }
      .arp-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 12px;
        background: rgba(22, 30, 46, 0.9);
        border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        touch-action: none;
      }
      .arp-title-group {
        display: flex;
        align-items: center;
        gap: 6px;
        font-weight: 700;
        color: #00f2fe;
      }
      .arp-title-icon {
        width: 14px;
        height: 14px;
        fill: currentColor;
      }
      .arp-close-btn {
        background: transparent;
        border: none;
        color: #94a3b8;
        font-size: 16px;
        padding: 2px 4px;
        line-height: 1;
      }
      .arp-body {
        padding: 10px;
      }
      .arp-countdown-row {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        margin-bottom: 6px;
      }
      .arp-countdown-time {
        font-size: 24px;
        font-weight: 800;
        color: #00f2fe;
      }
      .arp-status-badge {
        font-size: 9px;
        font-weight: 700;
        text-transform: uppercase;
        padding: 2px 6px;
        border-radius: 9999px;
        background: rgba(0, 242, 254, 0.2);
        color: #00f2fe;
        border: 1px solid rgba(0, 242, 254, 0.3);
      }
      .arp-status-badge.arp-detected {
        background: rgba(239, 68, 68, 0.2);
        color: #f87171;
        border-color: rgba(248, 113, 113, 0.3);
      }
      .arp-info-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 10px;
        color: #94a3b8;
        margin-bottom: 8px;
      }
      .arp-actions {
        display: flex;
        gap: 6px;
      }
      .arp-btn {
        flex: 1;
        padding: 6px;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 600;
        border: none;
        text-align: center;
      }
      .arp-btn-danger {
        background: #ef4444;
        color: #ffffff;
      }
      .arp-btn-sound {
        background: #0284c7;
        color: #ffffff;
        margin-bottom: 6px;
      }
      .arp-btn-sound.is-enabled {
        background: #15803d;
      }
    `;

    const widget = document.createElement('div');
    widget.className = 'arp-widget';
    widget.innerHTML = `
      <div class="arp-header">
        <div class="arp-title-group">
          <svg class="arp-title-icon" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="8" fill="none" stroke="currentColor" stroke-width="2"/>
            <circle cx="12" cy="12" r="3" fill="currentColor"/>
          </svg>
          <span>Auto Refresh XL</span>
        </div>
        <button class="arp-close-btn" id="arp-close-widget">&times;</button>
      </div>
      <div class="arp-body">
        <div class="arp-countdown-row">
          <div class="arp-countdown-time" id="arp-timer-val">--:--</div>
          <div class="arp-status-badge" id="arp-status-val">ACTIVE</div>
        </div>
        <div class="arp-info-row">
          <span id="arp-mode-val">Fixed Interval</span>
          <span id="arp-count-val">Refreshes: 0</span>
        </div>
        <button class="arp-btn arp-btn-sound" id="arp-enable-sound-btn">🔊 Enable Alert Sound</button>
        <div class="arp-actions">
          <button class="arp-btn arp-btn-danger" id="arp-stop-btn">Stop Refresh</button>
        </div>
      </div>
    `;

    overlayShadow.appendChild(style);
    overlayShadow.appendChild(widget);

    const targetParent = document.body || document.documentElement;
    if (targetParent) {
      targetParent.appendChild(overlayElement);
    }

    // Touch & Mouse Dragging for Mobile Safari
    const header = overlayShadow.querySelector('.arp-header');
    
    const startDrag = (clientX, clientY) => {
      isDragging = true;
      const rect = overlayElement.getBoundingClientRect();
      dragOffsetX = clientX - rect.left;
      dragOffsetY = clientY - rect.top;
    };

    const moveDrag = (clientX, clientY) => {
      if (!isDragging) return;
      const newLeft = clientX - dragOffsetX;
      const newTop = clientY - dragOffsetY;
      overlayElement.style.left = `${Math.max(0, newLeft)}px`;
      overlayElement.style.top = `${Math.max(0, newTop)}px`;
      overlayElement.style.right = 'auto';
    };

    const endDrag = () => {
      isDragging = false;
    };

    header.addEventListener('touchstart', (e) => {
      if (e.touches.length === 1) {
        startDrag(e.touches[0].clientX, e.touches[0].clientY);
      }
    }, { passive: true });

    document.addEventListener('touchmove', (e) => {
      if (isDragging && e.touches.length === 1) {
        moveDrag(e.touches[0].clientX, e.touches[0].clientY);
      }
    }, { passive: true });

    document.addEventListener('touchend', endDrag);

    header.addEventListener('mousedown', (e) => startDrag(e.clientX, e.clientY));
    document.addEventListener('mousemove', (e) => moveDrag(e.clientX, e.clientY));
    document.addEventListener('mouseup', endDrag);

    overlayShadow.querySelector('#arp-close-widget').addEventListener('click', removeOverlay);
    overlayShadow.querySelector('#arp-enable-sound-btn').addEventListener('click', enableAlertAudio);
    overlayShadow.querySelector('#arp-stop-btn').addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH' }, removeOverlay);
    });
    updateSoundEnableControl();
  }

  async function enableAlertAudio() {
    const context = getUnlockedAudioContext();
    if (!context) {
      audioUnlocked = false;
      updateSoundEnableControl('Audio is unavailable');
      updatePreStartSoundControl('Audio is unavailable');
      return;
    }

    try {
      if (context.state === 'suspended') {
        await context.resume();
      }
      audioUnlocked = context.state === 'running';
      if (!audioUnlocked) {
        throw new Error('Safari did not unlock audio');
      }

      // Audible confirmation while this click still carries user activation.
      playAlertSound();
      updateSoundEnableControl();
      updatePreStartSoundControl();
    } catch (error) {
      audioUnlocked = false;
      logDebug('SOUND', 'Could not enable alerts: ' + error.message, 'error');
      updateSoundEnableControl('Tap again to enable sound');
      updatePreStartSoundControl('Tap again to enable sound');
    }
  }

  function updateSoundEnableControl(failureText = '') {
    if (!overlayShadow) return;
    const button = overlayShadow.querySelector('#arp-enable-sound-btn');
    if (!button) return;

    if (!currentTabState || !currentTabState.monitorEnabled || currentTabState.actionSound === false) {
      button.style.display = 'none';
      return;
    }

    button.style.display = 'block';
    button.classList.toggle('is-enabled', audioUnlocked);
    button.textContent = audioUnlocked
      ? '✓ Alert Sound Enabled'
      : (failureText || '🔊 Enable Alert Sound');
  }

  function renderPreStartSoundControl() {
    if (preStartSoundHost) {
      updatePreStartSoundControl();
      return;
    }

    preStartSoundHost = document.createElement('div');
    preStartSoundHost.id = 'arp-prestart-sound-host';
    preStartSoundHost.style.cssText = 'position:fixed;top:16px;right:16px;z-index:2147483647;';
    preStartSoundShadow = preStartSoundHost.attachShadow({ mode: 'open' });
    preStartSoundShadow.innerHTML = `
      <style>
        .panel { width: 230px; padding: 14px; border-radius: 12px; background: #0f172a; color: #f8fafc;
          border: 1px solid rgba(0,242,254,.45); box-shadow: 0 12px 30px rgba(0,0,0,.5);
          font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif; }
        .title { font-size: 14px; font-weight: 800; color: #00f2fe; margin-bottom: 5px; }
        .help { font-size: 11px; line-height: 1.35; color: #cbd5e1; margin-bottom: 10px; }
        button { width: 100%; padding: 9px; border: 0; border-radius: 7px; background: #0284c7;
          color: white; font-size: 12px; font-weight: 800; }
        button.enabled { background: #15803d; }
        .close { margin-top: 7px; background: transparent; color: #94a3b8; font-weight: 600; }
      </style>
      <div class="panel">
        <div class="title">Alert Sound Setup</div>
        <div class="help">Tap below now. The sound will remain enabled when you start monitoring this page.</div>
        <button id="enable">🔊 Enable and Test Sound</button>
        <button class="close" id="close">Close</button>
      </div>`;

    (document.body || document.documentElement).appendChild(preStartSoundHost);
    preStartSoundShadow.querySelector('#enable').addEventListener('click', enableAlertAudio);
    preStartSoundShadow.querySelector('#close').addEventListener('click', removePreStartSoundControl);
    updatePreStartSoundControl();
  }

  function updatePreStartSoundControl(failureText = '') {
    if (!preStartSoundShadow) return;
    const button = preStartSoundShadow.querySelector('#enable');
    if (!button) return;
    button.classList.toggle('enabled', audioUnlocked);
    button.textContent = audioUnlocked
      ? '✓ Alert Sound Enabled'
      : (failureText || '🔊 Enable and Test Sound');
  }

  function removePreStartSoundControl() {
    if (preStartSoundHost) preStartSoundHost.remove();
    preStartSoundHost = null;
    preStartSoundShadow = null;
  }

  function updateOverlayCountdown(remainingSeconds, refreshCount, maxRefreshes) {
    if (!overlayShadow) return;

    const timerVal = overlayShadow.querySelector('#arp-timer-val');
    const countVal = overlayShadow.querySelector('#arp-count-val');
    const modeVal = overlayShadow.querySelector('#arp-mode-val');

    if (timerVal) {
      const mins = Math.floor(remainingSeconds / 60);
      const secs = remainingSeconds % 60;
      timerVal.textContent = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    }

    if (countVal) {
      if (maxRefreshes > 0) {
        countVal.textContent = `Refreshes: ${refreshCount}/${maxRefreshes}`;
      } else {
        countVal.textContent = `Refreshes: ${refreshCount}`;
      }
    }

    if (modeVal && currentTabState) {
      modeVal.textContent = currentTabState.mode === 'random'
        ? `Random (${currentTabState.minInterval}-${currentTabState.maxInterval}s)`
        : `Every ${currentTabState.interval}s`;
    }
  }

  let isInteractionListenerAttached = false;

  function setupUserInteractionListener() {
    if (isInteractionListenerAttached) return;
    isInteractionListenerAttached = true;

    const handleUserInteraction = (e) => {
      if (overlayElement) {
        if (overlayElement === e.target || overlayElement.contains(e.target)) return;
        if (e.composedPath && e.composedPath().includes(overlayElement)) return;
      }

      if (currentTabState && currentTabState.enabled) {
        currentTabState.enabled = false;
        removeUserInteractionListener();
        chrome.runtime.sendMessage({ type: 'STOP_REFRESH' });
        removeOverlay();
      }
    };

    window.addEventListener('click', handleUserInteraction, { capture: true, passive: true });
    window.addEventListener('touchstart', handleUserInteraction, { capture: true, passive: true });
    window.addEventListener('keydown', handleUserInteraction, { capture: true, passive: true });

    function removeUserInteractionListener() {
      isInteractionListenerAttached = false;
      window.removeEventListener('click', handleUserInteraction, { capture: true });
      window.removeEventListener('touchstart', handleUserInteraction, { capture: true });
      window.removeEventListener('keydown', handleUserInteraction, { capture: true });
    }
  }

  function removeOverlay() {
    if (overlayElement) {
      overlayElement.remove();
      overlayElement = null;
      overlayShadow = null;
    }
  }
})();
