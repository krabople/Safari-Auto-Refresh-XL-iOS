import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const backgroundSource = fs.readFileSync(
  new URL('../AutoRefreshXLExtension/Resources/background.js', import.meta.url),
  'utf8'
);
const contentSource = fs.readFileSync(
  new URL('../AutoRefreshXLExtension/Resources/content.js', import.meta.url),
  'utf8'
);
const i18nSource = fs.readFileSync(
  new URL('../AutoRefreshXLExtension/Resources/i18n.js', import.meta.url),
  'utf8'
);

function createBackgroundHarness(initialStorage = {}) {
  const storage = structuredClone(initialStorage);
  let onMessage;
  let nativeAlertCount = 0;
  let presentedAlertCount = 0;

  const event = (listenerSink) => ({
    addListener(listener) {
      if (listenerSink) listenerSink(listener);
    }
  });

  const chrome = {
    alarms: {
      create: async () => {},
      clear: async () => true,
      onAlarm: event()
    },
    action: {
      setBadgeText: async () => {},
      setBadgeBackgroundColor: async () => {}
    },
    runtime: {
      lastError: null,
      onInstalled: event(),
      onMessage: event(listener => { onMessage = listener; }),
      sendNativeMessage(_application, _message, callback) {
        nativeAlertCount += 1;
        callback({ success: true });
      }
    },
    storage: {
      local: {
        async get(keys) {
          const result = {};
          for (const key of keys) {
            if (Object.hasOwn(storage, key)) result[key] = structuredClone(storage[key]);
          }
          return result;
        },
        async set(values) {
          Object.assign(storage, structuredClone(values));
        }
      }
    },
    tabs: {
      onUpdated: event(),
      onActivated: event(),
      onRemoved: event(),
      onReplaced: event(),
      async query() {
        return [{ id: 1, url: 'https://example.com/' }];
      },
      async reload() {},
      async update() {},
      async sendMessage(_tabId, message) {
        if (message.type === 'PRESENT_TARGET_ALERT') {
          presentedAlertCount += 1;
          return { success: true, soundPlayed: true };
        }
        if (message.type === 'APPLY_DETECTED_PAGE_ACTIONS') {
          return { success: true, found: true };
        }
        return { success: true };
      }
    }
  };

  const context = vm.createContext({
    chrome,
    console: { log() {}, warn() {}, error() {} },
    Date,
    Object,
    Promise,
    Set,
    clearInterval() {},
    setInterval() { return 1; }
  });
  vm.runInContext(backgroundSource, context);

  return {
    storage,
    alertCounts() {
      return { native: nativeAlertCount, presented: presentedAlertCount };
    },
    async send(request, sender = {}) {
      return await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => reject(new Error(`No response for ${request.type}`)), 1000);
        onMessage(request, sender, response => {
          clearTimeout(timeout);
          resolve(response);
        });
      });
    }
  };
}

function inspectContentMonitoringStartup(state) {
  let timeoutCount = 0;
  let intervalCount = 0;
  let observerCount = 0;
  const event = () => ({ addListener() {} });
  const root = {};

  class MutationObserverStub {
    constructor() {
      observerCount += 1;
    }
    observe() {}
    disconnect() {}
  }

  const context = vm.createContext({
    window: null,
    document: { body: root, documentElement: root },
    chrome: {
      runtime: {
        lastError: null,
        onMessage: event(),
        sendMessage(request, callback) {
          if (request.type === 'GET_TAB_STATE' && callback) {
            callback({ state: structuredClone(state) });
          }
        }
      }
    },
    MutationObserver: MutationObserverStub,
    console: { log() {}, warn() {}, error() {} },
    clearInterval() {},
    clearTimeout() {},
    setInterval() {
      intervalCount += 1;
      return intervalCount;
    },
    setTimeout() {
      timeoutCount += 1;
      return timeoutCount;
    }
  });
  context.window = context;
  context.top = context;
  context.addEventListener = () => {};
  context.removeEventListener = () => {};

  vm.runInContext(contentSource, context);
  return { timeoutCount, intervalCount, observerCount };
}

async function testCompletedMonitoringSessionIsIdempotent() {
  const harness = createBackgroundHarness({
    popupDrafts: {
      1: { monitorEnabled: true, targetText: 'Needle' }
    }
  });

  await harness.send({
    type: 'START_REFRESH',
    tabId: 1,
    state: {
      interval: 30,
      monitorEnabled: true,
      targetText: 'Needle',
      actionStop: true,
      actionSound: true
    }
  });

  await harness.send(
    { type: 'TARGET_DETECTED', tabId: 1, targetText: 'Needle' },
    { tab: { id: 1 } }
  );

  const completedState = harness.storage.tabStates['1'];
  assert.equal(completedState.enabled, false);
  assert.equal(completedState.monitoringSessionComplete, true);
  assert.equal(completedState.nextRefreshTime, 0);
  assert.equal(completedState.monitorEnabled, true, 'Monitoring preference should remain available for the next run');
  assert.equal(harness.storage.popupDrafts['1'].monitorEnabled, true, 'Popup settings must not be reset');

  const countsAfterFirstAlert = harness.alertCounts();
  assert.deepEqual(countsAfterFirstAlert, { native: 1, presented: 1 }, 'The first detection must still produce sound and an on-screen alert');
  const duplicate = await harness.send(
    { type: 'TARGET_DETECTED', tabId: 1, targetText: 'Needle' },
    { tab: { id: 1 } }
  );
  assert.equal(duplicate.ignored, true);
  assert.deepEqual(harness.alertCounts(), countsAfterFirstAlert, 'A completed session must not alert twice');

  await harness.send({
    type: 'START_REFRESH',
    tabId: 1,
    state: {
      interval: 30,
      monitorEnabled: true,
      targetText: 'Needle',
      actionStop: true,
      actionSound: false,
      monitoringSessionComplete: true
    }
  });
  assert.equal(harness.storage.tabStates['1'].monitoringSessionComplete, false, 'Start must explicitly re-arm monitoring');
}

