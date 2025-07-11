#!/bin/bash

# Geany Installation and Configuration Script
# This script installs Geany and applies your custom configuration
# from the butterscripts repository by drewgrif

# Define color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

set -e  # Exit on any error

echo -e "${CYAN}Installing Geany and essential plugins...${NC}"

# Install Geany and only the plugins we're actually using
if command -v apt &> /dev/null; then
    sudo apt update
    # Install base Geany
    sudo apt install -y geany
    
    # Install only the specific plugins we need
    # Check if individual plugin packages exist, otherwise install the full suite
    if apt list geany-plugin-addons 2>/dev/null | grep -q geany-plugin-addons; then
        sudo apt install -y geany-plugin-addons geany-plugin-automark geany-plugin-git-changebar \
                           geany-plugin-insertnum geany-plugin-markdown geany-plugin-spellcheck \
                           geany-plugin-treebrowser
    else
        # Fallback to full plugin package if individual packages don't exist
        sudo apt install -y geany-plugins
    fi
    
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm geany geany-plugins
elif command -v dnf &> /dev/null; then
    sudo dnf install -y geany geany-plugins
elif command -v zypper &> /dev/null; then
    sudo zypper install -y geany geany-plugins
else
    echo -e "${RED}Unsupported package manager. Please install Geany manually.${NC}"
    exit 1
fi

echo -e "${GREEN}Geany installed successfully!${NC}"

# Install custom color schemes from drewgrif/geany-themes
echo -e "${CYAN}Installing custom Geany color schemes...${NC}"

# Create colorschemes directory
COLORSCHEMES_DIR="$HOME/.config/geany/colorschemes"
mkdir -p "$COLORSCHEMES_DIR"

# Clone the geany-themes repository to a temporary location
TEMP_THEMES_DIR="/tmp/geany-themes"
if [ -d "$TEMP_THEMES_DIR" ]; then
    rm -rf "$TEMP_THEMES_DIR"
fi

git clone https://github.com/drewgrif/geany-themes.git "$TEMP_THEMES_DIR"

# Copy all .conf files to the colorschemes directory
if [ -d "$TEMP_THEMES_DIR" ]; then
    cp "$TEMP_THEMES_DIR/colorschemes"/*.conf "$COLORSCHEMES_DIR/" 2>/dev/null || echo -e "${YELLOW}Note: Some theme files may not have been copied${NC}"
    echo -e "${GREEN}Custom color schemes installed successfully!${NC}"
    
    # List available themes
    echo -e "${CYAN}Available themes:${NC}"
    ls "$COLORSCHEMES_DIR"/*.conf 2>/dev/null | sed 's|.*/||' | sed 's|\.conf$||' | sort
    
    # Clean up
    rm -rf "$TEMP_THEMES_DIR"
else
    echo -e "${YELLOW}Warning: Could not clone themes repository. Using default themes.${NC}"
fi

# Create Geany config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/geany"
mkdir -p "$CONFIG_DIR"

echo -e "${CYAN}Applying custom Geany configuration...${NC}"

# Function to detect plugin paths and build list of only the plugins we want
detect_plugin_paths() {
    local plugin_paths=""
    local base_paths=(
        "/usr/lib/x86_64-linux-gnu/geany"
        "/usr/lib64/geany"
        "/usr/lib/geany"
        "/usr/local/lib/geany"
    )
    
    # Only the plugins we're actually configuring and using
    local wanted_plugins=("addons" "automark" "git-changebar" "geanyinsertnum" "markdown" "spellcheck" "splitwindow" "treebrowser")
    
    for path in "${base_paths[@]}"; do
        if [ -d "$path" ]; then
            local available_plugins=""
            for plugin in "${wanted_plugins[@]}"; do
                if [ -f "$path/$plugin.so" ]; then
                    if [ -n "$available_plugins" ]; then
                        available_plugins="$available_plugins;$path/$plugin.so"
                    else
                        available_plugins="$path/$plugin.so"
                    fi
                fi
            done
            plugin_paths="$available_plugins"
            break
        fi
    done
    echo "$plugin_paths"
}

# Detect available plugins
PLUGIN_PATHS=$(detect_plugin_paths)

