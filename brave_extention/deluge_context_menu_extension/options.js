document.addEventListener('DOMContentLoaded', () => {
  const urlInput = document.getElementById('deluge_url');
  const passInput = document.getElementById('deluge_password');
  const saveBtn = document.getElementById('save');
  const testBtn = document.getElementById('test');
  const status = document.getElementById('status');

  // Load saved values
  chrome.storage.sync.get({ deluge_url: 'http://localhost:8112', deluge_password: '' }, (items) => {
    urlInput.value = items.deluge_url || '';
    passInput.value = items.deluge_password || '';
  });

  saveBtn.addEventListener('click', () => {
    chrome.storage.sync.set({ deluge_url: urlInput.value.trim(), deluge_password: passInput.value }, () => {
      status.textContent = 'Saved.';
      setTimeout(() => status.textContent = '', 2000);
    });
  });

  testBtn.addEventListener('click', async () => {
    status.textContent = 'Testing...';
    const delugeUrl = urlInput.value.trim();
    const password = passInput.value;
    if (!delugeUrl) {
      status.textContent = 'Please enter a Deluge URL.';
      return;
    }
    const rpcUrl = delugeUrl.endsWith('/json') ? delugeUrl : delugeUrl.replace(/\/+$/, '') + '/json';
    try {
      const resp = await fetch(rpcUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ method: 'auth.login', params: [password], id: 1, jsonrpc: '2.0' })
      });
      if (!resp.ok) {
        status.textContent = 'Request failed: ' + resp.status;
        return;
      }
      const data = await resp.json();
      if (data && data.result) {
        status.textContent = 'Auth successful.';
      } else {
        status.textContent = 'Auth failed (check password).';
      }
    } catch (err) {
      status.textContent = 'Error: ' + err.message;
    }
  });
});
