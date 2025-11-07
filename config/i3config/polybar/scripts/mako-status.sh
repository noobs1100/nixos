#!/usr/bin/env bash

# Check if mako is in Do Not Disturb mode
MODE=$(makoctl mode)

if echo "$MODE" | grep -q "dnd"; then
    echo "DND"
else
    # Count unread notifications
    COUNT=$(makoctl list | grep -c "\"id\":")
    if [ "$COUNT" -gt 0 ]; then
        echo "$COUNT"
    else
        echo "ON"
    fi
fi
