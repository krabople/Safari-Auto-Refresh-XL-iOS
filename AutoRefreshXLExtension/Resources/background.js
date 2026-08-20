const activeTabStates = {};
const extensionLogs = [];
let targetTabId = null;
let tabStatesLoaded = false;

function addLog(category, message, type = 'info') {
  const timestamp = new Date().toLocaleTimeString();
  extensionLogs.push({ timestamp, category, message, type });
  if (extensionLogs.length > 80) extensionLogs.shift();
  console.log(`[AutoRefreshXL] [${category}] ${message}`);
}

addLog('SYSTEM', 'Background service worker initialized');

function scheduleNextRefresh(tabId) {
  const state = activeTabStates[tabId];
  if (!state || !state.enabled) return;

  let intervalSec = state.interval || 10;
  if (state.mode === 'random') {
    const min = Math.min(state.minInterval, state.maxInterval);
    const max = Math.max(state.minInterval, state.maxInterval);
    intervalSec = Math.round((Math.random() * (max - min) + min) * 10) / 10;
  }

  state.nextRefreshTime = Date.now() + intervalSec * 1000;
  saveTabStates();

  if (chrome.alarms) {
    // Alarms are a recovery mechanism when iOS suspends the service worker.
    // The one-second ticker below remains the precise timer while Safari is active.
    chrome.alarms.create(`refresh_tab_${tabId}`, { when: state.nextRefreshTime });
  }
}

if (chrome.alarms && chrome.alarms.onAlarm) {
  chrome.alarms.onAlarm.addListener(async (alarm) => {
    if (alarm.name.startsWith('refresh_tab_')) {
      const tabId = parseInt(alarm.name.replace('refresh_tab_', ''), 10);
      const state = activeTabStates[tabId];
      // A stale alarm can fire after the foreground ticker has already
      // refreshed and scheduled the next cycle. Do not reload twice.
      if (state && state.enabled && Date.now() >= state.nextRefreshTime - 750) {
        await runRefreshCycle(tabId, state);
      }
    }
  });
}

async function triggerNativeAlert(targetText, options = {}) {
  const payload = {
    type: 'TARGET_DETECTED',
    targetText: targetText || '',
    playSound: options.playSound !== false,
    showNotification: options.showNotification !== false
  };
  addLog('NATIVE', 'Sending native message: ' + JSON.stringify(payload));

  try {
    if (typeof browser !== 'undefined' && browser.runtime && browser.runtime.sendNativeMessage) {
      const response = await browser.runtime.sendNativeMessage('application.id', payload);
      if (!response || response.success !== true) {
        throw new Error((response && response.error) || 'Native alert did not report success');
      }
      addLog('NATIVE', 'Native alert completed successfully', 'success');
      return response;
    } else if (chrome.runtime && chrome.runtime.sendNativeMessage) {
      const response = await new Promise((resolve, reject) => {
        chrome.runtime.sendNativeMessage('application.id', payload, (nativeResponse) => {
          if (chrome.runtime.lastError) {
            reject(new Error(chrome.runtime.lastError.message));
          } else {
            resolve(nativeResponse);
          }
        });
      });
      if (!response || response.success !== true) {
        throw new Error((response && response.error) || 'Native alert did not report success');
      }
      addLog('NATIVE', 'Native alert completed successfully', 'success');
      return response;
    } else {
      throw new Error('sendNativeMessage API unavailable');
    }
  } catch (e) {
    addLog('NATIVE', '🔴 Native alert failed: ' + e.message, 'error');
    return { success: false, error: e.message };
  }
}

const DEFAULT_TAB_STATE = {
  enabled: false,
  mode: 'fixed',
  interval: 10,
  minInterval: 5,
  maxInterval: 15,
  nextRefreshTime: 0,
  refreshCount: 0,
  maxRefreshes: 0,
  hardRefresh: false,
  overlayEnabled: true,
  stopOnInteraction: false,

  // Page Monitoring
  monitorEnabled: false,
  targetText: '',
  matchType: 'text',
  condition: 'appears',
  actionStop: true,
  actionSound: true,
  actionNotify: true,
  actionHighlight: true,
  actionScroll: true,
  actionFocus: true
};

