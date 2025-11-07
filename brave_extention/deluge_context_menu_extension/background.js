// background.js - service worker for context menus and Deluge JSON-RPC calls

// Create context menu entries on install
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "add_movies",
    title: "Add to Deluge — Movies",
    contexts: ["link"],
    documentUrlPatterns: ["<all_urls>"]
  });
  chrome.contextMenus.create({
    id: "add_tv",
    title: "Add to Deluge — TV Shows",
    contexts: ["link"],
    documentUrlPatterns: ["<all_urls>"]
  });
});

// Helper: show notification
function notify(title, message) {
  chrome.notifications.create(undefined, {
    type: "basic",
    iconUrl: "icon.png",
    title: title,
    message: message
  });
}

// Perform Deluge JSON-RPC call: auth.login then core.add_torrent_magnet
async function addMagnetToDeluge(delugeUrl, password, magnet, downloadPath) {
  // Ensure URL ends with /json
  let rpcUrl = delugeUrl;
  if (!rpcUrl.endsWith("/json")) {
    rpcUrl = rpcUrl.replace(/\/+$/, "") + "/json";
  }

  // Attempt auth.login
  try {
    const loginBody = {
      method: "auth.login",
      params: [password],
      id: 1,
      jsonrpc: "2.0"
    };
    let resp = await fetch(rpcUrl, { method: "POST", body: JSON.stringify(loginBody), credentials: "omit", headers: { "Content-Type": "application/json" } });
    if (!resp.ok) {
      throw new Error("Auth request failed: " + resp.status + " " + resp.statusText);
    }
    const loginResult = await resp.json();
    if (!loginResult.result) {
      throw new Error("Deluge auth.login returned false. Check password.");
    }

    // Now add magnet
    const addBody = {
      method: "core.add_torrent_magnet",
      params: [magnet, { "download_location": downloadPath }],
      id: 2,
      jsonrpc: "2.0"
    };
    resp = await fetch(rpcUrl, { method: "POST", body: JSON.stringify(addBody), credentials: "omit", headers: { "Content-Type": "application/json" } });
    if (!resp.ok) {
      throw new Error("Add torrent request failed: " + resp.status + " " + resp.statusText);
    }
    const addResult = await resp.json();
    // The Deluge Web API often returns {"result": {} } or some value. We'll treat non-error response as success.
    return { success: true, raw: addResult };
  } catch (err) {
    return { success: false, error: err.message || String(err) };
  }
}

// Context menu click handler
chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  // Only handle links (magnet: links)
  const magnet = info.linkUrl || info.srcUrl || info.pageUrl || null;
  if (!magnet) {
    notify("Deluge: No link found", "Couldn't detect a link/magnet URL.");
    return;
  }
  // Determine target folder
  let downloadPath = "/downloads/movies";
  if (info.menuItemId === "add_tv") downloadPath = "/downloads/tv-shows";

  // Load settings from storage
  chrome.storage.sync.get({ deluge_url: "http://localhost:8112", deluge_password: "" }, async (items) => {
    const delugeUrl = items.deluge_url;
    const password = items.deluge_password;
    if (!delugeUrl) {
      notify("Deluge: Not configured", "Open the extension options and set the Deluge JSON-RPC URL.");
      return;
    }
    // Add to Deluge
    const result = await addMagnetToDeluge(delugeUrl, password, magnet, downloadPath);
    if (result.success) {
      notify("Torrent added", "Torrent successfully added to Deluge.\nPath: " + downloadPath);
    } else {
      notify("Failed to add torrent", result.error || "Unknown error");
    }
  });
});
