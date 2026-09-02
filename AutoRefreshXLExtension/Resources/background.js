const activeTabStates = {};
const extensionLogs = [];
let targetTabId = null;
let tabStatesLoaded = false;
const statesStartedDuringRestore = new Set();
const refreshesInProgress = new Set();

function addLog(category, message, type = 'info') {
  const timestamp = new Date().toLocaleTimeString();
  extensionLogs.push({ timestamp, category, message, type });
  if (extensionLogs.length > 80) extensionLogs.shift();
  console.log(`[AutoRefreshXL] [${category}] ${message}`);
}

addLog('SYSTEM', 'Background service worker initialized');

async function scheduleNextRefresh(tabId, persist = true) {
  const state = activeTabStates[tabId];
  if (!state || !state.enabled) return;

  let intervalSec = state.interval || 10;
  if (state.mode === 'random') {
    const min = Math.min(state.minInterval, state.maxInterval);
    const max = Math.max(state.minInterval, state.maxInterval);
    intervalSec = Math.round((Math.random() * (max - min) + min) * 10) / 10;
  }

  state.nextRefreshTime = Date.now() + intervalSec * 1000;
  if (persist) await saveTabStates();

  if (chrome.alarms) {
    // Alarms are a recovery mechanism when iOS suspends the service worker.
    // The one-second ticker below remains the precise timer while Safari is active.
    try {
      await chrome.alarms.create(`refresh_tab_${tabId}`, { when: state.nextRefreshTime });
    } catch (error) {
      addLog('TIMER', `Could not create recovery alarm for tab ${tabId}: ${error.message}`, 'warn');
    }
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
  soundEnabled: true,
  actionHighlight: true,
  actionScroll: true,
  actionFocus: true,
  monitoringSessionComplete: false,
  overlayPosition: null
};

function normalizeTabState(state) {
  const normalized = Object.assign({}, DEFAULT_TAB_STATE, state || {});
  // This flag belonged to an earlier worker instance and must never prevent a
  // newly-created Safari worker from resuming the timer after navigation.
  delete normalized.isRefreshing;

  // Preserve compatibility with sessions completed by an earlier build. A
  // pending detection on a stopped, stop-on-match session means the target was
  // already reported; retain its settings and pending page actions, but do not
  // re-arm monitoring when the updated content script is injected.
  if (state && !Object.prototype.hasOwnProperty.call(state, 'monitoringSessionComplete') &&
      state.enabled === false && state.actionStop !== false && state.pendingDetection) {
    normalized.monitoringSessionComplete = true;
  }
  return normalized;
}

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
    for (const [tabId, state] of Object.entries(result.tabStates)) {
      if (!statesStartedDuringRestore.has(String(tabId))) {
        activeTabStates[tabId] = normalizeTabState(state);
      }
    }
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
  if (!state || !state.enabled || refreshesInProgress.has(tabId)) return;
  refreshesInProgress.add(tabId);

  state.refreshCount += 1;

  const reachedLimit = state.maxRefreshes > 0 && state.refreshCount >= state.maxRefreshes;
  if (reachedLimit) {
    state.enabled = false;
    state.nextRefreshTime = 0;
    await saveTabStates();
    if (chrome.alarms) await chrome.alarms.clear(`refresh_tab_${tabId}`);
  } else {
    // Commit the next deadline before navigation. Mobile Safari can suspend
    // this worker as soon as reload begins; the restored worker/alarm can then
    // continue the cycle even if execution never returns from tabs.reload().
    await scheduleNextRefresh(tabId);
  }

  // Reload first, then let the content script inspect the document Safari
  // actually rendered. A separately fetched copy can differ because of login
  // state, bot protection, client rendering or caching, and an alert raised
  // before this navigation would be destroyed by the reload itself.
  try {
    await chrome.tabs.reload(tabId, { bypassCache: !!state.hardRefresh });
    addLog('REFRESH', `Reloaded tab ${tabId} (Count: ${state.refreshCount})`, 'success');
  } catch (err) {
    addLog('REFRESH', `Failed to reload tab ${tabId}: ${err.message}`, 'error');
  } finally {
    refreshesInProgress.delete(tabId);
  }

  if (reachedLimit) {
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
    const refreshedState = activeTabStates[tabId];
    const hadPendingDetection = !!(refreshedState && refreshedState.pendingDetection);
    if (refreshedState && refreshedState.pendingDetection) {
      const activeTabs = await chrome.tabs.query({ active: true, currentWindow: true });
      const isActive = !!(activeTabs[0] && activeTabs[0].id === tabId);
      await applyPendingDetection(tabId, isActive);
    }

    if (!hadPendingDetection) {
      const { autoStartRules = [] } = await chrome.storage.local.get(['autoStartRules']);
      for (const rule of autoStartRules) {
        if (!rule || rule.enabled === false || !rule.pattern) continue;
        let matches = false;
        if (rule.urlMatch === 'exact' || rule.exactUrl) {
          matches = tab.url === (rule.exactUrl || rule.pattern);
        } else {
          try {
            const regex = new RegExp(rule.pattern.replace(/\*/g, '.*'), 'i');
            matches = regex.test(tab.url);
          } catch (error) {
            matches = tab.url.includes(rule.pattern);
          }
        }

        if (matches && (!activeTabStates[tabId] || !activeTabStates[tabId].enabled)) {
          const newState = Object.assign({}, DEFAULT_TAB_STATE, rule.settings || {}, {
            enabled: true,
            refreshCount: 0,
            monitoringSessionComplete: false
          });
          activeTabStates[tabId] = newState;
          saveTabStates();
          await scheduleNextRefresh(tabId);
          sendToTab(tabId, { type: 'STATE_SYNC', state: newState });
          updateActiveTabBadge();
          break;
        }
      }
    }

  }
});

