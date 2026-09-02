import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const i18nSource = fs.readFileSync(
  new URL('../AutoRefreshXLExtension/Resources/i18n.js', import.meta.url),
  'utf8'
);

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

testCompactDurationsRemainInvariant();
testEveryLocaleHasTheSameSupplementalKeys();
console.log('All localisation regression tests passed.');
