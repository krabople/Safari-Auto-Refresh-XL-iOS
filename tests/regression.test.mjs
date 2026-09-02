import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const backgroundSource = fs.readFileSync(
  new URL('../AutoRefreshXLExtension/Resources/background.js', import.meta.url),
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

async function testCompletedMonitorIsDisarmed() {
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
      actionSound: false
    }
  });

  await harness.send(
    { type: 'TARGET_DETECTED', tabId: 1, targetText: 'Needle' },
    { tab: { id: 1 } }
  );

  const state = harness.storage.tabStates['1'];
  assert.equal(state.enabled, false);
  assert.equal(state.monitorEnabled, false);
  assert.equal(state.nextRefreshTime, 0);
  assert.equal('pendingDetection' in state, false);
  assert.equal(harness.storage.popupDrafts['1'].monitorEnabled, false);

  const countsAfterFirstAlert = harness.alertCounts();
  const duplicate = await harness.send(
    { type: 'TARGET_DETECTED', tabId: 1, targetText: 'Needle' },
    { tab: { id: 1 } }
  );
  assert.equal(duplicate.ignored, true);
  assert.deepEqual(harness.alertCounts(), countsAfterFirstAlert);
}

async function testLegacyStoppedMonitorIsMigrated() {
  const harness = createBackgroundHarness({
    tabStates: {
      2: {
        enabled: false,
        monitorEnabled: true,
        targetText: 'Old target',
        pendingDetection: { targetText: 'Old target', matchType: 'text' }
      }
    }
  });

  await new Promise(resolve => setTimeout(resolve, 0));
  const response = await harness.send({ type: 'GET_TAB_STATE', tabId: 2 });
  assert.equal(response.state.monitorEnabled, false);
  assert.equal('pendingDetection' in response.state, false);
}

function testCompactDurationsRemainInvariant() {
  const languages = ['de', 'fr', 'es', 'it', 'pt-BR', 'nl', 'ja', 'ko', 'zh-CN', 'zh-TW'];
  const expected = ['5s', '10s', '30s', '1m', '5m', '15m'];

  for (const language of languages) {
    const document = {
      readyState: 'loading',
      addEventListener() {}
    };
    const context = vm.createContext({
      document,
      navigator: { language },
      window: null
    });
    context.window = context;
    vm.runInContext(i18nSource, context);
    assert.deepEqual(
      expected.map(value => context.ARXL_I18N.t(value)),
      expected,
      `Compact durations changed in ${language}`
    );
  }
}

function testEveryLocaleHasTheSameSupplementalKeys() {
  const document = {
    readyState: 'loading',
    addEventListener() {}
  };
  const instrumentedSource = i18nSource.replace(
    '  const rawLanguage =',
    '  window.__translationAudit = { dictionaries, extraDictionaries };\n  const rawLanguage ='
  );
  const context = vm.createContext({
    document,
    navigator: { language: 'en' },
    window: null
  });
  context.window = context;
  vm.runInContext(instrumentedSource, context);

  const { dictionaries, extraDictionaries } = context.__translationAudit;
  const locales = Object.keys(dictionaries);
  const expectedBaseKeys = Object.keys(dictionaries[locales[0]]).sort();
  const expectedExtraKeys = Object.keys(extraDictionaries[locales[0]]).sort();
  for (const locale of locales) {
    assert.deepEqual(Object.keys(dictionaries[locale]).sort(), expectedBaseKeys, `Base translation keys differ for ${locale}`);
    assert.deepEqual(Object.keys(extraDictionaries[locale]).sort(), expectedExtraKeys, `Supplemental translation keys differ for ${locale}`);
  }
}

await testCompletedMonitorIsDisarmed();
await testLegacyStoppedMonitorIsMigrated();
testCompactDurationsRemainInvariant();
testEveryLocaleHasTheSameSupplementalKeys();
console.log('All regression tests passed.');