async function testCompletedStateSurvivesWorkerRestartAndLegacyUpgrade() {
  const restoredHarness = createBackgroundHarness({
    tabStates: {
      2: {
        enabled: false,
        monitorEnabled: true,
        targetText: 'Already found',
        refreshCount: 1,
        actionStop: true,
        pendingDetection: { targetText: 'Already found', matchType: 'text' }
      }
    }
  });

  const restored = await restoredHarness.send({ type: 'GET_TAB_STATE', tabId: 2 });
  assert.equal(restored.state.monitoringSessionComplete, true);
  assert.equal(restored.state.monitorEnabled, true, 'Legacy migration must preserve the user setting');
  assert.deepEqual(
    JSON.parse(JSON.stringify(restored.state.pendingDetection)),
    { targetText: 'Already found', matchType: 'text' },
    'Legacy migration must preserve pending highlight/scroll actions'
  );

  const duplicate = await restoredHarness.send(
    { type: 'TARGET_DETECTED', tabId: 2, targetText: 'Already found' },
    { tab: { id: 2 } }
  );
  assert.equal(duplicate.ignored, true);
  assert.deepEqual(restoredHarness.alertCounts(), { native: 0, presented: 0 });
}

function testContentScriptDoesNotRearmCompletedSession() {
  const completed = inspectContentMonitoringStartup({
    enabled: false,
    monitorEnabled: true,
    targetText: 'Needle',
    refreshCount: 1,
    monitoringSessionComplete: true
  });
  assert.deepEqual(completed, { timeoutCount: 0, intervalCount: 0, observerCount: 0 });

  const finalCycle = inspectContentMonitoringStartup({
    enabled: false,
    monitorEnabled: true,
    targetText: 'Needle',
    refreshCount: 1,
    monitoringSessionComplete: false
  });
  assert.deepEqual(
    finalCycle,
    { timeoutCount: 1, intervalCount: 1, observerCount: 1 },
    'A refresh-limit final page must still receive its promised monitoring check'
  );
}

function loadTranslations(language = 'en', audit = false) {
  const document = {
    readyState: 'loading',
    addEventListener() {}
  };
  const source = audit
    ? i18nSource.replace(
        '  const rawLanguage =',
        '  window.__translationAudit = { dictionaries, extraDictionaries };\n  const rawLanguage ='
      )
    : i18nSource;
  const context = vm.createContext({
    document,
    navigator: { language },
    window: null
  });
  context.window = context;
  vm.runInContext(source, context);
  return context;
}

function testCompactDurationsRemainInvariant() {
  const languages = ['de', 'fr', 'es', 'it', 'pt-BR', 'nl', 'ja', 'ko', 'zh-CN', 'zh-TW'];
  const expected = ['5s', '10s', '30s', '1m', '5m', '15m'];

  for (const language of languages) {
    const context = loadTranslations(language);
    assert.deepEqual(
      expected.map(value => context.ARXL_I18N.t(value)),
      expected,
      `Compact durations changed in ${language}`
    );
  }
}

function testEveryLocaleHasTheSameSupplementalKeys() {
  const context = loadTranslations('en', true);
  const { dictionaries, extraDictionaries } = context.__translationAudit;
  const locales = Object.keys(dictionaries);
  const expectedBaseKeys = Object.keys(dictionaries[locales[0]]).sort();
  const expectedExtraKeys = Object.keys(extraDictionaries[locales[0]]).sort();

  for (const locale of locales) {
    assert.deepEqual(Object.keys(dictionaries[locale]).sort(), expectedBaseKeys, `Base translation keys differ for ${locale}`);
    assert.deepEqual(Object.keys(extraDictionaries[locale]).sort(), expectedExtraKeys, `Supplemental translation keys differ for ${locale}`);
  }
}

await testCompletedMonitoringSessionIsIdempotent();
await testCompletedStateSurvivesWorkerRestartAndLegacyUpgrade();
testContentScriptDoesNotRearmCompletedSession();
testCompactDurationsRemainInvariant();
testEveryLocaleHasTheSameSupplementalKeys();
console.log('All monitoring and localisation regression tests passed.');
