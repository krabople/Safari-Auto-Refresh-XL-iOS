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

  try {
    const tabs = await chrome.tabs.query({ active: true });
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

  toggleRandom.addEventListener('change', () => {
    if (toggleRandom.checked) {
      randomInputs.classList.remove('hidden');
    } else {
      randomInputs.classList.add('hidden');
    }
  });

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

  startStopBtn.addEventListener('click', () => {
    const isActive = statusDot.classList.contains('active');

    if (isActive) {
      updateActiveStatus(false);
      chrome.runtime.sendMessage({ type: 'STOP_REFRESH', tabId: currentTabId });
    } else {
      updateActiveStatus(true);
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
        actionNotify: true,
        actionHighlight: actHighlight ? actHighlight.checked : true,
        actionScroll: actScroll ? actScroll.checked : true,
        actionFocus: false
      };

      chrome.runtime.sendMessage({ type: 'START_REFRESH', tabId: currentTabId, state: statePayload });
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

  function playPopupSound() {
    const uri = getChimeAudioURI();
    if (uri) {
      const audio = new Audio(uri);
      audio.play().catch(e => console.warn('Popup audio play error:', e));
    }
  }

  const btnTestSound = document.getElementById('btnTestSound');

  if (btnTestSound) {
    btnTestSound.addEventListener('click', () => {
      playPopupSound();
      if (currentTabId) {
        chrome.tabs.sendMessage(currentTabId, { type: 'TEST_SOUND' }).catch(() => {});
      }
    });
  }

  const logConsoleContainer = document.getElementById('logConsoleContainer');
  const btnClearLogs = document.getElementById('btnClearLogs');
  const btnTestSoundLogs = document.getElementById('btnTestSoundLogs');
  const btnTestPushLogs = document.getElementById('btnTestPushLogs');

  function renderLogs() {
    if (!logConsoleContainer) return;
    chrome.runtime.sendMessage({ type: 'GET_LOGS' }, (response) => {
      if (chrome.runtime.lastError || !response || !response.logs) return;
      const logs = response.logs;
      if (logs.length === 0) {
        logConsoleContainer.innerHTML = '<div style="color: #64748b; font-style: italic;">No activity logged yet.</div>';
        return;
      }
      logConsoleContainer.innerHTML = logs.map(entry => {
        const colorClass = entry.type === 'error' ? '#f87171' : entry.type === 'success' ? '#4ade80' : entry.type === 'warn' ? '#fbbf24' : '#38bdf8';
        return `<div style="line-height: 1.3;"><span style="color: #64748b;">[${entry.timestamp}]</span> <strong style="color: ${colorClass};">[${entry.category}]</strong> ${escapeHTML(entry.message)}</div>`;
      }).join('');
      logConsoleContainer.scrollTop = logConsoleContainer.scrollHeight;
    });
  }

  function escapeHTML(str) {
    return (str || '').replace(/[&<>'"]/g, tag => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[tag] || tag));
  }

  if (btnClearLogs) {
    btnClearLogs.addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'CLEAR_LOGS' }, () => {
        renderLogs();
      });
    });
  }

  if (btnTestSoundLogs) {
    btnTestSoundLogs.addEventListener('click', () => {
      playPopupSound();
      if (currentTabId) {
        chrome.tabs.sendMessage(currentTabId, { type: 'TEST_SOUND' }).catch(() => {});
      }
    });
  }

  if (btnTestPushLogs) {
    btnTestPushLogs.addEventListener('click', () => {
      chrome.runtime.sendMessage({ type: 'TEST_NATIVE_ALERT' }, () => {
        renderLogs();
      });
    });
  }

  document.querySelectorAll('.nav-tab').forEach(tab => {
    tab.addEventListener('click', (e) => {
      if (e.target.getAttribute('data-tab') === 'tab-logs') {
        renderLogs();
      }
    });
  });

  setInterval(renderLogs, 1500);
});
