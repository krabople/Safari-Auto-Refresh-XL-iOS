// Auto Refresh XL - iOS Safari Content Script

(function () {
  let currentTabState = null;
  let overlayElement = null;
  let overlayShadow = null;
  let isDragging = false;
  let dragOffsetX = 0;
  let dragOffsetY = 0;
  let hasTriggeredTarget = false;

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
      initContentFeatures();
    } else if (request.type === 'REFRESH_STOPPED') {
      if (currentTabState) currentTabState.enabled = false;
      removeOverlay();
    }
  });

  function initContentFeatures() {
    if (!currentTabState) return;

    if (currentTabState.monitorEnabled && currentTabState.targetText && !hasTriggeredTarget) {
      checkPageMonitoring();
    }

    if (currentTabState.overlayEnabled) {
      renderFloatingOverlay();
    }

    if (currentTabState.stopOnInteraction) {
      setupUserInteractionListener();
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
        const bodyText = document.body.innerText || '';
        isFound = regex.test(bodyText);
        if (isFound) {
          matchedNode = findTextNodeMatching(regex);
        }
      } catch (e) {
        console.warn('Invalid Regular Expression:', target);
      }
    } else {
      const bodyText = document.body.innerText || '';
      isFound = bodyText.toLowerCase().includes(target.toLowerCase());
      if (isFound) {
        matchedNode = findTextNodeMatching(new RegExp(escapeRegExp(target), 'i'));
      }
    }

    const conditionMet = (currentTabState.condition === 'appears' && isFound) ||
                         (currentTabState.condition === 'disappears' && !isFound);

    if (conditionMet) {
      hasTriggeredTarget = true;

      if (currentTabState.actionSound) {
        playAlertSound();
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

  function playAlertSound() {
    try {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (!AudioCtx) return;
      const ctx = new AudioCtx();

      const osc1 = ctx.createOscillator();
      const gain1 = ctx.createGain();
      osc1.type = 'sine';
      osc1.frequency.setValueAtTime(659.25, ctx.currentTime);
      gain1.gain.setValueAtTime(0.3, ctx.currentTime);
      gain1.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
      osc1.connect(gain1);
      gain1.connect(ctx.destination);
      osc1.start(ctx.currentTime);
      osc1.stop(ctx.currentTime + 0.4);

      const osc2 = ctx.createOscillator();
      const gain2 = ctx.createGain();
      osc2.type = 'sine';
      osc2.frequency.setValueAtTime(987.77, ctx.currentTime + 0.15);
      gain2.gain.setValueAtTime(0.3, ctx.currentTime + 0.15);
      gain2.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.7);
      osc2.connect(gain2);
      gain2.connect(ctx.destination);
      osc2.start(ctx.currentTime + 0.15);
      osc2.stop(ctx.currentTime + 0.7);
    } catch (e) {
      console.warn('Audio playback restricted:', e);
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