// Initialize background worker
chrome.runtime.onInstalled.addListener(async () => {
  console.log('Auto Refresh XL iOS Safari Extension Installed.');
  const data = await chrome.storage.local.get(['autoStartRules', 'globalDefaults']);
  if (!data.autoStartRules) {
    await chrome.storage.local.set({ autoStartRules: [] });
  }
  if (!data.globalDefaults) {
    await chrome.storage.local.set({
      globalDefaults: {
        interval: 10,
        mode: 'fixed',
        minInterval: 5,
        maxInterval: 15,
        maxRefreshes: 0,
        hardRefresh: false,
        overlayEnabled: true,
        stopOnInteraction: false
      }
    });
  }
});

// Restore state before answering a content script. On iOS the worker may be
// recreated for every navigation, so replying with the default state here
// makes the overlay and monitor disappear after reloads.
const tabStatesReady = chrome.storage.local.get(['tabStates']).then((result) => {
  if (result.tabStates) {
    Object.assign(activeTabStates, result.tabStates);
  }
  tabStatesLoaded = true;

  for (const [tabId, state] of Object.entries(activeTabStates)) {
    if (state && state.enabled) {
      // Preserve the saved deadline when iOS recreates the service worker.
      // Resetting it here can keep postponing the first refresh indefinitely.
      if (!state.nextRefreshTime) {
        state.nextRefreshTime = Date.now() + (state.interval || 10) * 1000;
        saveTabStates();
      }
      if (chrome.alarms) {
        chrome.alarms.create(`refresh_tab_${tabId}`, {
          when: Math.max(Date.now() + 100, state.nextRefreshTime)
        });
      }
    }
  }
}).catch((error) => {
  tabStatesLoaded = true;
  addLog('SYSTEM', `Could not restore saved tab states: ${error.message}`, 'error');
});

// Precise foreground timer and countdown UI. The alarm above takes over if
// iOS suspends this worker; keeping both avoids a zero countdown that never
// reloads on browsers that delay short alarms.
setInterval(async () => {
  const now = Date.now();
  const tabIds = Object.keys(activeTabStates);

  for (const tabIdStr of tabIds) {
    const tabId = parseInt(tabIdStr, 10);
    const state = activeTabStates[tabId];

    if (!state || !state.enabled) continue;

    if (now >= state.nextRefreshTime) {
      await runRefreshCycle(tabId, state);
      continue;
    }

    const remainingSeconds = Math.max(0, Math.ceil((state.nextRefreshTime - now) / 1000));
    sendToTab(tabId, {
      type: 'COUNTDOWN_TICK',
      remainingSeconds: remainingSeconds,
      refreshCount: state.refreshCount,
      maxRefreshes: state.maxRefreshes,
      state: state
    });
  }

  updateActiveTabBadge();
}, 1000);

async function runRefreshCycle(tabId, state) {
  if (!state || !state.enabled) return;

  // Persist the completed refresh count before navigation. The newly loaded
  // content script uses this value to begin monitoring only after refresh #1.
  state.refreshCount += 1;

  // Immediately schedule the following cycle so countdown never locks at 00:00.
  // scheduleNextRefresh also persists the incremented refresh count.
  scheduleNextRefresh(tabId);

  try {
    await chrome.tabs.reload(tabId, { bypassCache: !!state.hardRefresh });
    addLog('REFRESH', `Reloaded tab ${tabId} (Count: ${state.refreshCount})`, 'success');
  } catch (err) {
    addLog('REFRESH', `Failed to reload tab ${tabId}: ${err.message}`, 'error');
  }

  if (state.maxRefreshes > 0 && state.refreshCount >= state.maxRefreshes) {
    state.enabled = false;
    saveTabStates();
    if (chrome.alarms) chrome.alarms.clear(`refresh_tab_${tabId}`);

    if (state.actionNotify) {
      chrome.notifications.create(`limit_${tabId}_${Date.now()}`, {
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: 'Auto Refresh XL - Limit Reached',
        message: `Tab completed its limit of ${state.maxRefreshes} refreshes.`,
        priority: 2
      });
    }

    sendToTab(tabId, { type: 'REFRESH_STOPPED', state: state });
    updateActiveTabBadge();
  }
}

