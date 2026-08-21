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
  const actNotify = document.getElementById('actNotify');
  const actHighlight = document.getElementById('actHighlight');
  const actScroll = document.getElementById('actScroll');
  const actFocus = document.getElementById('actFocus');

  const btnAddCurrentDomain = document.getElementById('btnAddCurrentDomain');
  const btnOpenOptions = document.getElementById('btnOpenOptions');
  const linkEmail = document.getElementById('linkEmail');
  const btnReview = document.getElementById('btnReview');
  const reviewAvailability = document.getElementById('reviewAvailability');
  const soundStartDialog = document.getElementById('soundStartDialog');
  const btnPrepareSound = document.getElementById('btnPrepareSound');
  const btnStartWithoutSound = document.getElementById('btnStartWithoutSound');
  const btnCancelStart = document.getElementById('btnCancelStart');

  let currentTabId = null;
  let activeState = null;

  try {
    const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
    if (tabs && tabs.length > 0) {
      currentTabId = tabs[0].id;
    }
  } catch (e) {
    console.warn('Query tabs error:', e);
  }

  if (currentTabId) {
    chrome.runtime.sendMessage({ type: 'GET_TAB_STATE', tabId: currentTabId }, (response) => {
      if (response && response.state) {
        activeState = response.state;
        populateUI(activeState);
      }
    });
  } else {
    chrome.runtime.sendMessage({ type: 'GET_TAB_STATE' }, (response) => {
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
      toggleMonitor.checked = targetText.value.trim().length > 0;
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
    toggleMonitor.checked = !!state.monitorEnabled || (targetText.value.trim().length > 0);
    matchType.value = state.matchType || 'text';
    conditionType.value = state.condition || 'appears';
    actStop.checked = state.actionStop !== false;
    actSound.checked = state.actionSound !== false;
    if (actNotify) actNotify.checked = state.actionNotify !== false;
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

  function getAudioStatus() {
    if (!currentTabId) return Promise.resolve({ unlocked: false });
    return chrome.tabs.sendMessage(currentTabId, { type: 'GET_AUDIO_STATUS' })
      .catch(() => ({ unlocked: false }));
  }

  function askAboutSound() {
    return new Promise(resolve => {
      soundStartDialog.classList.remove('hidden');

      const finish = choice => {
        soundStartDialog.classList.add('hidden');
        btnPrepareSound.onclick = null;
        btnStartWithoutSound.onclick = null;
        btnCancelStart.onclick = null;
        resolve(choice);
      };

      btnPrepareSound.onclick = () => finish('prepare');
      btnStartWithoutSound.onclick = () => finish('continue');
      btnCancelStart.onclick = () => finish('cancel');
    });
  }

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

  startStopBtn.addEventListener('click', async () => {
    const isActive = statusDot.classList.contains('active');

    if (isActive) {
      updateActiveStatus(false);
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH', tabId: currentTabId });
    } else {
      const intervalSec = getSelectedIntervalSeconds();
      const isRandom = toggleRandom.checked;
      const minSec = parseInt(inputMinSec.value, 10) || 5;
      const maxSec = parseInt(inputMaxSec.value, 10) || 15;

      const hasTarget = targetText && targetText.value.trim().length > 0;
      if (hasTarget && toggleMonitor) {
        toggleMonitor.checked = true;
      }

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

        monitorEnabled: (toggleMonitor && toggleMonitor.checked) || hasTarget,
        targetText: targetText ? targetText.value.trim() : '',
        matchType: matchType ? matchType.value : 'text',
        condition: conditionType ? conditionType.value : 'appears',
        actionStop: actStop ? actStop.checked : true,
        actionSound: actSound ? actSound.checked : true,
        soundEnabled: true,
        actionNotify: actNotify ? actNotify.checked : true,
        actionHighlight: actHighlight ? actHighlight.checked : true,
        actionScroll: actScroll ? actScroll.checked : true,
        actionFocus: actFocus ? actFocus.checked : false
      };

      if (statePayload.monitorEnabled && statePayload.actionSound) {
        const audioStatus = await getAudioStatus();
        if (!audioStatus || !audioStatus.unlocked) {
          const choice = await askAboutSound();
          if (choice === 'cancel') return;
          if (choice === 'prepare') {
            try {
              await chrome.tabs.sendMessage(currentTabId, { type: 'SHOW_PRESTART_SOUND_CONTROL' });
              alert('Return to the webpage and tap “Enable and Test Sound”. Then open the extension and press Start Refresh again.');
            } catch (error) {
              alert('The sound control could not be added to this page. Safari may not allow extensions on it.');
            }
            return;
          }
        }
      }

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

  btnAddCurrentDomain.addEventListener('click', async () => {
    const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
    const currentTab = (tabs && tabs[0]) ? tabs[0] : null;
    if (!currentTab || !currentTab.url) return;
    try {
      const urlObj = new URL(currentTab.url);
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
    const appStoreId = (btnReview.dataset.appStoreId || '').trim();
    if (/^\d+$/.test(appStoreId)) {
      btnReview.addEventListener('click', () => {
        chrome.tabs.create({ url: `https://apps.apple.com/app/id${appStoreId}?action=write-review` });
      });
    } else {
      btnReview.disabled = true;
      btnReview.textContent = '⭐ Reviews Available After Release';
      if (reviewAvailability) {
        reviewAvailability.textContent = 'The direct review link will activate when the App Store assigns this app its numeric ID.';
      }
    }
  }

  const btnTestSound = document.getElementById('btnTestSound');

  if (btnTestSound) {
    btnTestSound.addEventListener('click', () => {
      if (currentTabId) {
        chrome.tabs.sendMessage(currentTabId, { type: 'SHOW_PRESTART_SOUND_CONTROL' })
          .then(() => {
            btnTestSound.textContent = '✓ Button Added to Webpage';
          })
          .catch(() => {
            btnTestSound.textContent = 'Could Not Access This Page';
          });
      }
    });
  }

});
