#!/bin/bash
# Automated Firefox Search Engine Setup using policies.json

set -e

# Find Firefox installation directory
find_firefox_dir() {
    case "$(uname)" in
        Darwin)
            echo "/Applications/Firefox.app/Contents/Resources"
            ;;
        Linux)
            # Try common locations
            for dir in /usr/lib/firefox /opt/firefox /usr/lib64/firefox; do
                if [[ -d "$dir" ]]; then
                    echo "$dir"
                    return
                fi
            done
            # Fallback to system-wide config
            echo "/etc/firefox"
            ;;
        *)
            echo "Unsupported OS"
            exit 1
            ;;
    esac
}

FIREFOX_DIR=$(find_firefox_dir)
DIST_DIR="$FIREFOX_DIR/distribution"

echo "Setting up Firefox search engines..."
echo "Firefox directory: $FIREFOX_DIR"

# Create distribution directory if it doesn't exist
sudo mkdir -p "$DIST_DIR"

# Create policies.json with search engines
sudo tee "$DIST_DIR/policies.json" > /dev/null << 'EOF'
{
  "policies": {
    "SearchEngines": {
      "Add": [
        {
          "Name": "Google Web",
          "URLTemplate": "https://www.google.com/search?udm=14&q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": "@gw",
          "Description": "Google Web Search (text only)"
        },
        {
          "Name": "Google Images", 
          "URLTemplate": "https://www.google.com/search?udm=2&q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": "@gi",
          "Description": "Google Image Search"
        },
        {
          "Name": "Google News",
          "URLTemplate": "https://www.google.com/search?udm=12&q={searchTerms}",
          "Method": "GET", 
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": "@gn",
          "Description": "Google News Search"
        },
        {
          "Name": "Google Maps",
          "URLTemplate": "https://www.google.com/maps/search/{searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico", 
          "Alias": "@gm",
          "Description": "Google Maps Search"
        },
        {
          "Name": "DuckDuckGo",
          "URLTemplate": "https://duckduckgo.com/?q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://duckduckgo.com/favicon.ico",
          "Alias": "@ddg", 
          "Description": "DuckDuckGo Search"
        }
      ]
    }
  }
}
EOF

echo "✅ Firefox search engines configured!"
echo ""
echo "Restart Firefox to see the new search engines."
echo "You can use them with keywords like:"
echo "  @gw search term    -> Google Web"
echo "  @gi search term    -> Google Images" 
echo "  @gn search term    -> Google News"
echo "  @gm search term    -> Google Maps"
echo "  @ddg search term   -> DuckDuckGo"
echo ""
echo "The search engines will appear in Settings > Search"