chrome.tabs.onActivated.addListener(async ({ tabId }) => {
  if (activeTabStates[tabId] && activeTabStates[tabId].pendingDetection) {
    await applyPendingDetection(tabId, true);
  }
});

async function applyPendingDetection(tabId, performScroll) {
  const state = activeTabStates[tabId];
  const pending = state && state.pendingDetection;
  if (!pending) return false;
  const result = await requestFromTab(tabId, {
    type: 'APPLY_DETECTED_PAGE_ACTIONS',
    targetText: pending.targetText,
    matchType: pending.matchType,
    performScroll,
    state
  });
  if (result && result.success && (performScroll || state.actionScroll === false)) {
    delete state.pendingDetection;
    saveTabStates();
  }
  return !!(result && result.success);
}

chrome.tabs.onRemoved.addListener((tabId) => {
  if (activeTabStates[tabId]) {
    delete activeTabStates[tabId];
    saveTabStates();
  }
  if (chrome.alarms) chrome.alarms.clear(`refresh_tab_${tabId}`);
});

if (chrome.tabs.onReplaced) {
  chrome.tabs.onReplaced.addListener(async (addedTabId, removedTabId) => {
    const state = activeTabStates[removedTabId];
    if (!state) return;
    activeTabStates[addedTabId] = state;
    delete activeTabStates[removedTabId];
    targetTabId = targetTabId === removedTabId ? addedTabId : targetTabId;
    if (chrome.alarms) {
      await chrome.alarms.clear(`refresh_tab_${removedTabId}`);
      if (state.enabled) {
        await chrome.alarms.create(`refresh_tab_${addedTabId}`, {
          when: Math.max(Date.now() + 100, state.nextRefreshTime || Date.now() + 1000)
        });
      }
    }
    await saveTabStates();
  });
}

function saveTabStates() {
  const persistedStates = {};
  for (const [tabId, state] of Object.entries(activeTabStates)) {
    persistedStates[tabId] = normalizeTabState(state);
  }
  return chrome.storage.local.set({ tabStates: persistedStates });
}

async function sendToTab(tabId, message) {
  try {
    await chrome.tabs.sendMessage(tabId, message);
    return true;
  } catch (error) {
    if (error.message && error.message.includes('Tab not found')) {
      if (activeTabStates[tabId]) {
        delete activeTabStates[tabId];
        saveTabStates();
        if (chrome.alarms) chrome.alarms.clear(`refresh_tab_${tabId}`);
      }
    } else {
      // Safari can briefly report no content-script connection while a newly
      // opened tab is still being prepared. Keep the refresh state; subsequent
      // countdown ticks will attach the page controls when injection completes.
      addLog('PAGE', `Could not deliver ${message.type} to tab ${tabId}: ${error.message}`, 'warn');
    }
    return false;
  }
}

async function requestFromTab(tabId, message) {
  try {
    return await chrome.tabs.sendMessage(tabId, message);
  } catch (error) {
    addLog('PAGE', `Could not complete ${message.type} in tab ${tabId}: ${error.message}`, 'error');
    return { success: false, error: error.message };
  }
}

