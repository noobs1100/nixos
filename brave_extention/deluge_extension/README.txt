
Deluge JSON-RPC Chrome Extension
-------------------------------

Files:
- manifest.json
- background.js (service worker)
- popup.html
- popup.js
- icon48.png, icon128.png

How to install (Developer mode):
1. Open Chrome -> Extensions -> Load unpacked.
2. Select the folder containing the files (or unzip the provided zip and select the folder).
3. Click the extension icon -> set your Deluge server URL (e.g. http://192.168.1.10:8112/json), password, and optional download path.
4. Right-click a magnet link and choose "Add to Deluge".

Notes & troubleshooting:
- The extension uses the Deluge Web JSON-RPC endpoint (typically at http://<deluge-host>:8112/json).
- For authentication it calls "auth.login" and uses fetch with credentials included to receive cookies.
- If your Deluge WebUI is on HTTPS with a self-signed cert, your browser may block requests; consider adding the site as trusted or using a valid certificate.
- Host permissions allow access to any http/https host. You can narrow this in manifest.json if desired.
