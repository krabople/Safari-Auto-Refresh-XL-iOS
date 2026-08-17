document.addEventListener('DOMContentLoaded', async () => {
  const rulesList = document.getElementById('rulesList');
  const { autoStartRules } = await chrome.storage.local.get(['autoStartRules']);
  const rules = autoStartRules || [];

  if (rules.length === 0) {
    rulesList.innerHTML = '<div style="color: #64748b; font-style: italic;">No auto-start rules created yet.</div>';
    return;
  }

  rulesList.innerHTML = rules.map((r, idx) => `
    <div class="rule-item">
      <div>
        <strong style="color: #00f2fe;">${r.pattern}</strong>
        <div style="font-size: 11px; color: #94a3b8;">Interval: ${r.settings?.interval || 10}s</div>
      </div>
      <button class="btn-secondary btn-delete" data-idx="${idx}" style="font-size: 11px; padding: 4px 8px;">Delete</button>
    </div>
  `).join('');

  document.querySelectorAll('.btn-delete').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      const idx = parseInt(e.target.dataset.idx, 10);
      rules.splice(idx, 1);
      await chrome.storage.local.set({ autoStartRules: rules });
      location.reload();
    });
  });
});
