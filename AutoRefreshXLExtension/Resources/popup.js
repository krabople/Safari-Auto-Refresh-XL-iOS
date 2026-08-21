// Auto Refresh XL - iOS Safari Popup Script

document.addEventListener('DOMContentLoaded', async () => {
  const statusDot = document.getElementById('statusDot');
  const statusText = document.getElementById('statusText');
  const countdownDisplay = document.getElementById('countdownDisplay');
  const startStopBtn = document.getElementById('startStopBtn');
  const startStopText = document.getElementById('startStopText');

  const presetChips = document.querySelectorAll('.chip');
  const inputHours = document.getElementById('inputHours');
  const inputMinutes = document.getElementById('inputMinutes');
  const inputSeconds = document.getElementById('inputSeconds');
  const toggleRandom = document.getElementById('toggleRandom');
  const randomInputs = document.getElementById('randomInputs');
  const presetIntervalControls = document.getElementById('presetIntervalControls');
  const customDurationControls = document.getElementById('customDurationControls');
  const inputMinSec = document.getElementById('inputMinSec');
  const inputMaxSec = document.getElementById('inputMaxSec');
  const inputMaxRefreshes = document.getElementById('inputMaxRefreshes');
  const toggleHardRefresh = document.getElementById('toggleHardRefresh');
  const toggleOverlay = document.getElementById('toggleOverlay');
  const toggleStopOnInteraction = document.getElementById('toggleStopOnInteraction');

  const toggleMonitor = document.getElementById('toggleMonitor');
  const targetText = document.getElementById('targetText');
  const matchType = document.getElementById('matchType');
  const conditionType = document.getElementById('conditionType');
  const actStop = document.getElementById('actStop');
  const actSound = document.getElementById('actSound');
  const actHighlight = document.getElementById('actHighlight');
  const actScroll = document.getElementById('actScroll');
  const actFocus = document.getElementById('actFocus');
  const btnAddCurrentPage = document.getElementById('btnAddCurrentPage');
  const btnOpenOptions = document.getElementById('btnOpenOptions');
  const autoStartResult = document.getElementById('autoStartResult');

  let currentTabId = null;
  let activeState = null;
  let draftReady = false;
  let popupDraftCache = {};
  let targetWasEmpty = true;

  try {
    const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
    if (tabs && tabs.length > 0) {
      currentTabId = tabs[0].id;
    }
  } catch (e) {
    console.warn('Query tabs error:', e);
  }

  const stateRequest = currentTabId
    ? { type: 'GET_TAB_STATE', tabId: currentTabId }
    : { type: 'GET_TAB_STATE' };
  chrome.runtime.sendMessage(stateRequest, async (response) => {
    if (!response || !response.state) return;
    activeState = response.state;
    const { popupDrafts = {} } = await chrome.storage.local.get(['popupDrafts']);
    popupDraftCache = popupDrafts;
    const savedDraft = currentTabId ? popupDraftCache[String(currentTabId)] : null;
    populateUI(activeState.enabled || !savedDraft
      ? activeState
      : Object.assign({}, activeState, savedDraft));
    draftReady = true;
  });

  document.querySelectorAll('.nav-tab').forEach(tabBtn => {
    tabBtn.addEventListener('click', () => {
      document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));

      tabBtn.classList.add('active');
      const targetPane = document.getElementById(tabBtn.dataset.tab);
      if (targetPane) targetPane.classList.add('active');
    });
  });

  presetChips.forEach(chip => {
    chip.addEventListener('click', () => {
      presetChips.forEach(c => c.classList.remove('active'));
      chip.classList.add('active');

      const totalSec = parseInt(chip.dataset.seconds, 10);
      const hrs = Math.floor(totalSec / 3600);
      const mins = Math.floor((totalSec % 3600) / 60);
      const secs = totalSec % 60;

      inputHours.value = hrs;
      inputMinutes.value = mins;
      inputSeconds.value = secs;
    });
  });

  function updateRandomModeUI() {
    const isRandom = toggleRandom.checked;
    randomInputs.classList.toggle('hidden', !isRandom);

    [presetIntervalControls, customDurationControls].forEach(group => {
      if (!group) return;
      group.classList.toggle('interval-controls-disabled', isRandom);
      group.setAttribute('aria-disabled', String(isRandom));
      group.querySelectorAll('button, input').forEach(control => {
        control.disabled = isRandom;
      });
    });
  }

  toggleRandom.addEventListener('change', updateRandomModeUI);

  if (targetText && toggleMonitor) {
    targetText.addEventListener('input', () => {
      const targetIsEmpty = targetText.value.trim().length === 0;
      if (targetIsEmpty) {
        toggleMonitor.checked = false;
      } else if (targetWasEmpty) {
        toggleMonitor.checked = true;
      }
      targetWasEmpty = targetIsEmpty;
    });
  }

  function populateUI(state) {
    const intervalSec = state.interval || 30;
    inputHours.value = Math.floor(intervalSec / 3600);
    inputMinutes.value = Math.floor((intervalSec % 3600) / 60);
    inputSeconds.value = intervalSec % 60;

    toggleRandom.checked = state.mode === 'random';
    updateRandomModeUI();

    inputMinSec.value = state.minInterval || 5;
    inputMaxSec.value = state.maxInterval || 15;
    inputMaxRefreshes.value = state.maxRefreshes || 0;
    toggleHardRefresh.checked = !!state.hardRefresh;
    toggleOverlay.checked = state.overlayEnabled !== false;
    toggleStopOnInteraction.checked = !!state.stopOnInteraction;

    presetChips.forEach(chip => {
      chip.classList.toggle('active', parseInt(chip.dataset.seconds, 10) === intervalSec);
    });

    targetText.value = state.targetText || '';
    targetWasEmpty = targetText.value.trim().length === 0;
    toggleMonitor.checked = !!state.monitorEnabled;
    matchType.value = state.matchType || 'text';
    conditionType.value = state.condition || 'appears';
    actStop.checked = state.actionStop !== false;
    actSound.checked = state.actionSound !== false;
    actHighlight.checked = state.actionHighlight !== false;
    actScroll.checked = state.actionScroll !== false;
    if (actFocus) actFocus.checked = state.actionFocus !== false;

    updateActiveStatus(state.enabled);
  }

  function updateActiveStatus(enabled) {
    if (enabled) {
      statusDot.classList.add('active');
      statusText.classList.add('active');
      statusText.textContent = 'ACTIVE';
      startStopBtn.classList.remove('btn-primary');
      startStopBtn.classList.add('btn-danger');
      startStopText.textContent = 'STOP REFRESH';
    } else {
      statusDot.classList.remove('active');
      statusText.classList.remove('active');
      statusText.textContent = 'INACTIVE';
      countdownDisplay.textContent = '00:00';
      startStopBtn.classList.remove('btn-danger');
      startStopBtn.classList.add('btn-primary');
      startStopText.textContent = 'START REFRESH';
    }
  }

  function getSelectedIntervalSeconds() {
    const h = parseInt(inputHours.value, 10) || 0;
    const m = parseInt(inputMinutes.value, 10) || 0;
    const s = parseInt(inputSeconds.value, 10) || 0;
    const total = h * 3600 + m * 60 + s;
    return Math.max(1, total);
  }

  function collectDraft() {
    return {
      interval: getSelectedIntervalSeconds(),
      mode: toggleRandom.checked ? 'random' : 'fixed',
      minInterval: parseInt(inputMinSec.value, 10) || 5,
      maxInterval: parseInt(inputMaxSec.value, 10) || 15,
      maxRefreshes: parseInt(inputMaxRefreshes.value, 10) || 0,
      hardRefresh: toggleHardRefresh.checked,
      overlayEnabled: toggleOverlay.checked,
      stopOnInteraction: toggleStopOnInteraction.checked,
      monitorEnabled: toggleMonitor.checked,
      targetText: targetText.value,
      matchType: matchType.value,
      condition: conditionType.value,
      actionStop: actStop.checked,
      actionSound: actSound.checked,
      actionHighlight: actHighlight.checked,
      actionScroll: actScroll.checked
    };
  }

  async function saveDraft() {
    if (!draftReady || !currentTabId) return;
    popupDraftCache[String(currentTabId)] = collectDraft();
    await chrome.storage.local.set({ popupDrafts: popupDraftCache });
  }

  document.querySelector('.app-container').addEventListener('input', saveDraft);
  document.querySelector('.app-container').addEventListener('change', saveDraft);
  document.querySelector('.app-container').addEventListener('click', (event) => {
    if (event.target.closest('.chip, .nav-tab')) saveDraft();
  });

  function startRefresh(statePayload) {
    updateActiveStatus(true);
    chrome.runtime.sendMessage({ type: 'START_REFRESH', tabId: currentTabId, state: statePayload }, (response) => {
      if (chrome.runtime.lastError || !response || !response.success) {
        updateActiveStatus(false);
        alert('Auto refresh could not start for this page. Check that Safari allows this extension on the website, then reload the page and try again.');
      } else if (!response.pageReady) {
        alert('The refresh timer started, but Safari has not injected the page controls yet. Reload this webpage once, then start again so the overlay and monitor can attach.');
      }
    });
  }

  startStopBtn.addEventListener('click', () => {
    const isActive = statusDot.classList.contains('active');

    if (isActive) {
      updateActiveStatus(false);
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH', tabId: currentTabId });
    } else {
      const intervalSec = getSelectedIntervalSeconds();
      const isRandom = toggleRandom.checked;
      const minSec = parseInt(inputMinSec.value, 10) || 5;
      const maxSec = parseInt(inputMaxSec.value, 10) || 15;

      const statePayload = {
        enabled: true,
        mode: isRandom ? 'random' : 'fixed',
        interval: intervalSec,
        minInterval: Math.min(minSec, maxSec),
        maxInterval: Math.max(minSec, maxSec),
        maxRefreshes: parseInt(inputMaxRefreshes.value, 10) || 0,
        hardRefresh: toggleHardRefresh.checked,
        overlayEnabled: toggleOverlay.checked,
        stopOnInteraction: toggleStopOnInteraction.checked,

        monitorEnabled: !!(toggleMonitor && toggleMonitor.checked),
        targetText: targetText ? targetText.value.trim() : '',
        matchType: matchType ? matchType.value : 'text',
        condition: conditionType ? conditionType.value : 'appears',
        actionStop: actStop ? actStop.checked : true,
        actionSound: actSound ? actSound.checked : true,
        soundEnabled: true,
        actionHighlight: actHighlight ? actHighlight.checked : true,
        actionScroll: actScroll ? actScroll.checked : true,
        actionFocus: actFocus ? actFocus.checked : false
      };

      saveDraft();
      startRefresh(statePayload);
    }
  });

  chrome.runtime.onMessage.addListener((request) => {
    if (request.type === 'COUNTDOWN_TICK' && request.state && currentTabId) {
      const state = request.state;
      if (state.enabled) {
        updateActiveStatus(true);
        const rem = request.remainingSeconds;
        const mins = Math.floor(rem / 60);
        const secs = rem % 60;
        countdownDisplay.textContent = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
      } else {
        updateActiveStatus(false);
      }
    } else if (request.type === 'REFRESH_STOPPED') {
      updateActiveStatus(false);
    }
  });

  if (btnAddCurrentPage) {
    btnAddCurrentPage.addEventListener('click', async () => {
      const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
      const currentTab = tabs && tabs[0];
      if (!currentTab || !currentTab.url || !/^https?:/i.test(currentTab.url)) {
        if (autoStartResult) autoStartResult.textContent = 'This Safari page cannot be added to Auto-Start.';
        return;
      }

      const exactUrl = currentTab.url;
      const { autoStartRules = [] } = await chrome.storage.local.get(['autoStartRules']);
      const exists = autoStartRules.some(rule =>
        rule && rule.enabled !== false &&
        ((rule.urlMatch === 'exact' && rule.pattern === exactUrl) || rule.exactUrl === exactUrl)
      );

      if (exists) {
        if (autoStartResult) autoStartResult.textContent = '✓ This exact page is already in Auto-Start.';
        return;
      }

      autoStartRules.push({
        pattern: exactUrl,
        exactUrl,
        urlMatch: 'exact',
        enabled: true,
        settings: collectDraft()
      });
      await chrome.storage.local.set({ autoStartRules });
      if (autoStartResult) {
        autoStartResult.textContent = '✓ Exact page added to Auto-Start.';
        autoStartResult.style.color = '#4ade80';
      }
    });
  }

  if (btnOpenOptions) {
    btnOpenOptions.addEventListener('click', () => chrome.runtime.openOptionsPage());
  }

  const btnTestSound = document.getElementById('btnTestSound');

  if (btnTestSound) {
    btnTestSound.addEventListener('click', () => {
      try {
        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        const context = new AudioCtx();
        const now = context.currentTime;
        [880, 1320].forEach((frequency, index) => {
          const oscillator = context.createOscillator();
          const gain = context.createGain();
          oscillator.frequency.value = frequency;
          gain.gain.setValueAtTime(0.0001, now + index * 0.16);
          gain.gain.exponentialRampToValueAtTime(0.28, now + index * 0.16 + 0.01);
          gain.gain.exponentialRampToValueAtTime(0.0001, now + index * 0.16 + 0.22);
          oscillator.connect(gain).connect(context.destination);
          oscillator.start(now + index * 0.16);
          oscillator.stop(now + index * 0.16 + 0.23);
        });
        btnTestSound.textContent = '✓ Sound Played';
        setTimeout(() => { btnTestSound.textContent = '🔊 Test Notification Sound'; }, 1200);
      } catch (error) {
        btnTestSound.textContent = 'Sound Unavailable';
      }
    });
  }

});
