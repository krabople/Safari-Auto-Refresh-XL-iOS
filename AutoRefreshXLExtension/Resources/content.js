// Auto Refresh XL - iOS Safari Content Script

(function () {
  let currentTabState = null;
  let overlayElement = null;
  let overlayShadow = null;
  let isDragging = false;
  let dragOffsetX = 0;
  let dragOffsetY = 0;
  let hasTriggeredTarget = false;

  function triggerNativeAlert(targetText) {
    const payload = { type: 'TARGET_DETECTED', targetText: targetText || '' };
    try {
      if (typeof browser !== 'undefined' && browser.runtime && browser.runtime.sendNativeMessage) {
        browser.runtime.sendNativeMessage(payload);
      } else if (chrome.runtime && chrome.runtime.sendNativeMessage) {
        chrome.runtime.sendNativeMessage(payload);
      }
    } catch (e) {
      console.warn('Native message error:', e);
    }
  }

  let sharedAudioCtx = null;

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

  // Unlock AudioContext on user interaction with page
  const unlockAudioOnTouch = () => {
    getUnlockedAudioContext();
    window.removeEventListener('touchstart', unlockAudioOnTouch, true);
    window.removeEventListener('click', unlockAudioOnTouch, true);
  };
  window.addEventListener('touchstart', unlockAudioOnTouch, { capture: true, passive: true });
  window.addEventListener('click', unlockAudioOnTouch, { capture: true, passive: true });

  let monitorIntervalId = null;
  let monitorObserver = null;

  chrome.runtime.sendMessage({ type: 'GET_TAB_STATE' }, (response) => {
    if (chrome.runtime.lastError || !response || !response.state) return;
    currentTabState = response.state;

    if (currentTabState.enabled) {
      initContentFeatures();
    }
  });

  chrome.runtime.onMessage.addListener((request) => {
    if (request.type === 'COUNTDOWN_TICK') {
      currentTabState = request.state;
      updateOverlayCountdown(request.remainingSeconds, request.refreshCount, request.maxRefreshes);
    } else if (request.type === 'REFRESH_STARTED') {
      currentTabState = request.state;
      hasTriggeredTarget = false;
      getUnlockedAudioContext();
      initContentFeatures();
    } else if (request.type === 'REFRESH_STOPPED') {
      if (currentTabState) currentTabState.enabled = false;
      stopMonitoringLoop();
      removeOverlay();
    } else if (request.type === 'TEST_SOUND') {
      playAlertSound();
    } else if (request.type === 'TEST_NOTIFY') {
      showWebNotification('Auto Refresh XL', 'Notification test successful! Alerts are working.');
    } else if (request.type === 'REQUEST_NOTIFICATION_PERMISSION') {
      requestWebNotificationPermission();
    }
  });

  function requestWebNotificationPermission() {
    if (typeof Notification !== 'undefined') {
      Notification.requestPermission().then((perm) => {
        if (perm === 'granted') {
          try {
            new Notification('Auto Refresh XL', {
              body: 'Web Notifications are active! You will receive alerts when target text is detected.',
              icon: 'icons/icon128.png'
            });
          } catch (e) {}
        } else {
          alert('Notification permission state: ' + perm + '\n\nPlease enable Notifications for Safari in your iPhone Settings app.');
        }
      }).catch(() => {
        alert('Please enable Web Notifications for Safari in iOS Settings.');
      });
    } else {
      alert('Web Notification permission requested.');
    }
  }

  function initContentFeatures() {
    if (!currentTabState) return;

    if (currentTabState.monitorEnabled && currentTabState.targetText && !hasTriggeredTarget) {
      checkPageMonitoring();

      // Continuous DOM polling loop every 500ms for dynamic JS/React rendering
      if (!monitorIntervalId) {
        monitorIntervalId = setInterval(() => {
          if (!hasTriggeredTarget && currentTabState && currentTabState.monitorEnabled) {
            checkPageMonitoring();
          } else {
            stopMonitoringLoop();
          }
        }, 500);
      }

      // Continuous DOM MutationObserver
      if (!monitorObserver && document.body) {
        try {
          monitorObserver = new MutationObserver(() => {
            if (!hasTriggeredTarget && currentTabState && currentTabState.monitorEnabled) {
              checkPageMonitoring();
            }
          });
          monitorObserver.observe(document.body, { childList: true, subtree: true, characterData: true });
        } catch (e) {}
      }
    }

    if (currentTabState.overlayEnabled) {
      renderFloatingOverlay();
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
  }

  function checkPageMonitoring() {
    const target = currentTabState.targetText.trim();
    if (!target) return;

    let matchedNode = null;
    let isFound = false;

    if (currentTabState.matchType === 'xpath') {
      try {
        const result = document.evaluate(target, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        matchedNode = result.singleNodeValue;
        isFound = !!matchedNode;
      } catch (e) {
        console.warn('Invalid XPath expression:', target);
      }
    } else if (currentTabState.matchType === 'regex') {
      try {
        const regex = new RegExp(target, 'i');
        const bodyText = (document.body && document.body.innerText) ? document.body.innerText : '';
        isFound = regex.test(bodyText);
        if (isFound) {
          matchedNode = findTextNodeMatching(regex);
        }
      } catch (e) {
        console.warn('Invalid Regular Expression:', target);
      }
    } else {
      const bodyText = (document.body && document.body.innerText) ? document.body.innerText : '';
      isFound = bodyText.toLowerCase().includes(target.toLowerCase());
      if (isFound) {
        matchedNode = findTextNodeMatching(new RegExp(escapeRegExp(target), 'i'));
      }
    }

    const conditionMet = (currentTabState.condition === 'appears' && isFound) ||
                         (currentTabState.condition === 'disappears' && !isFound);

    if (conditionMet) {
      hasTriggeredTarget = true;
      stopMonitoringLoop();

      triggerNativeAlert(currentTabState.targetText);

      if (currentTabState.actionSound) {
        playAlertSound();
      }

      if (currentTabState.actionNotify) {
        showWebNotification('Auto Refresh XL - Target Detected!', `Target expression "${currentTabState.targetText}" was detected!`);
      }

      if (matchedNode && currentTabState.actionHighlight) {
        highlightNode(matchedNode);
      }

      if (matchedNode && currentTabState.actionScroll) {
        matchedNode.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }

      chrome.runtime.sendMessage({ type: 'TARGET_DETECTED' });

      if (overlayShadow) {
        const statusBadge = overlayShadow.querySelector('.arp-status-badge');
        if (statusBadge) {
          statusBadge.textContent = 'TARGET DETECTED!';
          statusBadge.className = 'arp-status-badge arp-detected';
        }
      }
    }
  }

  function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  function findTextNodeMatching(regex) {
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null, false);
    let node;
    while ((node = walker.nextNode())) {
      if (regex.test(node.nodeValue) && node.parentElement && node.parentElement.offsetWidth > 0) {
        return node.parentElement;
      }
    }
    return null;
  }

  function highlightNode(element) {
    if (!element || element.nodeType !== Node.ELEMENT_NODE) return;
    element.classList.add('arp-highlight-target');
    element.style.outline = '3px solid #0EA5E9';
    element.style.backgroundColor = 'rgba(14, 165, 233, 0.25)';
    element.style.transition = 'all 0.3s ease';
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
    const playBurst = () => {
      try {
        const uri = getChimeAudioURI();
        if (uri) {
          const audio = new Audio(uri);
          audio.play().catch(e => console.warn('Audio play error:', e));
        }
      } catch (e) {}

      try {
        const ctx = getUnlockedAudioContext();
        if (ctx) {
          if (ctx.state === 'suspended') {
            ctx.resume().catch(() => {});
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
        }
      } catch (e) {}
    };

    playBurst();
    setTimeout(playBurst, 500);
    setTimeout(playBurst, 1000);
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
        <div class="arp-actions">
          <button class="arp-btn arp-btn-danger" id="arp-stop-btn">Stop Refresh</button>
        </div>
      </div>
    `;

    overlayShadow.appendChild(style);
    overlayShadow.appendChild(widget);
    document.body.appendChild(overlayElement);

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
    overlayShadow.querySelector('#arp-stop-btn').addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH' }, removeOverlay);
    });
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
