#!/usr/bin/env bash

# Switch to workspace 3
i3-msg workspace 3

# Check if Brave is already running
if i3-msg -t get_tree | grep -q '"class":"Brave-browser"'; then
    # Focus existing Brave window
    i3-msg '[class="Brave-browser"] focus'
else
    # Launch Brave if not running
    brave &
fi

