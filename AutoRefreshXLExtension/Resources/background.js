const activeTabStates = {};
const extensionLogs = [];

function addLog(category, message, type = 'info') {
  const timestamp = new Date().toLocaleTimeString();
  extensionLogs.push({ timestamp, category, message, type });
  if (extensionLogs.length > 80) extensionLogs.shift();
  console.log(`[AutoRefreshXL] [${category}] ${message}`);
}

addLog('SYSTEM', 'Background service worker initialized');

function triggerNativeAlert(targetText) {
  const payload = { type: 'TARGET_DETECTED', targetText: targetText || '' };
  addLog('NATIVE', 'Sending native message: ' + JSON.stringify(payload));
  try {
    if (typeof browser !== 'undefined' && browser.runtime && browser.runtime.sendNativeMessage) {
      browser.runtime.sendNativeMessage("application.id", payload);
      addLog('NATIVE', 'browser.runtime.sendNativeMessage sent', 'success');
    } else if (chrome.runtime && chrome.runtime.sendNativeMessage) {
      chrome.runtime.sendNativeMessage("application.id", payload);
      addLog('NATIVE', 'chrome.runtime.sendNativeMessage sent', 'success');
    } else {
      addLog('NATIVE', 'sendNativeMessage API unavailable', 'warn');
    }
  } catch (e) {
    addLog('NATIVE', '🔴 Native message Exception: ' + e.message, 'error');
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

// Restore active timers from storage on background startup
chrome.storage.local.get(['tabStates'], (result) => {
  if (result.tabStates) {
    Object.assign(activeTabStates, result.tabStates);
  }
});

// Ticker loop every 1 second
setInterval(async () => {
  const now = Date.now();
  const tabIds = Object.keys(activeTabStates);

  for (const tabIdStr of tabIds) {
    const tabId = parseInt(tabIdStr, 10);
    const state = activeTabStates[tabId];

    if (!state || !state.enabled) continue;

    try {
      const tab = await chrome.tabs.get(tabId);
      if (!tab) {
        delete activeTabStates[tabId];
        saveTabStates();
        continue;
      }
    } catch (e) {
      delete activeTabStates[tabId];
      saveTabStates();
      continue;
    }

    if (now >= state.nextRefreshTime) {
      await triggerTabReload(tabId, state);
    } else {
      const remainingSeconds = Math.max(0, Math.ceil((state.nextRefreshTime - now) / 1000));
      sendToTab(tabId, {
        type: 'COUNTDOWN_TICK',
        remainingSeconds: remainingSeconds,
        refreshCount: state.refreshCount,
        maxRefreshes: state.maxRefreshes,
        state: state
      });
    }
  }

  updateActiveTabBadge();
}, 1000);

async function triggerTabReload(tabId, state) {
  try {
    await chrome.tabs.reload(tabId, { bypassCache: !!state.hardRefresh });
  } catch (err) {
    console.error(`Failed to reload tab ${tabId}:`, err);
  }

  state.refreshCount += 1;

  if (state.maxRefreshes > 0 && state.refreshCount >= state.maxRefreshes) {
    state.enabled = false;
    saveTabStates();

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
    return;
  }

  let nextIntervalSec = state.interval;
  if (state.mode === 'random') {
    const min = Math.min(state.minInterval, state.maxInterval);
    const max = Math.max(state.minInterval, state.maxInterval);
    const randFloat = Math.random() * (max - min) + min;
    nextIntervalSec = Math.round(randFloat * 10) / 10;
  }

  state.nextRefreshTime = Date.now() + nextIntervalSec * 1000;
  saveTabStates();
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
});

function saveTabStates() {
  chrome.storage.local.set({ tabStates: activeTabStates });
}

function sendToTab(tabId, message) {
  chrome.tabs.sendMessage(tabId, message).catch(() => {});
}

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  const senderTabId = sender.tab ? sender.tab.id : null;
  const targetTabId = (request.tabId !== undefined && request.tabId !== null) ? request.tabId : senderTabId;

  if (request.type === 'START_REFRESH') {
    const tabId = request.tabId || targetTabId;

    const startExecution = (tid) => {
      if (!tid) {
        addLog('REFRESH', '🔴 Start Refresh Failed: No target tab ID', 'error');
        sendResponse({ success: false });
        return;
      }
      targetTabId = tid;
      const newState = Object.assign({}, DEFAULT_TAB_STATE, request.state, {
        enabled: true,
        nextRefreshTime: Date.now() + (request.state.interval || 10) * 1000,
        refreshCount: request.state.refreshCount || 0
      });

      activeTabStates[tid] = newState;
      saveTabStates();
      updateActiveTabBadge();

      addLog('REFRESH', `Started refresh for tab ${tid} (${newState.interval || newState.minInterval}s)`);

      sendToTab(tid, { type: 'REFRESH_STARTED', state: newState });
      scheduleNextRefresh(tid);
      sendResponse({ success: true, state: newState });
    };

    if (tabId) {
      startExecution(tabId);
    } else {
      chrome.tabs.query({ active: true }, (tabs) => {
        const foundId = (tabs && tabs[0]) ? tabs[0].id : null;
        startExecution(foundId);
      });
    }
    return true;
  }

  if (request.type === 'STOP_REFRESH') {
    const tabId = request.tabId || targetTabId;
    if (tabId && activeTabStates[tabId]) {
      activeTabStates[tabId].enabled = false;
      saveTabStates();
    }
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

    const reqTabId = request.tabId || targetTabId;
    if (reqTabId) {
      getStateExecution(reqTabId);
    } else {
      chrome.tabs.query({ active: true }, (tabs) => {
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
    triggerNativeAlert('Test Alert');
    if (chrome.notifications && chrome.notifications.create) {
      chrome.notifications.create(`test_${Date.now()}`, {
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: '🎯 Auto Refresh XL - Test Push Notification',
        message: 'Notification test successful! Alerts are working.',
        priority: 2
      });
      addLog('NOTIFY', 'chrome.notifications.create dispatched for test', 'success');
    }
    sendResponse({ success: true });
    return true;
  }

  if (request.type === 'TARGET_DETECTED') {
    const tabId = targetTabId;
    const state = tabId ? activeTabStates[tabId] : null;
    const targetTxt = (state && state.targetText) ? state.targetText : (request.targetText || 'Keyword');

    addLog('TARGET', '🎯 TARGET DETECTED! Keyword: "' + targetTxt + '"', 'success');

    triggerNativeAlert(targetTxt);

    if (chrome.notifications && chrome.notifications.create) {
      chrome.notifications.create(`target_${tabId || 'tab'}_${Date.now()}`, {
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: '🎯 Auto Refresh XL - Target Detected!',
        message: `Target expression "${targetTxt}" was detected on webpage!`,
        priority: 2
      });
      addLog('NOTIFY', 'chrome.notifications.create dispatched for target detection', 'success');
    }

    if (state) {
      if (state.actionStop) {
        state.enabled = false;
        saveTabStates();
        updateActiveTabBadge();
        sendToTab(tabId, { type: 'REFRESH_STOPPED' });
      }

      if (state.actionFocus && tabId) {
        chrome.tabs.get(tabId, (tab) => {
          if (tab) {
            chrome.tabs.update(tabId, { active: true });
          }
        });
      }
    }

    sendResponse({ success: true });
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