# Create clean configuration for fresh installation
cat > "$CONFIG_DIR/geany.conf" << EOF
[geany]
default_open_path=
cmdline_new_files=true
notebook_double_click_hides_widgets=false
tab_close_switch_to_mru=false
tab_pos_sidebar=2
sidebar_pos=0
symbols_sort_mode=0
msgwin_orientation=0
highlighting_invert_all=false
pref_main_search_use_current_word=true
check_detect_indent=false
detect_indent_width=false
use_tab_to_indent=true
pref_editor_tab_width=4
indent_mode=2
indent_type=0
virtualspace=1
autocomplete_doc_words=false
completion_drops_rest_of_word=false
autocompletion_max_entries=30
autocompletion_update_freq=250
color_scheme=github-dark-default.conf
scroll_lines_around_cursor=0
mru_length=10
disk_check_timeout=30
show_editor_scrollbars=false
brace_match_ltgt=false
use_gtk_word_boundaries=true
complete_snippets_whilst_editing=false
indent_hard_tab_width=8
editor_ime_interaction=0
use_atomic_file_saving=false
gio_unsafe_save_backup=false
use_gio_unsafe_file_saving=true
keep_edit_history_on_reload=true
show_keep_edit_history_on_reload_msg=false
reload_clean_doc_on_file_change=false
save_config_on_file_change=true
extract_filetype_regex=-\\*-\\s*([^\\s]+)\\s*-\\*-
allow_always_save=false
find_selection_type=0
replace_and_find_by_default=true
show_symbol_list_expanders=true
compiler_tab_autoscroll=true
statusbar_template=line: %l / %L	 col: %c	 sel: %s	 %w      %t      %mmode: %M      encoding: %e      filetype: %f      scope: %S
new_document_after_close=false
msgwin_status_visible=true
msgwin_compiler_visible=true
msgwin_messages_visible=true
msgwin_scribble_visible=true
documents_show_paths=true
sidebar_page=2
pref_main_load_session=true
pref_main_project_session=true
pref_main_project_file_in_basedir=false
pref_main_save_winpos=true
pref_main_save_wingeom=true
pref_main_confirm_exit=false
pref_main_suppress_status_messages=false
switch_msgwin_pages=false
beep_on_errors=true
auto_focus=false
sidebar_symbol_visible=false
sidebar_openfiles_visible=false
editor_font=SauceCodePro Nerd Font Mono Regular 16
tagbar_font=Sans 9
msgwin_font=SauceCodePro Nerd Font Mono Regular 12
show_notebook_tabs=true
show_tab_cross=true
tab_order_ltr=true
tab_order_beside=false
tab_pos_editor=2
tab_pos_msgwin=0
use_native_windows_dialogs=false
show_indent_guide=false
show_white_space=false
show_line_endings=false
show_markers_margin=true
show_linenumber_margin=true
long_line_enabled=false
long_line_type=0
long_line_column=72
long_line_color=#C2EBC2
symbolcompletion_max_height=10
symbolcompletion_min_chars=4
use_folding=true
unfold_all_children=false
use_indicators=true
line_wrapping=true
auto_close_xml_tags=true
complete_snippets=true
auto_complete_symbols=true
pref_editor_disable_dnd=false
pref_editor_smart_home_key=true
pref_editor_newline_strip=false
line_break_column=72
auto_continue_multiline=true
comment_toggle_mark=~ 
scroll_stop_at_last_line=true
autoclose_chars=0
pref_editor_default_new_encoding=UTF-8
pref_editor_default_open_encoding=none
default_eol_character=2
pref_editor_new_line=true
pref_editor_ensure_convert_line_endings=false
pref_editor_replace_tabs=false
pref_editor_trail_space=false
pref_toolbar_show=true
pref_toolbar_append_to_menu=true
pref_toolbar_use_gtk_default_style=false
pref_toolbar_use_gtk_default_icon=false
pref_toolbar_icon_style=3
pref_toolbar_icon_size=0
pref_template_developer=
pref_template_company=
pref_template_mail=
pref_template_initial=
pref_template_version=1.0
pref_template_year=%Y
pref_template_date=%Y-%m-%d
pref_template_datetime=%d.%m.%Y %H:%M:%S %Z
context_action_cmd=
sidebar_visible=true
statusbar_visible=true
msgwindow_visible=false
fullscreen=false
color_picker_palette=
scribble_text=Type here what you want, use it as a notice/scratch board
scribble_pos=0
treeview_position=200
msgwindow_position=500
geometry=0;0;1200;800;0;
custom_date_format=

[build-menu]
number_ft_menu_items=0
number_non_ft_menu_items=0
number_exec_menu_items=0

[search]
pref_search_hide_find_dialog=false
pref_search_always_wrap=false
pref_search_current_file_dir=true
find_all_expanded=false
replace_all_expanded=true
position_find_x=-1
position_find_y=-1
position_replace_x=-1
position_replace_y=-1
position_fif_x=-1
position_fif_y=-1
fif_regexp=false
fif_case_sensitive=true
fif_match_whole_word=false
fif_invert_results=false
fif_recursive=false
fif_extra_options=
fif_use_extra_options=false
fif_files=
fif_files_mode=0
find_regexp=false
find_regexp_multiline=false
find_case_sensitive=false
find_escape_sequences=false
find_match_whole_word=false
find_match_word_start=false
find_close_dialog=true
replace_regexp=false
replace_regexp_multiline=false
replace_case_sensitive=false
replace_escape_sequences=false
replace_match_whole_word=false
replace_match_word_start=false
replace_search_backwards=false
replace_close_dialog=true

[plugins]
load_plugins=true
custom_plugin_path=
active_plugins=$PLUGIN_PATHS

[VTE]
send_cmd_prefix=
send_selection_unsafe=false
load_vte=true
font=SauceCodePro Nerd Font Mono Regular 14
scroll_on_key=true
scroll_on_out=true
enable_bash_keys=true
ignore_menu_bar_accel=false
follow_path=false
run_in_vte=false
skip_run_script=false
cursor_blinks=false
scrollback_lines=500
shell=/bin/bash
colour_fore=#FFFFFF
colour_back=#000000
last_dir=$HOME

[tools]
terminal_cmd=wezterm -e "/bin/sh %c"
browser_cmd=sensible-browser
grep_cmd=grep

[printing]
print_cmd=
use_gtk_printing=true
print_line_numbers=true
print_page_numbers=true
print_page_header=true
page_header_basename=false
page_header_datefmt=%c

[project]
session_file=
project_file_path=$HOME/projects

[files]
recent_files=
recent_projects=
current_page=0

EOF

# Create keybindings configuration with all defaults plus our custom bindings
cat > "$CONFIG_DIR/keybindings.conf" << 'EOF'
[Bindings]
menu_new=<Primary>n
menu_open=<Primary>o
menu_open_selected=<Primary><Shift>o
menu_save=<Primary>s
menu_saveas=
menu_saveall=<Primary><Shift>s
file_properties=<Primary><Shift>v
menu_print=<Primary>p
menu_close=<Primary>w
menu_closeall=<Primary><Shift>w
menu_reloadfile=<Primary>r
menu_reloadall=
file_openlasttab=
menu_quit=<Primary>q
menu_undo=<Primary>z
menu_redo=<Primary>y
edit_duplicateline=<Primary>d
edit_deleteline=<Primary>k
edit_deletelinetoend=<Primary><Shift>Delete
edit_deletelinetobegin=<Primary><Shift>BackSpace
edit_transposeline=
edit_scrolltoline=<Primary><Shift>l
edit_scrolllineup=<Alt>Up
edit_scrolllinedown=<Alt>Down
edit_completesnippet=Tab
move_snippetnextcursor=
edit_suppresssnippetcompletion=
popup_contextaction=
edit_autocomplete=<Primary>space
edit_calltip=<Primary><Shift>space
edit_wordpartcompletion=Tab
edit_movelineup=<Alt>Page_Up
edit_movelinedown=<Alt>Page_Down
menu_cut=<Primary>x
menu_copy=<Primary>c
menu_paste=<Primary>v
edit_copyline=<Primary><Shift>c
edit_cutline=<Primary><Shift>x
menu_selectall=<Primary>a
edit_selectword=<Shift><Alt>w
edit_selectline=<Shift><Alt>l
edit_selectparagraph=<Shift><Alt>p
edit_selectwordpartleft=
edit_selectwordpartright=
edit_togglecase=<Primary><Alt>u
edit_commentlinetoggle=<Primary>e
edit_commentline=
edit_uncommentline=
edit_increaseindent=<Primary>i
edit_decreaseindent=<Primary>u
edit_increaseindentbyspace=
edit_decreaseindentbyspace=
edit_autoindent=
edit_sendtocmd1=<Primary>1
edit_sendtocmd2=<Primary>2
edit_sendtocmd3=<Primary>3
edit_sendtocmd4=
edit_sendtocmd5=
edit_sendtocmd6=
edit_sendtocmd7=
edit_sendtocmd8=
edit_sendtocmd9=
edit_sendtovte=
format_reflowparagraph=<Primary>j
edit_joinlines=
menu_insert_date=<Shift><Alt>d
edit_insertwhitespace=
edit_insertlinebefore=
edit_insertlineafter=
menu_preferences=<Primary><Alt>p
menu_pluginpreferences=
menu_find=<Primary>f
menu_findnext=<Primary>g
menu_findprevious=<Primary><Shift>g
menu_findnextsel=
menu_findprevsel=
menu_replace=<Primary>h
menu_findinfiles=<Primary><Shift>f
menu_nextmessage=
menu_previousmessage=
popup_findusage=<Primary><Shift>e
popup_finddocumentusage=<Primary><Shift>d
find_markall=<Primary><Shift>m
nav_back=<Alt>Left
nav_forward=<Alt>Right
menu_gotoline=<Primary>l
edit_gotomatchingbrace=<Primary>b
edit_togglemarker=<Primary>m
edit_gotonextmarker=<Primary>period
edit_gotopreviousmarker=<Primary>comma
popup_gototagdefinition=<Primary>t
popup_gototagdeclaration=<Primary><Shift>t
edit_gotolinestart=Home
edit_gotolineend=End
edit_gotolinestartvisual=<Alt>Home
edit_gotolineendvisual=<Alt>End
edit_prevwordstart=<Primary>slash
edit_nextwordstart=<Primary>backslash
menu_toggleall=
menu_fullscreen=F11
menu_messagewindow=<Alt>period
toggle_sidebar=<Alt>comma
menu_zoomin=<Primary>plus
menu_zoomout=<Primary>minus
normal_size=<Primary>0
menu_linewrap=
menu_linebreak=
menu_clone=
menu_strip_trailing_spaces=
menu_replacetabs=
menu_replacespaces=
menu_togglefold=
menu_foldall=
menu_unfoldall=
reloadtaglist=<Primary><Shift>r
remove_markers=
remove_error_indicators=
remove_markers_and_indicators=
project_new=
project_open=
project_properties=
project_close=
build_compile=F8
build_link=F9
build_make=<Shift>F9
build_makeowntarget=<Primary><Shift>F9
build_makeobject=<Shift>F8
build_nexterror=
build_previouserror=
build_run=F5
build_options=
menu_opencolorchooser=
menu_help=F1
switch_editor=F2
switch_search_bar=F7
switch_message_window=
switch_compiler=
switch_messages=
switch_scribble=F6
switch_vte=F4
switch_sidebar=
switch_sidebar_symbol_list=
switch_sidebar_doc_list=
switch_tableft=<Primary>Page_Up
switch_tabright=<Primary>Page_Down
switch_tablastused=<Primary>Tab
move_tableft=<Primary><Shift>Page_Up
move_tabright=<Primary><Shift>Page_Down
move_tabfirst=
move_tablast=

[addons]
focus_bookmark_list=
focus_tasks=
update_tasks=
xml_tagging=
copy_file_path=
Enclose_1=
Enclose_2=
Enclose_3=
Enclose_4=
Enclose_5=
Enclose_6=
Enclose_7=
Enclose_8=

[git-changebar]
goto-prev-hunk=
goto-next-hunk=
undo-hunk=

[insert_numbers]
insert_numbers=

[spellcheck]
spell_check=
spell_toggle_typing=

[split_window]
split_horizontal=
split_vertical=
split_unsplit=

[file_browser]
focus_file_list=
focus_path_entry=
rename_object=
create_file=
create_dir=
rename_refresh=
track_current=
EOF

# Create projects directory if it doesn't exist
mkdir -p "$HOME/projects"

# Configure Markdown plugin to use message window instead of sidebar
mkdir -p "$CONFIG_DIR/plugins/markdown"
cat > "$CONFIG_DIR/plugins/markdown/markdown.conf" << EOF
[markdown]
preview_in_msgwin=true
preview_in_sidebar=false

[general]
template=$CONFIG_DIR/plugins/markdown/template.html

[view]
position=1
font_name=Serif
code_font_name=Mono
font_point_size=12
code_font_point_size=12
bg_color=#ffffff
fg_color=#000000
EOF

# Configure Addons plugin
mkdir -p "$CONFIG_DIR/plugins/addons"
cat > "$CONFIG_DIR/plugins/addons/addons.conf" << EOF
[addons]
show_toolbar_doclist_item=true
doclist_sort_mode=2
enable_openuri=false
enable_tasks=true
tasks_token_list=TODO;FIXME
tasks_scan_all_documents=false
enable_systray=false
enable_bookmarklist=false
enable_markword=false
enable_markword_single_click_deselect=false
strip_trailing_blank_lines=false
enable_xmltagging=false
enable_enclose_words=false
enable_enclose_words_auto=false
enable_colortip=true
enable_double_click_color_chooser=false
EOF

# Configure Treebrowser plugin
mkdir -p "$CONFIG_DIR/plugins/treebrowser"
cat > "$CONFIG_DIR/plugins/treebrowser/treebrowser.conf" << EOF
[treebrowser]
open_external_cmd=wezterm -e nvim '%f'
open_terminal=wezterm
reverse_filter=false
one_click_chdoc=false
show_hidden_files=true
hide_object_files=false
show_bars=2
chroot_on_dclick=false
follow_current_doc=true
on_delete_close_file=true
on_open_focus_editor=false
show_tree_lines=true
show_bookmarks=false
show_icons=2
open_new_files=true
EOF

echo -e "${GREEN}Custom Geany configuration applied successfully!${NC}"
echo ""
echo -e "${GREEN}✓ Geany installed with essential plugins only${NC}"
echo -e "${GREEN}✓ Custom color schemes installed from drewgrif/geany-themes${NC}"
echo -e "${GREEN}✓ GitHub dark theme configured (or best available)${NC}"
echo -e "${GREEN}✓ Useful plugins enabled (if available):${NC}"
echo -e "${CYAN}  - Addons (extra tools + color calltips)${NC}"
echo -e "${CYAN}  - Automark (highlight matching words)${NC}"
echo -e "${CYAN}  - Git changebar (show git changes)${NC}"
echo -e "${CYAN}  - Insert numbers${NC}"
echo -e "${CYAN}  - Markdown support (in message window)${NC}"
echo -e "${CYAN}  - Spell check${NC}"
echo -e "${CYAN}  - Split window${NC}"
echo -e "${CYAN}  - Tree browser (shows hidden files, uses WezTerm, toolbar at bottom)${NC}"
echo -e "${GREEN}✓ Clean configuration ready for first use${NC}"
echo -e "${GREEN}✓ Projects directory created at ~/projects${NC}"
echo -e "${GREEN}✓ Color calltips enabled for CSS/HTML color values${NC}"
echo -e "${GREEN}✓ Treebrowser shows hidden files and dotfiles${NC}"
echo -e "${GREEN}✓ Treebrowser toolbar positioned at bottom${NC}"
echo -e "${GREEN}✓ Default terminal set to WezTerm${NC}"
echo ""
echo -e "${CYAN}Geany is ready to use! Launch it and enjoy your pre-configured setup.${NC}"

# Optional: Check if preferred color scheme exists, fallback gracefully
PREFERRED_SCHEME="github-dark-default.conf"
if [ -f "$COLORSCHEMES_DIR/$PREFERRED_SCHEME" ]; then
    echo -e "${GREEN}✓ Preferred GitHub dark theme is available${NC}"
elif [ -f "$COLORSCHEMES_DIR/github-dark.conf" ]; then
    echo -e "${GREEN}✓ GitHub dark theme variant found${NC}"
    # Update config to use available variant
    sed -i 's/color_scheme=github-dark-default.conf/color_scheme=github-dark.conf/' "$CONFIG_DIR/geany.conf"
else
    echo -e "${YELLOW}⚠️  GitHub dark theme not found, using first available dark theme${NC}"
    # Find any dark theme and use it
    DARK_THEME=$(ls "$COLORSCHEMES_DIR"/*dark*.conf 2>/dev/null | head -1 | sed 's|.*/||')
    if [ -n "$DARK_THEME" ]; then
        sed -i "s/color_scheme=github-dark-default.conf/color_scheme=$DARK_THEME/" "$CONFIG_DIR/geany.conf"
        echo -e "${GREEN}✓ Using $DARK_THEME instead${NC}"
    fi
fi
