document.addEventListener('DOMContentLoaded', async () => {
  const t = (window.ARXL_I18N && window.ARXL_I18N.t) || (value => value);
  const rulesList = document.getElementById('rulesList');
  const editPanel = document.getElementById('editPanel');
  const editUrl = document.getElementById('editUrl');
  const editInterval = document.getElementById('editInterval');
  let editingIndex = -1;

  const escapeHTML = value => String(value || '').replace(/[&<>"']/g, character => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[character]));

  async function readRules() {
    const { autoStartRules = [] } = await chrome.storage.local.get(['autoStartRules']);
    return autoStartRules;
  }

  function closeEditor() {
    editingIndex = -1;
    editPanel.classList.add('hidden');
  }

  async function render() {
    const rules = await readRules();
    if (!rules.length) {
      rulesList.innerHTML = `<div style="color:#64748b;font-style:italic;">${t('No Auto-Start rules created yet.')}</div>`;
      return;
    }
    rulesList.innerHTML = rules.map((rule, index) => `
      <div class="rule-item">
        <div>
          <div class="rule-url">${escapeHTML(rule.exactUrl || rule.pattern)}</div>
          <div class="rule-meta">${rule.urlMatch === 'exact' || rule.exactUrl ? t('Exact page') : t('URL pattern')} · ${Number(rule.settings && rule.settings.interval) || 10}s</div>
        </div>
        <div class="rule-actions">
          <button class="rule-button btn-edit" data-edit="${index}">${t('Edit')}</button>
          <button class="rule-button btn-delete" data-delete="${index}">${t('Delete')}</button>
        </div>
      </div>`).join('');

    rulesList.querySelectorAll('[data-edit]').forEach(button => button.addEventListener('click', () => {
      editingIndex = Number(button.dataset.edit);
      const rule = rules[editingIndex];
      editUrl.value = rule.exactUrl || rule.pattern || '';
      editInterval.value = Number(rule.settings && rule.settings.interval) || 10;
      editPanel.classList.remove('hidden');
      editUrl.focus();
    }));
    rulesList.querySelectorAll('[data-delete]').forEach(button => button.addEventListener('click', async () => {
      if (!confirm(t('Delete this Auto-Start rule?'))) return;
      rules.splice(Number(button.dataset.delete), 1);
      await chrome.storage.local.set({ autoStartRules: rules });
      closeEditor();
      await render();
    }));
  }

  document.getElementById('cancelEdit').addEventListener('click', closeEditor);
  document.getElementById('saveEdit').addEventListener('click', async () => {
    const url = editUrl.value.trim();
    if (!/^https?:\/\//i.test(url)) {
      alert(t('Enter a complete URL beginning with http:// or https://.'));
      return;
    }
    const rules = await readRules();
    const rule = rules[editingIndex];
    if (!rule) return;
    rule.pattern = url;
    rule.exactUrl = url;
    rule.urlMatch = 'exact';
    rule.settings = Object.assign({}, rule.settings || {}, {
      interval: Math.max(1, Number.parseInt(editInterval.value, 10) || 10)
    });
    await chrome.storage.local.set({ autoStartRules: rules });
    closeEditor();
    await render();
  });

  await render();
});
