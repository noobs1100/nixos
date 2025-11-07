
// popup.js - settings UI
document.addEventListener("DOMContentLoaded", () => {
  const serverUrl = document.getElementById("serverUrl");
  const password = document.getElementById("password");
  const downloadPath = document.getElementById("downloadPath");
  const saveBtn = document.getElementById("save");
  const testBtn = document.getElementById("test");
  const status = document.getElementById("status");

  function setStatus(msg, isError) {
    status.textContent = msg;
    status.style.color = isError ? "red" : "green";
  }

  chrome.storage.sync.get({ serverUrl: "", password: "", downloadPath: "" }, (items) => {
    serverUrl.value = items.serverUrl || "";
    password.value = items.password || "";
    downloadPath.value = items.downloadPath || "";
  });

  saveBtn.addEventListener("click", () => {
    chrome.storage.sync.set({
      serverUrl: serverUrl.value.trim(),
      password: password.value,
      downloadPath: downloadPath.value.trim()
    }, () => setStatus("Settings saved.", false));
  });

  testBtn.addEventListener("click", async () => {
    setStatus("Testing...", false);
    const url = serverUrl.value.trim();
    const pwd = password.value;
    if (!url || !pwd) {
      setStatus("Fill server URL and password first.", true);
      return;
    }
    try {
      const resp = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ method: "auth.login", params: [pwd], id: 1 }),
        credentials: "include"
      });
      const data = await resp.json();
      if (data && data.result === true) {
        setStatus("Auth OK — server reachable.", false);
      } else {
        setStatus("Auth failed or unexpected response.", true);
      }
    } catch (err) {
      setStatus("Network error: " + err.message, true);
    }
  });
});