async function playNativeAlertSound() {
  if (!chrome.runtime.sendNativeMessage) {
    return { success: false, error: 'Native messaging is unavailable' };
  }
  try {
    return await new Promise((resolve) => {
      chrome.runtime.sendNativeMessage('application.id', { type: 'PLAY_ALERT_SOUND' }, (response) => {
        if (chrome.runtime.lastError) {
          resolve({ success: false, error: chrome.runtime.lastError.message });
        } else {
          resolve(response || { success: false, error: 'No response from the native sound handler' });
        }
      });
    });
  } catch (error) {
    return { success: false, error: error.message };
  }
}

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  const senderTabId = sender.tab ? sender.tab.id : null;
  let resolvedTabId = (request.tabId !== undefined && request.tabId !== null) ? request.tabId : senderTabId;

  if (request.type === 'START_REFRESH') {
    const startExecution = async (tid, tab) => {
      if (!tid) {
        addLog('REFRESH', '🔴 Start Refresh Failed: No target tab ID', 'error');
        sendResponse({ success: false });
        return;
      }
      statesStartedDuringRestore.add(String(tid));
      activeTabStates[tid] = Object.assign({}, DEFAULT_TAB_STATE, request.state, {
        enabled: true,
        nextRefreshTime: Date.now() + (request.state.interval || 10) * 1000,
        refreshCount: request.state.refreshCount || 0,
        monitoringSessionComplete: false,
        startedAt: Date.now(),
        sourceUrl: (tab && tab.url) || request.state.sourceUrl || ''
      });

      // Do not hold a cold-start click behind Safari's storage restoration.
      // Persist after restoration so this new state is merged with, rather than
      // accidentally replacing, any other sessions Safari is still loading.
      const persistStartedState = () => saveTabStates().catch(error => {
        addLog('SYSTEM', `Could not persist the new refresh state: ${error.message}`, 'error');
      });
      if (tabStatesLoaded) {
        persistStartedState();
      } else {
        tabStatesReady.then(persistStartedState).catch(error => {
          addLog('SYSTEM', `Could not finish startup state restoration: ${error.message}`, 'error');
          persistStartedState();
        });
      }
      updateActiveTabBadge();
      targetTabId = tid;

      addLog('REFRESH', `Started refresh for tab ${tid} (${activeTabStates[tid].interval || activeTabStates[tid].minInterval}s)`);

      // The refresh state is complete at this point. Safari may still be
      // attaching the content script or starting its alarms subsystem during
      // the first few seconds after launch, so neither operation may delay the
      // popup acknowledgement.
      scheduleNextRefresh(tid, false).catch(error => {
        addLog('TIMER', `Could not finish initial timer setup: ${error.message}`, 'warn');
      });
      sendToTab(tid, { type: 'REFRESH_STARTED', state: activeTabStates[tid] });
      sendResponse({ success: true, state: activeTabStates[tid] });
    };

    const beginStart = () => {
      // The popup's captured ID is the fastest reliable target. If Safari
      // replaces that startup tab moments later, onReplaced migrates the state.
      if (resolvedTabId) {
        startExecution(resolvedTabId, null);
        return;
      }
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (chrome.runtime.lastError) {
          addLog('REFRESH', `Could not resolve the active startup tab: ${chrome.runtime.lastError.message}`, 'error');
          sendResponse({ success: false, error: chrome.runtime.lastError.message });
          return;
        }
        const activeTab = tabs && tabs[0];
        startExecution(activeTab && activeTab.id, activeTab || null);
      });
    };

    beginStart();
    return true;
  }

  if (request.type === 'STOP_REFRESH') {
    const tabId = request.tabId || senderTabId || targetTabId;
    if (tabId && activeTabStates[tabId]) {
      activeTabStates[tabId].enabled = false;
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

  if (request.type === 'SET_SOUND_ENABLED') {
    const tabId = request.tabId || senderTabId || targetTabId;
    (async () => {
      if (tabId && activeTabStates[tabId]) {
        activeTabStates[tabId].soundEnabled = request.enabled !== false;
        await saveTabStates();
        sendToTab(tabId, { type: 'SOUND_PREFERENCE_SYNC', enabled: activeTabStates[tabId].soundEnabled });
      }
      sendResponse({ success: true });
    })();
    return true;
  }

  if (request.type === 'SET_OVERLAY_POSITION') {
    const tabId = request.tabId || senderTabId || targetTabId;
    const left = Number(request.position && request.position.left);
    const top = Number(request.position && request.position.top);
    if (tabId && activeTabStates[tabId] && Number.isFinite(left) && Number.isFinite(top)) {
      activeTabStates[tabId].overlayPosition = {
        left: Math.max(0, left),
        top: Math.max(0, top)
      };
      saveTabStates();
      sendResponse({ success: true });
    } else {
      sendResponse({ success: false, error: 'Invalid overlay position' });
    }
    return true;
  }

  if (request.type === 'FOCUS_MONITORED_TAB') {
    const tabId = Number(request.tabId);
    if (!tabId) {
      sendResponse({ success: false, error: 'No monitored tab was supplied' });
      return true;
    }
    chrome.tabs.update(tabId, { active: true })
      .then(() => sendResponse({ success: true }))
      .catch(error => sendResponse({ success: false, error: error.message }));
    return true;
  }

  if (request.type === 'TARGET_DETECTED') {
    const tabId = request.tabId || senderTabId || targetTabId;
    const state = tabId ? activeTabStates[tabId] : null;
    const targetTxt = (state && state.targetText) ? state.targetText : (request.targetText || 'Keyword');

    // A stopped detection remains configurable for the next Start press, but
    // it is no longer an active monitoring session. Ignore late messages from
    // the old document and from pages restored after navigation.
    if (state && state.monitoringSessionComplete === true) {
      sendResponse({ success: true, ignored: true });
      return true;
    }

    addLog('TARGET', '🎯 TARGET DETECTED! Keyword: "' + targetTxt + '"', 'success');

    const presentOnActiveTab = async (playWebSound) => {
      try {
        const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
        const activeTab = tabs && tabs[0];
        if (!activeTab || !activeTab.id) {
          return { success: false, error: 'No active Safari tab was found' };
        }
        const result = await requestFromTab(activeTab.id, {
          type: 'PRESENT_TARGET_ALERT',
          targetText: targetTxt,
          sourceTabId: tabId,
          showOpenTabButton: !!tabId && activeTab.id !== tabId,
          playSound: playWebSound
        });
        if (result && result.success) return result;

        // Safari internal pages do not accept content scripts. Fall back to the
        // monitored tab so the alert is not lost completely.
        if (tabId && tabId !== activeTab.id) {
          return await requestFromTab(tabId, {
            type: 'PRESENT_TARGET_ALERT',
            targetText: targetTxt,
            sourceTabId: tabId,
            showOpenTabButton: false,
            playSound: playWebSound
          });
        }
        return { success: false, error: (result && result.error) || 'The active tab could not present the alert' };
      } catch (error) {
        return { success: false, error: error.message };
      }
    };

    if (state) {
      state.pendingDetection = {
        targetText: targetTxt,
        matchType: state.matchType || 'text'
      };
      if (state.actionStop) {
        state.enabled = false;
        state.monitoringSessionComplete = true;
        state.nextRefreshTime = 0;
        updateActiveTabBadge();
        if (chrome.alarms && tabId) {
          chrome.alarms.clear(`refresh_tab_${tabId}`);
        }
      }
    }

    // Persist the completed-session marker before presenting the alert. By the
    // time the user can manually reload, a new content script must see the
    // stopped state rather than mistaking it for a pending final-cycle check.
    const persistedDetectionState = state
      ? saveTabStates().catch((error) => {
          addLog('SYSTEM', `Could not persist detected target state: ${error.message}`, 'error');
        })
      : Promise.resolve();

    (async () => {
      await persistedDetectionState;
      const shouldPlaySound = (!state || state.actionSound !== false) && (!state || state.soundEnabled !== false);
      const nativeSound = shouldPlaySound
        ? await playNativeAlertSound()
        : { success: false, skipped: true };
      if (shouldPlaySound && !nativeSound.success) {
        addLog('SOUND', `Native alert unavailable; using webpage fallback: ${nativeSound.error || 'unknown error'}`, 'warn');
      }

      // Present before removing the overlay/stopped state. Safari can otherwise
      // race the stop message against this second message, especially when a
      // disappearing target has no matching DOM node to keep the task active.
      const presentation = await presentOnActiveTab(shouldPlaySound && !nativeSound.success);

      if (state && state.actionStop) {
        await sendToTab(tabId, { type: 'REFRESH_STOPPED', preserveTargetAlert: true });
        addLog('TARGET', `Auto-refresh stopped for tab ${tabId} because target was detected`);
      }

      sendResponse({
        success: !!(presentation && presentation.success),
        soundPlayed: !!nativeSound.success || !!(presentation && presentation.soundPlayed),
        error: presentation && presentation.error
      });
    })();
    return true;
  }

});