async function updateActiveTabBadge() {
  try {
    const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
    if (!activeTab || !activeTab.id) {
      chrome.action.setBadgeText({ text: '' });
      return;
    }

    const state = activeTabStates[activeTab.id];
    if (state && state.enabled) {
      const remainingSec = Math.max(0, Math.ceil((state.nextRefreshTime - Date.now()) / 1000));
      chrome.action.setBadgeText({ text: `${remainingSec}s`, tabId: activeTab.id });
      chrome.action.setBadgeBackgroundColor({ color: '#0EA5E9', tabId: activeTab.id });
    } else {
      chrome.action.setBadgeText({ text: '', tabId: activeTab.id });
    }
  } catch (e) {
    // Ignore
  }
}

chrome.tabs.onUpdated.addListener(async (tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete' && tab.url) {
    const { autoStartRules } = await chrome.storage.local.get(['autoStartRules']);
    if (autoStartRules && Array.isArray(autoStartRules)) {
      for (const rule of autoStartRules) {
        if (!rule.enabled || !rule.pattern) continue;
        let match = false;
        try {
          const regex = new RegExp(rule.pattern.replace(/\*/g, '.*'), 'i');
          match = regex.test(tab.url);
        } catch (e) {
          match = tab.url.includes(rule.pattern);
        }

        if (match && (!activeTabStates[tabId] || !activeTabStates[tabId].enabled)) {
          const newState = Object.assign({}, DEFAULT_TAB_STATE, rule.settings || {}, {
            enabled: true,
            nextRefreshTime: Date.now() + ((rule.settings && rule.settings.interval) || 10) * 1000,
            refreshCount: 0
          });

          activeTabStates[tabId] = newState;
          saveTabStates();
          scheduleNextRefresh(tabId);
          sendToTab(tabId, { type: 'STATE_SYNC', state: newState });
          updateActiveTabBadge();
          break;
        }
      }
    }
  }
});

chrome.tabs.onRemoved.addListener((tabId) => {
  if (activeTabStates[tabId]) {
    delete activeTabStates[tabId];
    saveTabStates();
  }
  if (chrome.alarms) chrome.alarms.clear(`refresh_tab_${tabId}`);
});

function saveTabStates() {
  chrome.storage.local.set({ tabStates: activeTabStates });
}

