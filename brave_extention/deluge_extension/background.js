// background.js - service worker for context menu and JSON-RPC calls to Deluge
const MENU_PARENT_ID = "add-to-deluge";
const MENU_MOVIES_ID = "add-to-deluge-movies";
const MENU_TVSHOWS_ID = "add-to-deluge-tvshows";

chrome.runtime.onInstalled.addListener(() => {
  // Create parent context menu
  chrome.contextMenus.create({
    id: MENU_PARENT_ID,
    title: "Add to Deluge",
    contexts: ["link", "page", "selection"]
  });

  // Submenu for Movies
  chrome.contextMenus.create({
    id: MENU_MOVIES_ID,
    parentId: MENU_PARENT_ID,
    title: "🎬 Movies",
    contexts: ["link", "page", "selection"]
  });

  // Submenu for TV Shows
  chrome.contextMenus.create({
    id: MENU_TVSHOWS_ID,
    parentId: MENU_PARENT_ID,
    title: "📺 TV Shows",
    contexts: ["link", "page", "selection"]
  });
});

async function getSettings() {
  return new Promise((res) => {
    chrome.storage.sync.get({
      serverUrl: "",
      password: "",
      downloadPath: ""
    }, (items) => res(items));
  });
}

function notify(title, message) {
  chrome.notifications.create({
    type: "basic",
    iconUrl: "icon48.png",
    title,
    message
  });
}

async function rpcCall(serverUrl, payload) {
  try {
    const resp = await fetch(serverUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
      credentials: "include"
    });
    const data = await resp.json();
    return { ok: true, data };
  } catch (err) {
    return { ok: false, error: err.message || String(err) };
  }
}

async function ensureAuthenticated(serverUrl, password) {
  const payload = { method: "auth.login", params: [password], id: 1 };
  const result = await rpcCall(serverUrl, payload);
  if (!result.ok) return { success: false, error: result.error || "Network error" };
  if (result.data && result.data.result === true) return { success: true };
  return { success: false, error: "Authentication failed" };
}

async function addMagnetToDeluge(serverUrl, magnet, downloadPath, moveCompletedPath) {
  // Deluge core.add_torrent_magnet signature: (magnet, options)
  const options = {
    download_location: downloadPath
  };
  if (moveCompletedPath) {
    options["move_completed"] = true;
    options["move_completed_path"] = moveCompletedPath;
  }

  const payload = { method: "core.add_torrent_magnet", params: [magnet, options], id: 1 };
  const result = await rpcCall(serverUrl, payload);
  if (!result.ok) return { success: false, error: result.error };
  if (result.data && result.data.error) {
    return { success: false, error: JSON.stringify(result.data.error) };
  }
  return { success: true, data: result.data };
}

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  const magnet = info.linkUrl || info.selectionText || info.pageUrl || "";
  if (!magnet.startsWith("magnet:")) {
    notify("Add to Deluge — skipped", "Selected link is not a magnet link.");
    return;
  }

  const settings = await getSettings();
  if (!settings.serverUrl || !settings.password) {
    notify("Add to Deluge — not configured", "Open extension and set the Deluge server URL and password.");
    return;
  }

  // Default download path stays the same
  const downloadPath = settings.downloadPath || "/downloads";

  // Set move completed path depending on menu choice
  let moveCompletedPath = "";
  if (info.menuItemId === MENU_MOVIES_ID) {
    moveCompletedPath = "/downloads/movies";
  } else if (info.menuItemId === MENU_TVSHOWS_ID) {
    moveCompletedPath = "/downloads/tv-shows";
  }

  notify("Add to Deluge", "Authenticating with Deluge...");
  const auth = await ensureAuthenticated(settings.serverUrl, settings.password);
  if (!auth.success) {
    notify("Authentication failed", String(auth.error));
    return;
  }

  notify("Add to Deluge", `Adding torrent...`);
  const added = await addMagnetToDeluge(settings.serverUrl, magnet, downloadPath, moveCompletedPath);
  if (!added.success) {
    notify("Failed to add torrent", String(added.error));
    return;
  }

  notify("Torrent added", `✅ Added successfully. Will move to ${moveCompletedPath} when completed.`);
});
