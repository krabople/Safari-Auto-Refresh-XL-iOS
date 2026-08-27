// Auto Refresh XL - iOS Safari Content Script

(function () {
  const isTopFrame = window.top === window;
  let currentTabState = null;
  let overlayElement = null;
  let overlayShadow = null;
  let overlayDismissed = false;
  let isDragging = false;
  let dragOffsetX = 0;
  let dragOffsetY = 0;
  let hasTriggeredTarget = false;
  let monitorIntervalId = null;
  let monitorObserver = null;
  let monitorCheckTimer = null;
  let audioUnlocked = false;
  let soundAlertsEnabled = true;

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
        if (audioUnlocked) {
          window.removeEventListener('touchstart', unlockAudioOnTouch, true);
          window.removeEventListener('click', unlockAudioOnTouch, true);
        }
      };
      if (context.state === 'running') {
        markUnlocked();
      } else {
        context.resume().then(markUnlocked).catch(() => {});
      }
    }
  };
  window.addEventListener('touchstart', unlockAudioOnTouch, { capture: true, passive: true });
  window.addEventListener('click', unlockAudioOnTouch, { capture: true, passive: true });

  chrome.runtime.sendMessage({ type: 'GET_TAB_STATE' }, (response) => {
    if (chrome.runtime.lastError || !response || !response.state) return;
    currentTabState = response.state;
    soundAlertsEnabled = currentTabState.soundEnabled !== false;

    if (currentTabState.enabled) {
      initContentFeatures();
    } else if (currentTabState.monitorEnabled && currentTabState.targetText &&
               Number(currentTabState.refreshCount || 0) > 0) {
      // The maximum-refresh limit may stop the timer as the final navigation
      // begins. The final refreshed page must still receive its promised check.
      startMonitoringLoop();
    }
  });

  chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === 'COUNTDOWN_TICK') {
      currentTabState = request.state;
      soundAlertsEnabled = currentTabState.soundEnabled !== false;
      if (currentTabState && currentTabState.overlayEnabled && !overlayElement) {
        renderFloatingOverlay();
      }
      updateOverlayCountdown(request.remainingSeconds, request.refreshCount, request.maxRefreshes);
      initContentFeatures();
    } else if (request.type === 'REFRESH_STARTED') {
      currentTabState = request.state;
      soundAlertsEnabled = currentTabState.soundEnabled !== false;
      hasTriggeredTarget = false;
      getUnlockedAudioContext();
      initContentFeatures();
    } else if (request.type === 'STATE_SYNC') {
      currentTabState = request.state;
      soundAlertsEnabled = currentTabState.soundEnabled !== false;
      initContentFeatures();
    } else if (request.type === 'REFRESH_STOPPED') {
      if (currentTabState) currentTabState.enabled = false;
      stopMonitoringLoop();
      removeOverlay();
    } else if (request.type === 'SOUND_PREFERENCE_SYNC') {
      soundAlertsEnabled = request.enabled !== false;
      if (currentTabState) currentTabState.soundEnabled = soundAlertsEnabled;
      updateSoundEnableControl();
    } else if (request.type === 'TEST_SOUND') {
      playAlertSound();
    } else if (request.type === 'GET_AUDIO_STATUS') {
      sendResponse({ unlocked: audioUnlocked && sharedAudioCtx && sharedAudioCtx.state === 'running' });
    } else if (request.type === 'PRESENT_TARGET_ALERT') {
      const shouldAttemptSound = request.playSound !== false && soundAlertsEnabled;
      (async () => {
        const soundPlayed = shouldAttemptSound ? await playAlertSound() : false;
        showTargetAlertBanner(
          request.targetText || 'Keyword',
          request.sourceTabId,
          request.showOpenTabButton === true,
          shouldAttemptSound && !soundPlayed
        );
        sendResponse({ success: true, soundPlayed });
      })();
      return true;
    } else if (request.type === 'APPLY_DETECTED_PAGE_ACTIONS') {
      applyDetectedPageActions(request).then(sendResponse);
      return true;
    }
  });

  function initContentFeatures() {
    if (!currentTabState) return;

    // The background state belongs to the whole tab. Running the monitor in
    // every iframe can produce duplicate/incorrect detections and stop the tab.
    if (!isTopFrame) return;

    const needsSoundControl = currentTabState.monitorEnabled &&
      currentTabState.targetText &&
      currentTabState.actionSound !== false &&
      !audioUnlocked;

    // iOS requires a control inside the webpage to unlock audio. Show the
    // compact widget for that control even when the optional timer overlay is off.
    if (isTopFrame && (currentTabState.overlayEnabled !== false || needsSoundControl) && !overlayElement) {
      renderFloatingOverlay();
    }

    if (currentTabState.monitorEnabled && currentTabState.targetText && currentTabState.actionSound !== false) {
      updateSoundEnableControl();
    }

    if (currentTabState.stopOnInteraction) {
      setupUserInteractionListener();
    }

    // Monitoring deliberately begins only after the first completed refresh.
    // Scan the rendered DOM immediately, then continue watching sites which
    // insert or replace their content after the load event.
    if (currentTabState.monitorEnabled && currentTabState.targetText &&
        Number(currentTabState.refreshCount || 0) > 0 && !hasTriggeredTarget) {
      startMonitoringLoop();
    } else if (!currentTabState.monitorEnabled || !currentTabState.targetText) {
      stopMonitoringLoop();
    }
  }

  function startMonitoringLoop() {
    if (hasTriggeredTarget) return;

    queueMonitoringCheck();

    if (!monitorObserver) {
      const root = document.body || document.documentElement;
      if (root) {
        monitorObserver = new MutationObserver(queueMonitoringCheck);
        monitorObserver.observe(root, {
          subtree: true,
          childList: true,
          characterData: true
        });
      }
    }

    // MutationObserver covers most modern sites. Polling also catches framework
    // updates which Safari occasionally coalesces in a non-foreground tab.
    if (!monitorIntervalId) {
      monitorIntervalId = setInterval(queueMonitoringCheck, 1500);
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

  function checkPageMonitoring(sourceDocument = document) {
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
      isFound = normalizePlainText(bodyText).includes(normalizePlainText(target));
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
      if (currentTabState.actionHighlight !== false) {
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

    // Presentation is routed by the background worker to whichever Safari tab
    // the user is currently viewing. This source tab only performs page actions.
    try {
      const targetToScroll = highlightedEl || matchedNode;
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
          statusBadge.textContent = ARXL_I18N.t('TARGET DETECTED!');
          statusBadge.className = 'arp-status-badge arp-detected';
        }
      }
      return true;
    }

  function showTargetAlertBanner(targetText, sourceTabId, showOpenTabButton, showEnableSoundButton) {
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
        🎯 ${ARXL_I18N.t('TARGET DETECTED!')}
      </div>
      <div style="font-size: 13px; color: #cbd5e1; margin-bottom: 12px;">
        ${ARXL_I18N.t('Keyword')} <strong style="color: #fff;">"${escapeHTML(targetText)}"</strong> ${ARXL_I18N.t('was detected on the monitored page.')}
      </div>
      ${showEnableSoundButton ? `<button id="arp-banner-enable-sound" style="
        background: #15803d;
        color: #fff;
        border: none;
        padding: 8px 18px;
        margin-right: 6px;
        border-radius: 8px;
        font-weight: 800;
        font-size: 13px;
        cursor: pointer;
      ">${ARXL_I18N.t('Enable Sound')}</button>` : ''}
      ${showOpenTabButton ? `<button id="arp-banner-open-tab" style="
        background: linear-gradient(135deg, #00f2fe, #0284c7);
        color: #000;
        border: none;
        padding: 8px 18px;
        margin-right: 6px;
        border-radius: 8px;
        font-weight: 800;
        font-size: 13px;
        cursor: pointer;
      ">${ARXL_I18N.t('View Monitored Tab')}</button>` : ''}
      <button id="arp-banner-dismiss" style="
        background: linear-gradient(135deg, #00f2fe, #0284c7);
        color: #000;
        border: none;
        padding: 8px 18px;
        border-radius: 8px;
        font-weight: 800;
        font-size: 13px;
        cursor: pointer;
      ">${ARXL_I18N.t('Dismiss Alert')}</button>
    `;

    document.body.appendChild(banner);

    document.getElementById('arp-banner-dismiss')?.addEventListener('click', () => {
      banner.remove();
    });
    document.getElementById('arp-banner-open-tab')?.addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'FOCUS_MONITORED_TAB', tabId: sourceTabId });
      banner.remove();
    });
    document.getElementById('arp-banner-enable-sound')?.addEventListener('click', async (event) => {
      const button = event.currentTarget;
      await enableAlertAudio();
      button.remove();
    });
  }

  async function applyDetectedPageActions(request) {
    currentTabState = request.state || currentTabState;
    const shouldHighlight = !currentTabState || currentTabState.actionHighlight !== false;
    const shouldScroll = (!currentTabState || currentTabState.actionScroll !== false) && request.performScroll !== false;
    if (!shouldHighlight && !shouldScroll) return { success: true, found: false };

    // Give client-rendered pages a short opportunity to insert their content,
    // while retaining the extension's existing highlight appearance.
    for (let attempt = 0; attempt < 10; attempt += 1) {
      let matchedElement = document.querySelector('.arp-exact-word-highlight');
      if (shouldHighlight) {
        matchedElement = matchedElement || highlightMatchingText(request.targetText, request.matchType || 'text');
      } else if ((request.matchType || 'text') === 'xpath') {
        try {
          const result = document.evaluate(request.targetText, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
          matchedElement = result.singleNodeValue;
        } catch (error) {}
      } else {
        try {
          const regex = request.matchType === 'regex'
            ? new RegExp(request.targetText, 'i')
            : new RegExp(escapeRegExp(request.targetText), 'i');
          const matchedNode = findTextNodeMatching(regex, document);
          matchedElement = matchedNode && (matchedNode.parentElement || matchedNode);
        } catch (error) {}
      }
      if (matchedElement) {
        if (shouldScroll && typeof matchedElement.scrollIntoView === 'function') {
          matchedElement.scrollIntoView({ behavior: 'auto', block: 'center', inline: 'nearest' });
          await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)));
          matchedElement.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
          await new Promise(resolve => setTimeout(resolve, 900));
          if (matchedElement.isConnected) {
            matchedElement.scrollIntoView({ behavior: 'auto', block: 'center', inline: 'nearest' });
          }
        }
        return { success: true, found: true };
      }
      await new Promise(resolve => setTimeout(resolve, 400));
    }
    return { success: true, found: false };
  }

  function getPageText(sourceDocument = document) {
    const root = sourceDocument.body || sourceDocument.documentElement;
    if (!root) return '';
    return getSearchRoots(sourceDocument).map(searchRoot => {
      // innerText reflects what the page renders and avoids false matches from
      // scripts/styles. ShadowRoot has no innerText, so use its textContent.
      const rendered = searchRoot.innerText;
      if (typeof rendered === 'string' && rendered.trim()) return rendered;
      return searchRoot.textContent || '';
    }).join(' ');
  }

  function normalizePlainText(value) {
    const text = String(value || '');
    const compatible = typeof text.normalize === 'function' ? text.normalize('NFKC') : text;
    return compatible.replace(/[\u00a0\s]+/g, ' ').trim().toLocaleLowerCase();
  }

  function getSearchRoots(sourceDocument = document) {
    const initialRoot = sourceDocument.body || sourceDocument.documentElement;
    if (!initialRoot) return [];
    const roots = [initialRoot];
    for (let index = 0; index < roots.length; index += 1) {
      const searchRoot = roots[index];
      if (!searchRoot.querySelectorAll) continue;
      searchRoot.querySelectorAll('*').forEach(element => {
        if (element.id === 'auto-refresh-plus-widget-host' ||
            element.id === 'arp-target-alert-banner' ||
            element.closest('#auto-refresh-plus-widget-host, #arp-target-alert-banner')) {
          return;
        }
        if (element.shadowRoot && !roots.includes(element.shadowRoot)) {
          roots.push(element.shadowRoot);
        }
      });
    }
    return roots;
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

    const matchingTextNodes = [];
    getSearchRoots(document).forEach(searchRoot => {
      const walker = document.createTreeWalker(
        searchRoot,
        NodeFilter.SHOW_TEXT,
        {
          acceptNode: function (node) {
            regex.lastIndex = 0;
            if (!node.nodeValue || !regex.test(node.nodeValue)) {
              return NodeFilter.FILTER_REJECT;
            }
            const parent = node.parentElement;
            if (!parent) return NodeFilter.FILTER_REJECT;
            if (parent.closest('#arp-target-alert-banner') || parent.closest('#auto-refresh-plus-widget-host') || parent.closest('.arp-exact-word-highlight')) {
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

      let textNode;
      while ((textNode = walker.nextNode())) {
        matchingTextNodes.push(textNode);
      }
    });

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
    for (const searchRoot of getSearchRoots(sourceDocument)) {
      const walker = sourceDocument.createTreeWalker(searchRoot, NodeFilter.SHOW_TEXT, null, false);
      let node;
      while ((node = walker.nextNode())) {
        regex.lastIndex = 0;
        if (regex.test(node.nodeValue) && node.parentElement &&
            !node.parentElement.closest('#arp-target-alert-banner, #auto-refresh-plus-widget-host')) {
          return node.parentElement;
        }
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

  async function playAlertSound() {
    logDebug('SOUND', 'Attempting audio playback (HTML5 Audio + Web Audio API)...');

    let played = false;
    try {
      const uri = getChimeAudioURI();
      if (uri) {
        const audio = new Audio(uri);
        audio.volume = 1.0;
        await audio.play().then(() => {
          played = true;
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
          await ctx.resume();
          audioUnlocked = ctx.state === 'running';
          logDebug('SOUND', 'Web AudioContext resumed', 'success');
        }
        if (ctx.state !== 'running') return played;
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
        played = true;
        logDebug('SOUND', '🔊 Web Audio Oscillator tone triggered!', 'success');
      } else {
        logDebug('SOUND', '⚠️ Web AudioContext unavailable', 'warn');
      }
    } catch (e) {
      logDebug('SOUND', '🔴 Web Audio Exception: ' + e.message, 'error');
    }
    return played;
  }

  function renderFloatingOverlay() {
    if (overlayElement || overlayDismissed || !isTopFrame) return;

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
      .arp-monitor-term {
        margin: -1px 0 8px;
        padding: 5px 7px;
        border-radius: 5px;
        background: rgba(14, 165, 233, 0.12);
        color: #bae6fd;
        font-size: 10px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
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
        width: 100%;
        box-sizing: border-box;
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
          <div class="arp-status-badge" id="arp-status-val">${ARXL_I18N.t('ACTIVE')}</div>
        </div>
        <div class="arp-info-row">
          <span id="arp-mode-val">${ARXL_I18N.t('Fixed Interval')}</span>
          <span id="arp-count-val">${ARXL_I18N.t('Refreshes:')} 0</span>
        </div>
        <div class="arp-monitor-term" id="arp-monitor-term" hidden></div>
        <button class="arp-btn arp-btn-sound" id="arp-enable-sound-btn">🔊 ${ARXL_I18N.t('Enable Alert Sound')}</button>
        <div class="arp-actions">
          <button class="arp-btn arp-btn-danger" id="arp-stop-btn">${ARXL_I18N.t('Stop Refresh')}</button>
        </div>
      </div>
    `;

    overlayShadow.appendChild(style);
    overlayShadow.appendChild(widget);
    updateOverlayMonitorTerm();

    const targetParent = document.body || document.documentElement;
    if (targetParent) {
      targetParent.appendChild(overlayElement);
    }

    applySavedOverlayPosition();

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
      const rect = overlayElement.getBoundingClientRect();
      const maxLeft = Math.max(0, window.innerWidth - rect.width);
      const maxTop = Math.max(0, window.innerHeight - rect.height);
      const newLeft = Math.min(maxLeft, Math.max(0, clientX - dragOffsetX));
      const newTop = Math.min(maxTop, Math.max(0, clientY - dragOffsetY));
      overlayElement.style.left = `${newLeft}px`;
      overlayElement.style.top = `${newTop}px`;
      overlayElement.style.right = 'auto';
    };

    const endDrag = () => {
      if (!isDragging) return;
      isDragging = false;
      const rect = overlayElement && overlayElement.getBoundingClientRect();
      if (!rect) return;
      const position = { left: Math.round(rect.left), top: Math.round(rect.top) };
      if (currentTabState) currentTabState.overlayPosition = position;
      chrome.runtime.sendMessage({ type: 'SET_OVERLAY_POSITION', position });
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

    overlayShadow.querySelector('#arp-close-widget').addEventListener('click', () => {
      overlayDismissed = true;
      removeOverlay();
    });
    overlayShadow.querySelector('#arp-enable-sound-btn').addEventListener('click', toggleAlertAudio);
    overlayShadow.querySelector('#arp-stop-btn').addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH' }, removeOverlay);
    });
    updateSoundEnableControl();
  }

  async function enableAlertAudio() {
    soundAlertsEnabled = true;
    if (currentTabState) currentTabState.soundEnabled = true;
    await setSoundPreference(true);
    const context = getUnlockedAudioContext();
    if (!context) {
      audioUnlocked = false;
      updateSoundEnableControl(ARXL_I18N.t('Audio is unavailable'));
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
    } catch (error) {
      audioUnlocked = false;
      logDebug('SOUND', 'Could not enable alerts: ' + error.message, 'error');
      updateSoundEnableControl(ARXL_I18N.t('Tap again to enable sound'));
    }
  }

  async function toggleAlertAudio() {
    if (soundAlertsEnabled) {
      soundAlertsEnabled = false;
      if (currentTabState) currentTabState.soundEnabled = false;
      updateSoundEnableControl();
      await setSoundPreference(false);
      return;
    }

    soundAlertsEnabled = true;
    if (currentTabState) currentTabState.soundEnabled = true;
    await enableAlertAudio();
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
    const isEnabled = soundAlertsEnabled;
    button.classList.toggle('is-enabled', isEnabled);
    button.textContent = isEnabled
      ? `🔇 ${ARXL_I18N.t('Disable Alert Sound')}`
      : (failureText || `🔊 ${ARXL_I18N.t('Enable Alert Sound')}`);
  }

  function setSoundPreference(enabled) {
    return new Promise((resolve) => {
      chrome.runtime.sendMessage({ type: 'SET_SOUND_ENABLED', enabled }, () => resolve());
    });
  }

  function applySavedOverlayPosition() {
    if (!overlayElement || !currentTabState || !currentTabState.overlayPosition) return;
    const savedLeft = Number(currentTabState.overlayPosition.left);
    const savedTop = Number(currentTabState.overlayPosition.top);
    if (!Number.isFinite(savedLeft) || !Number.isFinite(savedTop)) return;

    const rect = overlayElement.getBoundingClientRect();
    const maxLeft = Math.max(0, window.innerWidth - rect.width);
    const maxTop = Math.max(0, window.innerHeight - rect.height);
    overlayElement.style.left = `${Math.min(maxLeft, Math.max(0, savedLeft))}px`;
    overlayElement.style.top = `${Math.min(maxTop, Math.max(0, savedTop))}px`;
    overlayElement.style.right = 'auto';
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
        countVal.textContent = `${ARXL_I18N.t('Refreshes:')} ${refreshCount}/${maxRefreshes}`;
      } else {
        countVal.textContent = `${ARXL_I18N.t('Refreshes:')} ${refreshCount}`;
      }
    }

    if (modeVal && currentTabState) {
      modeVal.textContent = currentTabState.mode === 'random'
        ? `${ARXL_I18N.t('Random')} (${currentTabState.minInterval}-${currentTabState.maxInterval}s)`
        : `${ARXL_I18N.t('Every')} ${currentTabState.interval}s`;
    }
    updateOverlayMonitorTerm();
  }

  function updateOverlayMonitorTerm() {
    if (!overlayShadow) return;
    const term = overlayShadow.querySelector('#arp-monitor-term');
    if (!term) return;
    const monitoredText = currentTabState && currentTabState.monitorEnabled
      ? String(currentTabState.targetText || '').trim()
      : '';
    term.hidden = !monitoredText;
    term.textContent = monitoredText ? `${ARXL_I18N.t('Monitoring:')} “${monitoredText}”` : '';
    term.title = monitoredText;
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