async function sendToTab(tabId, message) {
  try {
    await chrome.tabs.sendMessage(tabId, message);
    return true;
  } catch (error) {
    if (error.message && (error.message.includes('Tab not found') || error.message.includes('Could not establish connection') || error.message.includes('Invalid call'))) {
      if (activeTabStates[tabId]) {
        delete activeTabStates[tabId];
        saveTabStates();
        if (chrome.alarms) chrome.alarms.clear(`refresh_tab_${tabId}`);
      }
    } else {
      addLog('PAGE', `Could not deliver ${message.type} to tab ${tabId}: ${error.message}`, 'warn');
    }
    return false;
  }
}

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  const senderTabId = sender.tab ? sender.tab.id : null;
  let resolvedTabId = (request.tabId !== undefined && request.tabId !== null) ? request.tabId : senderTabId;

  if (request.type === 'START_REFRESH') {
    const startExecution = async (tid) => {
      if (!tid) {
        addLog('REFRESH', '🔴 Start Refresh Failed: No target tab ID', 'error');
        sendResponse({ success: false });
        return;
      }
      activeTabStates[tid] = Object.assign({}, DEFAULT_TAB_STATE, request.state, {
        enabled: true,
        nextRefreshTime: Date.now() + (request.state.interval || 10) * 1000,
        refreshCount: request.state.refreshCount || 0
      });

      saveTabStates();
      updateActiveTabBadge();
      targetTabId = tid;

      addLog('REFRESH', `Started refresh for tab ${tid} (${activeTabStates[tid].interval || activeTabStates[tid].minInterval}s)`);

      scheduleNextRefresh(tid);
      const pageReady = await sendToTab(tid, { type: 'REFRESH_STARTED', state: activeTabStates[tid] });
      sendResponse({ success: true, pageReady, state: activeTabStates[tid] });
    };

    const beginStart = () => {
      if (resolvedTabId) {
        startExecution(resolvedTabId);
      } else {
        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const foundId = (tabs && tabs[0]) ? tabs[0].id : null;
        startExecution(foundId);
        });
      }
    };

    if (tabStatesLoaded) {
      beginStart();
    } else {
      tabStatesReady.then(beginStart).catch(() => {
        sendResponse({ success: false });
      });
    }
    return true;
  }

  if (request.type === 'STOP_REFRESH') {
    const tabId = request.tabId || senderTabId || targetTabId;
    if (tabId && activeTabStates[tabId]) {
      activeTabStates[tabId].enabled = false;
      activeTabStates[tabId].isRefreshing = false;
      saveTabStates();
    }
    if (chrome.alarms && tabId) chrome.alarms.clear(`refresh_tab_${tabId}`);
    updateActiveTabBadge();
    if (tabId) {
      sendToTab(tabId, { type: 'REFRESH_STOPPED' });
      addLog('REFRESH', `Stopped refresh for tab ${tabId}`);
    }
    sendResponse({ success: true });
    return true;
  }

  if (request.type === 'GET_TAB_STATE') {
    const getStateExecution = (tid) => {
      const state = (tid && activeTabStates[tid]) ? activeTabStates[tid] : Object.assign({}, DEFAULT_TAB_STATE);
      sendResponse({ state: state });
    };

    const reqTabId = request.tabId || senderTabId || targetTabId;
    if (!tabStatesLoaded) {
      tabStatesReady.then(() => getStateExecution(reqTabId));
      return true;
    }
    if (reqTabId) {
      getStateExecution(reqTabId);
    } else {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const foundId = (tabs && tabs[0]) ? tabs[0].id : null;
        getStateExecution(foundId);
      });
    }
    return true;
  }

  if (request.type === 'GET_LOGS') {
    sendResponse({ logs: extensionLogs });
    return true;
  }

  if (request.type === 'CLEAR_LOGS') {
    extensionLogs.length = 0;
    addLog('SYSTEM', 'Logs cleared by user');
    sendResponse({ success: true });
    return true;
  }

  if (request.type === 'TEST_NATIVE_ALERT') {
    addLog('TEST', 'User clicked Test Push Alert button in popup');
    triggerNativeAlert('Test Alert', { playSound: true, showNotification: true })
      .then(sendResponse);
    return true;
  }

  if (request.type === 'TARGET_DETECTED') {
    const tabId = request.tabId || senderTabId || targetTabId;
    const state = tabId ? activeTabStates[tabId] : null;
    const targetTxt = (state && state.targetText) ? state.targetText : (request.targetText || 'Keyword');

    addLog('TARGET', '🎯 TARGET DETECTED! Keyword: "' + targetTxt + '"', 'success');

    const nativeAlertPromise = triggerNativeAlert(targetTxt, {
      playSound: !state || state.actionSound !== false,
      showNotification: !state || state.actionNotify !== false
    });

    if (state) {
      if (state.actionStop) {
        state.enabled = false;
        saveTabStates();
        updateActiveTabBadge();
        if (chrome.alarms && tabId) {
          chrome.alarms.clear(`refresh_tab_${tabId}`);
        }
        sendToTab(tabId, { type: 'REFRESH_STOPPED' });
        addLog('TARGET', `Auto-refresh stopped for tab ${tabId} because target was detected`);
      }

      if (state.actionFocus && tabId) {
        chrome.tabs.get(tabId, (tab) => {
          if (tab) {
            chrome.tabs.update(tabId, { active: true });
          }
        });
      }
    }

    nativeAlertPromise.then(sendResponse);
    return true;
  }

  if (request.type === 'SHOW_NOTIFICATION') {
    if (chrome.notifications && chrome.notifications.create) {
      chrome.notifications.create(`notify_${Date.now()}`, {
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: request.title || 'Auto Refresh XL - Target Detected!',
        message: request.message || 'Target detected on webpage!',
        priority: 2
      });
    }
    sendResponse({ success: true });
    return true;
  }
});
