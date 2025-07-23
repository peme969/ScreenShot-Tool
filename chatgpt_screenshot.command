#!/bin/bash

# Screenshot directory and filename
mkdir -p ~/Screenshots
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILEPATH="$HOME/Screenshots/chatgpt_clip_$TIMESTAMP.png"

# Prompt user to take a screenshot and save it
screencapture -i "$FILEPATH"

# Check if screenshot exists and is non-zero size
if [[ ! -s "$FILEPATH" ]]; then
  osascript -e 'display notification "Screenshot canceled or failed." with title "Screenshot Tool" sound name "Funk"'
  exit 1
fi

# Copy image to clipboard using AppleScript (handles PNG)
osascript <<EOF
set imgFile to POSIX file "$FILEPATH"
set the clipboard to (read imgFile as «class PNGf»)
EOF

# Notify user
osascript -e "display notification \"Screenshot saved and copied to clipboard.\" with title \"Screenshot Tool\""

# Open ChatGPT in Brave
open -a "Brave Browser" "https://chat.openai.com/" --args --new-tab

# Wait for browser tab to load
sleep 5

# Paste the image into ChatGPT
osascript <<EOF
delay 1
tell application "System Events"
    keystroke "v" using {command down}
    delay 0.5
    key code 36 -- this is the Return (Enter) key
end tell
EOF
osascript -e "display notification \"Automation Successful!\" with title \"Screenshot Tool\""
