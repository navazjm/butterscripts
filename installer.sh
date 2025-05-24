#!/bin/bash

set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
declare -A COLORS=(
    [RED]='\033[0;31m'
    [GREEN]='\033[0;32m'
    [YELLOW]='\033[1;33m'
    [BLUE]='\033[0;34m'
    [PURPLE]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [WHITE]='\033[1;37m'
    [NC]='\033[0m'
)

# Global variables
declare -A SCRIPTS
declare -A CATEGORIES
declare -i SCRIPT_COUNT=0

# Category names
CATEGORIES=(
    [browsers]="Browser Installation"
    [discord]="Discord Setup"
    [fastfetch]="Fastfetch Configuration"
    [mkvmerge]="MKV Tools"
    [neovim]="Neovim Setup"
    [setup]="Development Tools"
    [st]="Simple Terminal"
    [system]="System Configuration"
    [theming]="Theming & Appearance"
    [wezterm]="WezTerm Terminal"
)

# Print functions
print_color() {
    local color=$1
    shift
    echo -e "${COLORS[$color]}$*${COLORS[NC]}"
}

print_header() {
    clear
    print_color CYAN "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color CYAN "║                           🧈 ButterScripts Installer                         ║"
    print_color CYAN "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo
}

print_category() {
    local category=$1
    echo
    print_color BLUE "━━━ $category ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

get_script_description() {
    local script=$1
    local desc=""
    
    # Try to extract description from script comments
    if [[ -f "$script" ]]; then
        desc=$(head -20 "$script" | grep -m1 -E "^#\s*(Description|Purpose|About):" | sed 's/^#\s*\(Description\|Purpose\|About\):\s*//' || true)
        
        # If no formal description, try to get any comment after shebang
        if [[ -z "$desc" ]]; then
            desc=$(head -20 "$script" | grep -m1 "^#\s*[A-Z]" | sed 's/^#\s*//' || true)
        fi
    fi
    
    # Default descriptions for known scripts
    if [[ -z "$desc" ]]; then
        case "$(basename "$script")" in
            install_browsers.sh) desc="Install various web browsers" ;;
            butterdis_simple.sh) desc="Simple Discord installation" ;;
            install_fastfetch.sh) desc="Install and configure Fastfetch" ;;
            mergemkvs) desc="Merge multiple MKV files" ;;
            buttervim.sh) desc="Install Neovim with custom config" ;;
            build-neovim.sh) desc="Build Neovim from source" ;;
            install_geany.sh) desc="Install Geany text editor" ;;
            install_picom.sh) desc="Install Picom compositor" ;;
            optional_tools.sh) desc="Install optional development tools" ;;
            install_st.sh) desc="Install simple terminal (st)" ;;
            add_bashrc.sh) desc="Add custom bash configuration" ;;
            install_bluetooth.sh) desc="Configure Bluetooth support" ;;
            install_lightdm.sh) desc="Install LightDM display manager" ;;
            install_printer_support.sh) desc="Setup printer support" ;;
            install_nerdfonts.sh) desc="Install Nerd Fonts collection" ;;
            install_theme.sh) desc="Install GTK themes and icons" ;;
            install_wezterm.sh) desc="Install WezTerm terminal" ;;
            *) desc="No description available" ;;
        esac
    fi
    
    echo "$desc"
}

discover_scripts() {
    SCRIPT_COUNT=0
    SCRIPTS=()
    
    # Find all .sh files and executable scripts
    while IFS= read -r -d '' script; do
        # Skip the installer itself
        [[ "$(basename "$script")" == "installer.sh" ]] && continue
        
        # Get relative path from script directory
        local rel_path="${script#$SCRIPT_DIR/}"
        local category="${rel_path%%/*}"
        
        # Skip if not in a recognized category
        [[ -z "${CATEGORIES[$category]:-}" ]] && continue
        
        SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
        SCRIPTS[$SCRIPT_COUNT]="$rel_path"
    done < <(find "$SCRIPT_DIR" -type f \( -name "*.sh" -o -executable \) -not -path "*/\.*" -print0 | sort -z)
}

display_menu() {
    local current_category=""
    
    for i in $(seq 1 $SCRIPT_COUNT | sort -n); do
        local script="${SCRIPTS[$i]}"
        local category="${script%%/*}"
        local script_name="$(basename "$script" .sh)"
        local description="$(get_script_description "$script")"
        
        # Print category header when it changes
        if [[ "$category" != "$current_category" ]]; then
            current_category="$category"
            print_category "${CATEGORIES[$category]}"
        fi
        
        # Format: number) script_name - description
        printf "  ${COLORS[GREEN]}%2d)${COLORS[NC]} %-25s ${COLORS[YELLOW]}%s${COLORS[NC]}\n" \
            "$i" "$script_name" "$description"
    done
    
    echo
    print_color PURPLE "━━━ Options ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color GREEN "  r) Refresh script list"
    print_color GREEN "  h) Show help"
    print_color GREEN "  q) Quit"
    echo
}

run_script() {
    local script_path="$1"
    local full_path="$SCRIPT_DIR/$script_path"
    local script_name="$(basename "$script_path")"
    
    echo
    print_color YELLOW "┌─ Running: $script_name"
    print_color YELLOW "└─ Path: $script_path"
    echo
    
    # Make executable if needed
    [[ -x "$full_path" ]] || chmod +x "$full_path"
    
    # Run the script
    if bash "$full_path"; then
        echo
        print_color GREEN "✓ $script_name completed successfully"
    else
        local exit_code=$?
        echo
        print_color RED "✗ $script_name failed with exit code $exit_code"
        return $exit_code
    fi
}

show_help() {
    print_header
    print_color CYAN "Help & Usage"
    echo
    echo "This installer helps you run various setup and configuration scripts."
    echo
    print_color YELLOW "How to use:"
    echo "  • Enter the number of the script you want to run"
    echo "  • Scripts are organized by category"
    echo "  • Some scripts may require sudo privileges"
    echo
    print_color YELLOW "Tips:"
    echo "  • Read script descriptions before running"
    echo "  • Check script contents if unsure what they do"
    echo "  • Scripts are designed to be idempotent (safe to run multiple times)"
    echo
    print_color CYAN "Press Enter to return to menu..."
    read -r
}

main() {
    # Initial script discovery
    discover_scripts
    
    if [[ $SCRIPT_COUNT -eq 0 ]]; then
        print_color RED "No scripts found in the current directory!"
        exit 1
    fi
    
    while true; do
        print_header
        display_menu
        
        echo -n "Select an option: "
        read -r choice
        
        case "$choice" in
            q|Q)
                echo
                print_color CYAN "Thanks for using ButterScripts! 🧈"
                exit 0
                ;;
            r|R)
                discover_scripts
                print_color GREEN "Script list refreshed!"
                sleep 1
                ;;
            h|H)
                show_help
                ;;
            ''|*[!0-9]*)
                print_color RED "Invalid input. Please enter a number or letter option."
                sleep 2
                ;;
            *)
                if [[ $choice -ge 1 && $choice -le $SCRIPT_COUNT ]]; then
                    run_script "${SCRIPTS[$choice]}"
                    echo
                    print_color CYAN "Press Enter to continue..."
                    read -r
                else
                    print_color RED "Invalid selection. Choose a number between 1 and $SCRIPT_COUNT"
                    sleep 2
                fi
                ;;
        esac
    done
}

# Run main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi