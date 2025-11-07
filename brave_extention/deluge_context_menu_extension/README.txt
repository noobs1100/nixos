Deluge Context Menu Chrome Extension
==================================

What it does
------------
- Adds two context menu options when you right-click a link:
  - "Add to Deluge — Movies" -> adds magnet to Deluge with download path /downloads/movies
  - "Add to Deluge — TV Shows" -> adds magnet to Deluge with download path /downloads/tv-shows
- Uses Deluge Web JSON-RPC (auth.login then core.add_torrent_magnet).
- Shows a desktop notification on success or failure.

How to install (developer mode)
-------------------------------
1. Open Chrome -> Extensions -> Developer mode -> Load unpacked.
2. Select the folder where you extracted the ZIP (the folder containing manifest.json).
3. Open Options (right-click the extension -> Options) and set your Deluge URL and password.
   Example Deluge URL: http://192.168.1.10:8112  (do NOT include /json)
4. Right-click a magnet link and choose one of the "Add to Deluge" options.

Notes & troubleshooting
-----------------------
- The extension sends POST requests to the Deluge Web UI /json endpoint. Ensure the Deluge Web UI is reachable from your browser (and not blocked by CORS or firewall).
- If Deluge runs in Docker and is bound to localhost, it may not be reachable from other machines. Make sure the container's web UI port is exposed and reachable.
- The extension uses chrome.storage.sync for settings.
