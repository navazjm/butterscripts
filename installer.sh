#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                            ButterScripts Installer                           ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_category() {
    echo -e "${BLUE}┌─ $1 ─────────────────────────────────────────────────────────────────────┐${NC}"
}

print_category_end() {
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo
}

discover_scripts() {
    declare -A categories
    categories[setup]="System Setup Scripts"
    categories[system]="System Configuration Scripts"
    categories[browsers]="Browser Installation Scripts"
    categories[config]="Configuration Scripts"
    categories[discord]="Discord Scripts"
    categories[fastfetch]="Fastfetch Setup Scripts"
    categories[neovim]="Neovim Setup Scripts"
    categories[theming]="Theming Scripts"
    categories[wezterm]="Wezterm Installation Scripts"

    counter=1
    declare -A script_map
    declare -A script_paths

    for category in setup system browsers config discord fastfetch neovim theming wezterm; do
        if [ -d "$category" ]; then
            scripts=($(find "$category" -name "*.sh" -type f | sort))
            if [ ${#scripts[@]} -gt 0 ]; then
                print_category "${categories[$category]}"
                for script in "${scripts[@]}"; do
                    script_name=$(basename "$script" .sh)
                    
                    # Skip the first 4 setup scripts (00-bash, 01-apps, 02-wm-dwm, 07-postinstall)
                    if [[ "$category" == "setup" && ("$script_name" == "00-bash" || "$script_name" == "01-apps" || "$script_name" == "02-wm-dwm" || "$script_name" == "07-postinstall") ]]; then
                        continue
                    fi
                    
                    script_desc=$(head -10 "$script" | grep -E "^#.*[Dd]escription|^# " | head -1 | sed 's/^# *//' || echo "No description available")
                    
                    printf "${GREEN}%2d)${NC} %-30s ${YELLOW}%s${NC}\n" "$counter" "$script_name" "$script_desc"
                    script_map[$counter]="$script"
                    script_paths[$counter]="$script"
                    ((counter++))
                done
                print_category_end
            fi
        fi
    done

    echo -e "${PURPLE}Special Options:${NC}"
    echo -e "${GREEN} a)${NC} Run all setup scripts (00-bash.sh → 07-postinstall.sh)"
    echo -e "${GREEN} q)${NC} Quit"
    echo

    return 0
}

run_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    echo -e "${YELLOW}Running: $script_name${NC}"
    echo -e "${BLUE}Path: $script_path${NC}"
    echo "─────────────────────────────────────────────────────────────────────────────"
    
    if [ -x "$script_path" ]; then
        bash "$script_path"
    else
        chmod +x "$script_path"
        bash "$script_path"
    fi
    
    local exit_code=$?
    echo "─────────────────────────────────────────────────────────────────────────────"
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ $script_name completed successfully${NC}"
    else
        echo -e "${RED}✗ $script_name failed with exit code $exit_code${NC}"
    fi
    echo
    
    return $exit_code
}

run_all_setup() {
    echo -e "${YELLOW}Running all setup scripts in order...${NC}"
    echo
    
    setup_scripts=(
        "setup/00-bash.sh"
        "setup/01-apps.sh"
        "setup/02-wm-dwm.sh"
        "setup/07-postinstall.sh"
    )
    
    for script in "${setup_scripts[@]}"; do
        if [ -f "$script" ]; then
            run_script "$script"
            echo -e "${CYAN}Press Enter to continue to next script, or Ctrl+C to stop...${NC}"
            read -r
        else
            echo -e "${RED}Warning: $script not found, skipping...${NC}"
        fi
    done
    
    echo -e "${GREEN}All setup scripts completed!${NC}"
}

main() {
    print_header
    
    while true; do
        counter=1
        declare -A script_map
        
        discover_scripts
        
        echo -n "Select a script to run (number/a/q): "
        read -r choice
        echo
        
        case "$choice" in
            q|Q)
                echo -e "${CYAN}Goodbye!${NC}"
                exit 0
                ;;
            a|A)
                run_all_setup
                echo
                echo -e "${CYAN}Press Enter to return to main menu...${NC}"
                read -r
                ;;
            *[!0-9]*)
                echo -e "${RED}Invalid choice. Please enter a number, 'a', or 'q'.${NC}"
                echo
                ;;
            *)
                if [ "$choice" -ge 1 ] && [ "$choice" -lt "$counter" ]; then
                    script_to_run=""
                    current=1
                    for category in setup system browsers config discord fastfetch neovim theming wezterm; do
                        if [ -d "$category" ]; then
                            scripts=($(find "$category" -name "*.sh" -type f | sort))
                            for script in "${scripts[@]}"; do
                                script_name=$(basename "$script" .sh)
                                
                                # Skip the first 4 setup scripts (00-bash, 01-apps, 02-wm-dwm, 07-postinstall)
                                if [[ "$category" == "setup" && ("$script_name" == "00-bash" || "$script_name" == "01-apps" || "$script_name" == "02-wm-dwm" || "$script_name" == "07-postinstall") ]]; then
                                    continue
                                fi
                                
                                if [ "$current" -eq "$choice" ]; then
                                    script_to_run="$script"
                                    break 2
                                fi
                                ((current++))
                            done
                        fi
                    done
                    
                    if [ -n "$script_to_run" ]; then
                        run_script "$script_to_run"
                        echo -e "${CYAN}Press Enter to return to main menu...${NC}"
                        read -r
                    fi
                else
                    echo -e "${RED}Invalid choice. Please select a number between 1 and $((counter-1)).${NC}"
                    echo
                fi
                ;;
        esac
    done
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi