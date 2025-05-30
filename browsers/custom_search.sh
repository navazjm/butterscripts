#!/bin/bash
# Firefox Search Shortcuts Installer
# Automatically adds custom search engine bookmarks with keywords to Firefox

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base search engines configuration (always included)
declare -A BASE_SEARCH_ENGINES=(
    ["gw"]="Google Web|https://google.com/search?udm=14&q=%s"
    ["gm"]="Google Maps|https://www.google.com/maps/search/%s"
    ["gi"]="Google Images|https://google.com/search?udm=2&q=%s"
    ["gn"]="Google News|https://google.com/search?udm=12&q=%s"
)

# SearXNG search engines (added optionally)
declare -A SEARXNG_ENGINES=(
    ["sx"]="SearXNG|%SEARXNG_URL%/search?q=%s"
    ["sxi"]="SearXNG Images|%SEARXNG_URL%/search?q=%s&categories=images"
    ["sxn"]="SearXNG News|%SEARXNG_URL%/search?q=%s&categories=news"
    ["sxv"]="SearXNG Videos|%SEARXNG_URL%/search?q=%s&categories=videos"
    ["sxm"]="SearXNG Maps|%SEARXNG_URL%/search?q=%s&categories=map"
)

# Global search engines array (will be populated based on user choice)
declare -A SEARCH_ENGINES=()

# Function to find Firefox profile directory
find_firefox_profile() {
    local profile_dir=""
    
    case "$(uname -s)" in
        Darwin*)
            profile_dir="$HOME/Library/Application Support/Firefox/Profiles"
            ;;
        Linux*)
            profile_dir="$HOME/.mozilla/firefox"
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            profile_dir="$HOME/AppData/Roaming/Mozilla/Firefox/Profiles"
            ;;
        *)
            echo -e "${RED}Unsupported operating system${NC}"
            exit 1
            ;;
    esac
    
    if [[ ! -d "$profile_dir" ]]; then
        echo -e "${RED}Firefox profile directory not found: $profile_dir${NC}"
        exit 1
    fi
    
    # Find default profile (usually contains 'default-release' for modern Firefox or 'default' for older/ESR)
    # Profile names look like: 9obz51ui.default-release, abc123def.default, etc.
    local default_profile=$(find "$profile_dir" -maxdepth 1 -type d -name "*default*" | head -1)
    
    if [[ -n "$default_profile" ]]; then
        echo "$default_profile"
    else
        # Fall back to first profile found (any directory that's not . or ..)
        local first_profile=$(find "$profile_dir" -maxdepth 1 -type d ! -name "." ! -name ".." ! -name "Crash Reports" ! -name "Pending Pings" | head -1)
        if [[ -n "$first_profile" ]]; then
            echo "$first_profile"
        else
            echo -e "${RED}No Firefox profiles found in $profile_dir${NC}"
            echo "Available directories:"
            ls -la "$profile_dir" 2>/dev/null || echo "Cannot list directory contents"
            exit 1
        fi
    fi
}

# Function to check if Firefox is running
setup_search_engines() {
    # Always add base search engines
    for keyword in "${!BASE_SEARCH_ENGINES[@]}"; do
        SEARCH_ENGINES["$keyword"]="${BASE_SEARCH_ENGINES[$keyword]}"
    done
    
    # Ask about SearXNG
    echo
    echo -e "${YELLOW}SearXNG Setup (Optional)${NC}"
    echo "SearXNG is a privacy-focused metasearch engine."
    echo "Do you want to add SearXNG search shortcuts?"
    read -p "Add SearXNG? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Enter your SearXNG instance URL (e.g., https://searx.example.com):"
        echo "Or press Enter to use a public instance (https://searx.be):"
        read -r searxng_url
        
        # Use default public instance if no URL provided
        if [[ -z "$searxng_url" ]]; then
            searxng_url="https://searx.be"
            echo "Using public instance: $searxng_url"
        fi
        
        # Validate URL format
        if [[ ! "$searxng_url" =~ ^https?:// ]]; then
            searxng_url="https://$searxng_url"
        fi
        
        # Remove trailing slash
        searxng_url="${searxng_url%/}"
        
        # Add SearXNG engines with the provided URL
        for keyword in "${!SEARXNG_ENGINES[@]}"; do
            engine_config="${SEARXNG_ENGINES[$keyword]}"
            # Replace placeholder with actual URL
            engine_config="${engine_config//%SEARXNG_URL%/$searxng_url}"
            SEARCH_ENGINES["$keyword"]="$engine_config"
        done
        
        echo -e "${GREEN}SearXNG search engines added!${NC}"
    else
        echo "Skipping SearXNG setup."
    fi
}
check_firefox_running() {
    if pgrep -x "firefox" > /dev/null; then
        echo -e "${YELLOW}Warning: Firefox is currently running.${NC}"
        echo "Please close Firefox before running this script to avoid data corruption."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Function to backup places.sqlite
backup_database() {
    local db_file="$1"
    local backup_file="${db_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    echo "Creating backup: $backup_file"
    cp "$db_file" "$backup_file"
    echo -e "${GREEN}Backup created successfully${NC}"
}

# Function to add bookmark with keyword
add_search_bookmark() {
    local db_file="$1"
    local keyword="$2"
    local title="$3"
    local url="$4"
    
    # Get current timestamp in microseconds
    local date_added=$(date +%s)000000
    
    # Check if bookmark with this keyword already exists
    local existing=$(sqlite3 "$db_file" "SELECT id FROM moz_bookmarks WHERE title='$title' LIMIT 1;" 2>/dev/null || echo "")
    
    if [[ -n "$existing" ]]; then
        echo "Updating existing bookmark: $title"
        sqlite3 "$db_file" "
            UPDATE moz_places SET url='$url' WHERE id=(
                SELECT fk FROM moz_bookmarks WHERE title='$title'
            );
            UPDATE moz_keywords SET keyword='$keyword' WHERE place_id=(
                SELECT fk FROM moz_bookmarks WHERE title='$title'
            );
        "
    else
        echo "Adding new bookmark: $title"
        sqlite3 "$db_file" "
            INSERT OR IGNORE INTO moz_places (url, title, visit_count, hidden, typed, frecency, last_visit_date, guid)
            VALUES ('$url', '$title', 0, 0, 0, -1, $date_added, lower(hex(randomblob(8))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))));
            
            INSERT INTO moz_bookmarks (type, fk, parent, position, title, keyword, folder_type, dateAdded, lastModified, guid)
            SELECT 1, moz_places.id, 
                   (SELECT id FROM moz_bookmarks WHERE parent=0 AND type=2 LIMIT 1),
                   (SELECT COALESCE(MAX(position), 0) + 1 FROM moz_bookmarks WHERE parent=(SELECT id FROM moz_bookmarks WHERE parent=0 AND type=2 LIMIT 1)),
                   '$title', '$keyword', NULL, $date_added, $date_added,
                   lower(hex(randomblob(8))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))
            FROM moz_places WHERE url='$url';
            
            INSERT OR REPLACE INTO moz_keywords (keyword, place_id, post_data)
            SELECT '$keyword', moz_places.id, NULL
            FROM moz_places WHERE url='$url';
        "
    fi
}

# Main function
main() {
    echo -e "${GREEN}Firefox Search Shortcuts Installer${NC}"
    echo
    
    # Setup search engines based on user preferences
    setup_search_engines
    
    echo
    echo "This script will add the following search shortcuts:"
    echo
    
    for keyword in "${!SEARCH_ENGINES[@]}"; do
        IFS='|' read -r title url <<< "${SEARCH_ENGINES[$keyword]}"
        echo "  $keyword -> $title"
    done
    echo
    
    # Check if Firefox is running
    check_firefox_running
    
    # Find Firefox profile
    echo "Finding Firefox profile..."
    PROFILE_DIR=$(find_firefox_profile)
    echo "Using profile: $PROFILE_DIR"
    
    # Check if places.sqlite exists
    PLACES_DB="$PROFILE_DIR/places.sqlite"
    if [[ ! -f "$PLACES_DB" ]]; then
        echo -e "${RED}Firefox database not found: $PLACES_DB${NC}"
        exit 1
    fi
    
    # Create backup
    backup_database "$PLACES_DB"
    
    # Add each search engine
    echo
    echo "Adding search shortcuts..."
    for keyword in "${!SEARCH_ENGINES[@]}"; do
        IFS='|' read -r title url <<< "${SEARCH_ENGINES[$keyword]}"
        echo "Adding: $keyword ($title)"
        add_search_bookmark "$PLACES_DB" "$keyword" "$title" "$url"
    done
    
    echo
    echo -e "${GREEN}Search shortcuts installed successfully!${NC}"
    echo
    echo "Usage in Firefox address bar:"
    echo "  gw pizza recipes    -> Google Web search"
    echo "  gm coffee shops     -> Google Maps search"
    echo "  gi sunset photos    -> Google Images search"
    echo "  gn tech news        -> Google News search"
    
    # Show SearXNG usage only if it was added
    if [[ -n "${SEARCH_ENGINES[sx]:-}" ]]; then
        echo "  sx privacy tools    -> SearXNG general search"
        echo "  sxi sunset photos   -> SearXNG Images search"
        echo "  sxn tech news       -> SearXNG News search"
        echo "  sxv funny cats      -> SearXNG Videos search"
        echo "  sxm coffee shops    -> SearXNG Maps search"
    fi
    echo
    echo "Restart Firefox (or Firefox ESR) to ensure changes take effect."
}

# Run main function
main "$@"
