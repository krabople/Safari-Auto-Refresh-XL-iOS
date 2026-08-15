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
  const actNotify = document.getElementById('actNotify');
  const actHighlight = document.getElementById('actHighlight');
  const actScroll = document.getElementById('actScroll');
  const actFocus = document.getElementById('actFocus');

  const btnAddCurrentDomain = document.getElementById('btnAddCurrentDomain');
  const btnOpenOptions = document.getElementById('btnOpenOptions');
  const linkEmail = document.getElementById('linkEmail');
  const btnReview = document.getElementById('btnReview');
  const btnDonate = document.getElementById('btnDonate');

  let currentTabId = null;
  let activeState = null;

  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  if (tab && tab.id) {
    currentTabId = tab.id;
  }

  if (currentTabId) {
    chrome.runtime.sendMessage({ type: 'GET_TAB_STATE', tabId: currentTabId }, (response) => {
      if (response && response.state) {
        activeState = response.state;
        populateUI(activeState);
      }
    });
  }

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

  toggleRandom.addEventListener('change', () => {
    if (toggleRandom.checked) {
      randomInputs.classList.remove('hidden');
    } else {
      randomInputs.classList.add('hidden');
    }
  });

  function populateUI(state) {
    const intervalSec = state.interval || 30;
    inputHours.value = Math.floor(intervalSec / 3600);
    inputMinutes.value = Math.floor((intervalSec % 3600) / 60);
    inputSeconds.value = intervalSec % 60;

    toggleRandom.checked = state.mode === 'random';
    if (toggleRandom.checked) randomInputs.classList.remove('hidden');

    inputMinSec.value = state.minInterval || 5;
    inputMaxSec.value = state.maxInterval || 15;
    inputMaxRefreshes.value = state.maxRefreshes || 0;
    toggleHardRefresh.checked = !!state.hardRefresh;
    toggleOverlay.checked = state.overlayEnabled !== false;
    toggleStopOnInteraction.checked = !!state.stopOnInteraction;

    presetChips.forEach(chip => {
      chip.classList.toggle('active', parseInt(chip.dataset.seconds, 10) === intervalSec);
    });

    toggleMonitor.checked = !!state.monitorEnabled;
    targetText.value = state.targetText || '';
    matchType.value = state.matchType || 'text';
    conditionType.value = state.condition || 'appears';
    actStop.checked = state.actionStop !== false;
    actSound.checked = state.actionSound !== false;
    actNotify.checked = state.actionNotify !== false;
    actHighlight.checked = state.actionHighlight !== false;
    actScroll.checked = state.actionScroll !== false;
    actFocus.checked = state.actionFocus !== false;

    updateActiveStatus(state.enabled);
  }

  function updateActiveStatus(enabled) {
    if (enabled) {
      statusDot.classList.add('active');
      statusText.classList.add('active');
      statusText.textContent = 'ACTIVE';

      startStopBtn.classList.add('stopping');
      startStopText.textContent = 'STOP REFRESH';
    } else {
      statusDot.classList.remove('active');
      statusText.classList.remove('active');
      statusText.textContent = 'IDLE';

      startStopBtn.classList.remove('stopping');
      startStopText.textContent = 'START REFRESH';
      countdownDisplay.textContent = '--:--';
    }
  }

  function getSelectedIntervalSeconds() {
    const h = parseInt(inputHours.value, 10) || 0;
    const m = parseInt(inputMinutes.value, 10) || 0;
    const s = parseInt(inputSeconds.value, 10) || 0;
    const total = h * 3600 + m * 60 + s;
    return Math.max(1, total);
  }

  startStopBtn.addEventListener('click', () => {
    if (!currentTabId) return;

    const isRunning = statusText.textContent === 'ACTIVE';

    if (isRunning) {
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH', tabId: currentTabId }, () => {
        updateActiveStatus(false);
      });
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

        monitorEnabled: toggleMonitor.checked,
        targetText: targetText.value.trim(),
        matchType: matchType.value,
        condition: conditionType.value,
        actionStop: actStop.checked,
        actionSound: actSound.checked,
        actionNotify: actNotify.checked,
        actionHighlight: actHighlight.checked,
        actionScroll: actScroll.checked,
        actionFocus: actFocus.checked
      };

      chrome.runtime.sendMessage({ type: 'START_REFRESH', tabId: currentTabId, state: statePayload }, (res) => {
        if (res && res.success) {
          updateActiveStatus(true);
        }
      });
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

  btnAddCurrentDomain.addEventListener('click', async () => {
    if (!tab || !tab.url) return;
    try {
      const urlObj = new URL(tab.url);
      const pattern = `*://${urlObj.hostname}/*`;
      const { autoStartRules } = await chrome.storage.local.get(['autoStartRules']);
      const rules = autoStartRules || [];
      const exists = rules.some(r => r.pattern === pattern);
      if (!exists) {
        rules.push({
          pattern: pattern,
          enabled: true,
          settings: {
            interval: getSelectedIntervalSeconds(),
            mode: toggleRandom.checked ? 'random' : 'fixed',
            minInterval: parseInt(inputMinSec.value, 10) || 5,
            maxInterval: parseInt(inputMaxSec.value, 10) || 15
          }
        });
        await chrome.storage.local.set({ autoStartRules: rules });
        alert(`Added ${pattern} to Auto-Start Rules!`);
      } else {
        alert(`${pattern} is already in your Auto-Start Rules.`);
      }
    } catch (e) {
      alert('Could not add invalid or special browser URL.');
    }
  });

  btnOpenOptions.addEventListener('click', () => {
    chrome.runtime.openOptionsPage();
  });

  if (linkEmail) {
    linkEmail.addEventListener('click', (e) => {
      e.preventDefault();
      chrome.tabs.create({ url: 'mailto:krabople@gmail.com' });
    });
  }

  if (btnReview) {
    btnReview.addEventListener('click', () => {
      alert('Open Safari Extensions on App Store to leave a review!');
    });
  }

  if (btnDonate) {
    btnDonate.addEventListener('click', () => {
      chrome.tabs.create({ url: 'https://buymeacoffee.com/krabople' });
    });
  }

  const btnTestSound = document.getElementById('btnTestSound');
  const btnTestNotify = document.getElementById('btnTestNotify');

  if (btnTestSound) {
    btnTestSound.addEventListener('click', () => {
      if (currentTabId) {
        chrome.tabs.sendMessage(currentTabId, { type: 'TEST_SOUND' });
      }
    });
  }

  if (btnTestNotify) {
    btnTestNotify.addEventListener('click', () => {
      if (currentTabId) {
        chrome.tabs.sendMessage(currentTabId, { type: 'TEST_NOTIFY' });
      }
    });
  }
});
