#!/bin/bash
# Simple Firefox Search Shortcuts Installer

set -e

# Check if sqlite3 exists
if ! command -v sqlite3 >/dev/null; then
    echo "Error: sqlite3 not found. Please install it first."
    exit 1
fi

# Find Firefox profile
case "$(uname)" in
    Darwin) PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles" ;;
    Linux) PROFILE_DIR="$HOME/.mozilla/firefox" ;;
    *) echo "Unsupported OS"; exit 1 ;;
esac

PROFILE=$(find "$PROFILE_DIR" -name "*default*" -type d | head -1)
if [[ -z "$PROFILE" ]]; then
    echo "Firefox profile not found"
    exit 1
fi

DB="$PROFILE/places.sqlite"
if [[ ! -f "$DB" ]]; then
    echo "Firefox database not found"
    exit 1
fi

# Check if Firefox is running
if pgrep firefox >/dev/null; then
    echo "Please close Firefox first"
    exit 1
fi

# Backup
cp "$DB" "$DB.backup"

# Search engines
declare -A ENGINES=(
    ["@gw"]="Google Web|https://google.com/search?q=%s"
    ["@gi"]="Google Images|https://google.com/search?tbm=isch&q=%s"
    ["@gm"]="Google Maps|https://maps.google.com/maps?q=%s"
    ["@yt"]="YouTube|https://youtube.com/results?search_query=%s"
    ["@w"]="Wikipedia|https://en.wikipedia.org/wiki/Special:Search/%s"
)

echo "Adding search shortcuts..."

for keyword in "${!ENGINES[@]}"; do
    IFS='|' read -r title url <<< "${ENGINES[$keyword]}"
    echo "  $keyword -> $title"
    
    # Add to places
    sqlite3 "$DB" "INSERT OR IGNORE INTO moz_places (url, title) VALUES ('$url', '$title');"
    
    # Get place ID
    place_id=$(sqlite3 "$DB" "SELECT id FROM moz_places WHERE url='$url' LIMIT 1;")
    
    # Add keyword
    sqlite3 "$DB" "INSERT OR REPLACE INTO moz_keywords (keyword, place_id) VALUES ('$keyword', $place_id);"
done

echo "Done! Restart Firefox and use shortcuts like: @gw search term"
