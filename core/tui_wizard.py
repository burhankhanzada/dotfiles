#!/usr/bin/env python3
"""
Claude Code-style Interactive Multi-Tab TUI Wizard for Dotfiles Installer.
Supports nested collapsible categories for macOS system preferences.
Zero external dependencies (uses Python standard library curses).
"""

import curses
import json
import sys
import os
import argparse

# ----------------------------------------------------------------------
# Configuration Data & Definitions
# ----------------------------------------------------------------------

TABS_DATA = [
    {
        "id": "packages",
        "title": "1. Packages & Tools",
        "description": "Select development toolchains, languages, and IDEs to configure:",
        "is_tree": False,
        "items": [
            {"id": "git", "label": "Git", "desc": "Config, aliases, global gitignore, and helpers", "selected": True},
            {"id": "vscode", "label": "VS Code", "desc": "Settings, styles, and shared extension base pool", "selected": True},
            {"id": "antigravity-ide", "label": "Antigravity IDE", "desc": "AI coding IDE, CLI binaries, and shared extensions", "selected": True},
            {"id": "android-tools", "label": "Android Tools", "desc": "Standalone Android CLI agent tools & ADB (No Studio)", "selected": True},
            {"id": "android-studio", "label": "Android Studio", "desc": "Full Android Studio IDE application and JBR", "selected": False},
            {"id": "flutter", "label": "Flutter", "desc": "Flutter FVM version manager, Dart SDK, and CLI tools", "selected": True},
            {"id": "python", "label": "Python", "desc": "Pyenv version manager, python-tk, and JupyterLab", "selected": True},
            {"id": "node", "label": "Node.js", "desc": "Node LTS runtime and global npm package setup", "selected": True},
            {"id": "rust", "label": "Rust", "desc": "Rustup toolchain, cargo binaries, and sccache", "selected": True},
            {"id": "ruby", "label": "Ruby", "desc": "Ruby-install, chruby environment, and ruby-lsp", "selected": True},
            {"id": "java", "label": "Java", "desc": "OpenJDK runtime, Maven, and JAVA_HOME paths", "selected": True},
            {"id": "cmake", "label": "CMake", "desc": "CMake build system, Ninja, and ccache support", "selected": True},
            {"id": "cocoapods", "label": "CocoaPods", "desc": "iOS dependency manager and local spec repos", "selected": True},
            {"id": "llvm", "label": "LLVM & Clang", "desc": "LLVM toolchain, clangd language server, lldb-dap", "selected": True},
            {"id": "warp", "label": "Warp Terminal", "desc": "AI terminal themes, keybindings, and custom workflows", "selected": True},
            {"id": "xcode", "label": "Xcode", "desc": "Command line tools, simulator SDKs, and links", "selected": True},
            {"id": "yabai", "label": "Yabai & Skhd", "desc": "Tiling window manager and hotkey daemon configs", "selected": True},
            {"id": "firebase", "label": "Firebase", "desc": "Google Firebase CLI tools and emulator setup", "selected": True},
            {"id": "parallels", "label": "Parallels", "desc": "Virtual machine configs and Parallels toolbox", "selected": False},
            {"id": "wine", "label": "Wine", "desc": "Windows compatibility layer and CXPatcher links", "selected": False},
            {"id": "generic", "label": "Generic Tools", "desc": "Core system aliases, directory helpers, and paths", "selected": True},
        ]
    },
    {
        "id": "macos",
        "title": "2. macOS Defaults",
        "description": "Customize macOS settings (Press → or e to expand/collapse categories):",
        "is_tree": True,
        "categories": [
            {
                "id": "ui",
                "label": "UI & Appearance",
                "desc": "Theme, Dock behavior, animations, and menu bar",
                "expanded": False,
                "items": [
                    {"id": "ui_dark_mode", "label": "Dark Theme", "desc": "Enable system dark mode", "selected": True},
                    {"id": "ui_reduce_motion", "label": "Reduce Animations", "desc": "Reduce motion in Accessibility for faster transitions", "selected": True},
                    {"id": "ui_dock_left", "label": "Dock on Left", "desc": "Place Dock on left screen edge", "selected": True},
                    {"id": "ui_dock_compact", "label": "Compact Dock (35px)", "desc": "Compact dock with 50px magnification", "selected": True},
                    {"id": "ui_dock_active_only", "label": "Only Active Apps", "desc": "Show only open applications in Dock", "selected": True},
                    {"id": "ui_dock_minimize_app", "label": "Minimize into App Icon", "desc": "Scale effect into app icon", "selected": True},
                    {"id": "ui_dock_dim_hidden", "label": "Dim Hidden Icons", "desc": "Dim icons of hidden applications (Cmd+H)", "selected": True},
                    {"id": "ui_spaces_fixed", "label": "Fixed Spaces Order", "desc": "Disable auto-rearranging Spaces by MRU", "selected": True},
                    {"id": "ui_launchpad_grid", "label": "Launchpad Grid (6x8)", "desc": "Dense 6 rows x 8 columns Launchpad", "selected": True},
                    {"id": "ui_battery_percent", "label": "Battery Percentage", "desc": "Show battery percentage in menu bar", "selected": True},
                    {"id": "ui_hide_spotlight", "label": "Hide Spotlight Icon", "desc": "Hide Spotlight from menu bar (use Cmd+Space)", "selected": True},
                ]
            },
            {
                "id": "finder",
                "label": "Finder & Desktop",
                "desc": "Desktop clutter, file extensions, and path bar",
                "expanded": False,
                "items": [
                    {"id": "finder_clean_desktop", "label": "Clean Desktop", "desc": "Hide all icons and disks from desktop", "selected": True},
                    {"id": "finder_show_extensions", "label": "Show File Extensions", "desc": "Show all filename extensions (.jpg, .ts, etc.)", "selected": True},
                    {"id": "finder_show_pathbar", "label": "Show Path & Status Bar", "desc": "Show breadcrumb path bar and status bar", "selected": True},
                    {"id": "finder_folders_on_top", "label": "Folders on Top", "desc": "Keep folders sorted at the top when sorting", "selected": True},
                    {"id": "finder_search_current_folder", "label": "Search Current Folder", "desc": "Default Finder search scope to current folder", "selected": True},
                    {"id": "finder_show_hidden", "label": "Show Hidden Files", "desc": "Reveal hidden dotfiles in Finder by default", "selected": True},
                    {"id": "finder_disable_trash_warning", "label": "Silent Trash Empty", "desc": "Disable empty trash warning & sound", "selected": True},
                    {"id": "finder_disable_extension_warning", "label": "Extension Change Warning", "desc": "Disable warning when renaming file extension", "selected": True},
                    {"id": "finder_disable_quarantine", "label": "Disable App Quarantine", "desc": "Disable 'Are you sure you want to open this?'", "selected": True},
                    {"id": "finder_no_ds_store_usb_network", "label": "No .DS_Store on USB", "desc": "Suppress .DS_Store on network and USB shares", "selected": True},
                    {"id": "finder_expand_save_panels", "label": "Expand Save Panels", "desc": "Expand save and print dialogs by default", "selected": True},
                    {"id": "finder_sidebar_clean", "label": "Clean Sidebar", "desc": "Hide tags and unused sections from sidebar", "selected": True},
                ]
            },
            {
                "id": "hardware",
                "label": "Hardware & Input",
                "desc": "Keyboard repeat rate, trackpad gestures, startup chime",
                "expanded": False,
                "items": [
                    {"id": "hardware_fast_key_repeat", "label": "Fast Key Repeat Rate", "desc": "High repeat rate with short initial delay", "selected": True},
                    {"id": "hardware_disable_press_hold", "label": "Disable Press-and-Hold", "desc": "Enable fast repeating keys in editors and shell", "selected": True},
                    {"id": "hardware_disable_autocap", "label": "Disable Auto-Capitalize", "desc": "Stop macOS from auto-capitalizing words", "selected": True},
                    {"id": "hardware_tap_to_click", "label": "Tap to Click", "desc": "Enable tap-to-click on built-in trackpad", "selected": True},
                    {"id": "hardware_three_finger_drag", "label": "3-Finger Dragging", "desc": "Enable 3-finger dragging on trackpad", "selected": True},
                    {"id": "hardware_disable_chrome_swipe", "label": "Disable Chrome Backswipe", "desc": "Stop accidental navigation when scrolling in Chrome", "selected": True},
                    {"id": "hardware_mute_startup_chime", "label": "Mute Startup Chime", "desc": "Silence Mac boot chime (nvram StartupMute=%01)", "selected": True},
                    {"id": "hardware_display_sleep", "label": "Display Sleep Timeout", "desc": "15 min on battery, 30 min on AC power", "selected": True},
                ]
            },
            {
                "id": "system",
                "label": "System & Screenshots",
                "desc": "Screenshot locations, formats, and diagnostics",
                "expanded": False,
                "items": [
                    {"id": "system_screenshot_dir", "label": "Screenshots Folder", "desc": "Save screenshots to ~/Pictures/Screenshots", "selected": True},
                    {"id": "system_screenshot_no_shadow", "label": "Disable Window Shadow", "desc": "Capture clean window screenshots without shadows", "selected": True},
                    {"id": "system_screenshot_jpg", "label": "Screenshot Format JPG", "desc": "Save screenshots as JPG instead of heavy PNG", "selected": True},
                    {"id": "system_screenshot_no_thumbnail", "label": "No Floating Thumbnail", "desc": "Disable delayed floating thumbnail preview", "selected": True},
                    {"id": "system_screenshot_no_date", "label": "No Date in Filename", "desc": "Cleaner screenshot filenames", "selected": True},
                    {"id": "system_disk_utility_all_devices", "label": "Disk Utility Devices", "desc": "Show all physical disks and partitions in sidebar", "selected": True},
                    {"id": "system_metal_hud", "label": "Apple Metal HUD", "desc": "Enable Metal graphics performance overlay", "selected": False},
                ]
            }
        ]
    },
    {
        "id": "brew",
        "title": "3. Homebrew & Apps",
        "description": "Select Homebrew bundle components to install:",
        "is_tree": False,
        "items": [
            {"id": "brew_cli", "label": "CLI Utilities", "desc": "git, jq, exa, mole, cmake, node, fvm, bun, etc.", "selected": True},
            {"id": "brew_ai", "label": "AI Agent Tools", "desc": "claude-code, antigravity-ide, android-cli, adb", "selected": True},
            {"id": "brew_casks", "label": "Desktop Casks", "desc": "Chrome, VS Code, Slack, Telegram, Rectangle, Stats", "selected": True},
            {"id": "brew_quicklook", "label": "QuickLook Previewers", "desc": "Syntax-Highlight and QLMarkdown for Finder spacebar", "selected": True},
            {"id": "brew_fonts", "label": "Nerd Fonts", "desc": "JetBrains Mono Nerd Font with full developer glyphs", "selected": True},
            {"id": "brew_mas", "label": "Mac App Store", "desc": "LensOCR, SZContext, and Urban VPN Desktop via mas", "selected": True},
        ]
    }
]

# ----------------------------------------------------------------------
# TUI Curses Renderer
# ----------------------------------------------------------------------

class DotfilesTUI:
    def __init__(self, stdscr, tabs, packages_only=False):
        self.stdscr = stdscr
        self.tabs = [t for t in tabs if t["id"] == "packages"] if packages_only else tabs
        self.current_tab_idx = 0
        self.cursor_idx = 0
        self.scroll_offsets = [0] * len(self.tabs)
        self.completed = False
        self.cancelled = False

    def init_colors(self):
        curses.start_color()
        curses.use_default_colors()
        curses.curs_set(0)

        # Color pairs
        curses.init_pair(1, curses.COLOR_CYAN, -1)     # Accent / headers
        curses.init_pair(2, curses.COLOR_GREEN, -1)    # Checked / success
        curses.init_pair(3, curses.COLOR_YELLOW, -1)   # Warnings / counts
        curses.init_pair(4, curses.COLOR_MAGENTA, -1)  # Pointer / highlights
        curses.init_pair(5, curses.COLOR_WHITE, -1)    # Normal text
        curses.init_pair(6, curses.COLOR_BLACK, curses.COLOR_CYAN) # Active tab highlight
        curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_WHITE) # Inverted item cursor

    def current_tab(self):
        return self.tabs[self.current_tab_idx]

    def get_visible_rows(self, tab):
        rows = []
        if tab.get("is_tree"):
            for cat in tab["categories"]:
                rows.append({"type": "category", "data": cat})
                if cat.get("expanded", False):
                    for item in cat["items"]:
                        rows.append({"type": "item", "parent": cat, "data": item})
        else:
            for item in tab["items"]:
                rows.append({"type": "item", "data": item})
        return rows

    def draw(self):
        self.stdscr.erase()
        max_y, max_x = self.stdscr.getmaxyx()

        if max_y < 12 or max_x < 50:
            self.stdscr.addstr(0, 0, "Terminal window too small. Please resize.")
            self.stdscr.refresh()
            return

        # 1. Header Banner
        header = "  Claude Code Dotfiles Installer Wizard"
        self.stdscr.addstr(1, 2, header, curses.color_pair(1) | curses.A_BOLD)

        # 2. Tabs Bar
        tab_bar_y = 3
        col = 2
        for idx, tab in enumerate(self.tabs):
            is_active = (idx == self.current_tab_idx)
            tab_str = f" [ {tab['title']} ] "
            if is_active:
                self.stdscr.addstr(tab_bar_y, col, tab_str, curses.color_pair(6) | curses.A_BOLD)
            else:
                self.stdscr.addstr(tab_bar_y, col, tab_str, curses.color_pair(5) | curses.A_DIM)
            col += len(tab_str) + 1

        # Divider line
        divider = "─" * min(max_x - 4, 80)
        self.stdscr.addstr(tab_bar_y + 1, 2, divider, curses.color_pair(5) | curses.A_DIM)

        # 3. Tab Subtitle & Live Counter
        tab = self.current_tab()
        rows = self.get_visible_rows(tab)

        # Calculate totals
        if tab.get("is_tree"):
            total_items = sum(len(c["items"]) for c in tab["categories"])
            selected_items = sum(sum(1 for i in c["items"] if i.get("selected", False)) for c in tab["categories"])
        else:
            total_items = len(tab["items"])
            selected_items = sum(1 for i in tab["items"] if i.get("selected", False))

        count_str = f"({selected_items}/{total_items} selected)"

        self.stdscr.addstr(5, 2, tab["description"], curses.color_pair(5) | curses.A_BOLD)
        self.stdscr.addstr(5, max(2, len(tab["description"]) + 4), count_str, curses.color_pair(3) | curses.A_BOLD)

        # 4. Scrollable Rows Area
        list_start_y = 7
        available_height = max(1, max_y - list_start_y - 4)

        # Clamp cursor
        if self.cursor_idx >= len(rows):
            self.cursor_idx = max(0, len(rows) - 1)

        offset = self.scroll_offsets[self.current_tab_idx]
        if self.cursor_idx < offset:
            offset = self.cursor_idx
        elif self.cursor_idx >= offset + available_height:
            offset = self.cursor_idx - available_height + 1
        self.scroll_offsets[self.current_tab_idx] = offset

        visible_slice = rows[offset:offset + available_height]

        for i, row in enumerate(visible_slice):
            row_idx = offset + i
            row_y = list_start_y + i
            is_cursor = (row_idx == self.cursor_idx)

            pointer = " ❯ " if is_cursor else "   "
            pointer_color = curses.color_pair(4) | curses.A_BOLD if is_cursor else curses.color_pair(5)

            if row["type"] == "category":
                cat = row["data"]
                is_expanded = cat.get("expanded", False)
                expander = "▼ " if is_expanded else "▶ "
                cat_items = cat["items"]
                sel_count = sum(1 for item in cat_items if item.get("selected", False))

                if sel_count == len(cat_items):
                    marker = "[●]"
                    marker_color = curses.color_pair(2) | curses.A_BOLD
                elif sel_count > 0:
                    marker = "[◑]"
                    marker_color = curses.color_pair(3) | curses.A_BOLD
                else:
                    marker = "[○]"
                    marker_color = curses.color_pair(5) | curses.A_DIM

                label = f"{expander}{cat['label']}".ljust(24)
                count_badge = f"({sel_count}/{len(cat_items)} enabled)"
                hint = " [← to collapse]" if is_expanded else " [→/e to expand]"

                try:
                    self.stdscr.addstr(row_y, 2, pointer, pointer_color)
                    self.stdscr.addstr(row_y, 5, marker, marker_color)
                    self.stdscr.addstr(row_y, 9, f" {label} ", curses.color_pair(1) | curses.A_BOLD)
                    self.stdscr.addstr(row_y, 35, count_badge, curses.color_pair(3))
                    self.stdscr.addstr(row_y, 50, hint, curses.color_pair(5) | curses.A_DIM)
                except curses.error:
                    pass

            else:
                item = row["data"]
                is_checked = item.get("selected", False)
                marker = "[●]" if is_checked else "[○]"
                marker_color = curses.color_pair(2) | curses.A_BOLD if is_checked else curses.color_pair(5) | curses.A_DIM

                is_nested = ("parent" in row)
                indent = "    " if is_nested else ""
                label = f"{indent}{item['label']}".ljust(22)
                desc = item.get("desc", "")

                max_desc_len = max_x - 34
                if len(desc) > max_desc_len and max_desc_len > 3:
                    desc = desc[:max_desc_len - 3] + "..."

                try:
                    self.stdscr.addstr(row_y, 2, pointer, pointer_color)
                    self.stdscr.addstr(row_y, 5 + (2 if is_nested else 0), marker, marker_color)
                    self.stdscr.addstr(row_y, 9 + (2 if is_nested else 0), f" {label} ", curses.color_pair(5) | (curses.A_BOLD if is_cursor else 0))
                    self.stdscr.addstr(row_y, 33 + (2 if is_nested else 0), desc, curses.color_pair(5) | curses.A_DIM)
                except curses.error:
                    pass

        # 5. Scroll indicators if needed
        if offset > 0:
            self.stdscr.addstr(list_start_y - 1, min(max_x - 8, 72), " ▲ more", curses.color_pair(3))
        if offset + available_height < len(rows):
            self.stdscr.addstr(list_start_y + available_height, min(max_x - 8, 72), " ▼ more", curses.color_pair(3))

        # 6. Bottom Keybindings Bar
        footer_y = max_y - 2
        is_last_tab = (self.current_tab_idx == len(self.tabs) - 1)
        next_action = "Enter: Finish & Install" if is_last_tab else "Enter: Next Tab"

        if tab.get("is_tree"):
            keys_help = f" ↑/↓: Move • Space: Toggle • →/←: Expand/Collapse • a: All • {next_action} • q: Cancel"
        else:
            keys_help = f" ↑/↓: Navigate • Space: Toggle • Tab: Switch Tab • a: Toggle All • {next_action} • q: Cancel"

        if len(keys_help) > max_x - 4:
            keys_help = " ↑/↓: Move • Space: Toggle • →/←: Tree • Enter: Next • q: Quit"

        self.stdscr.addstr(footer_y - 1, 2, divider, curses.color_pair(5) | curses.A_DIM)
        self.stdscr.addstr(footer_y, 2, keys_help, curses.color_pair(1))

        self.stdscr.refresh()

    def run(self):
        self.init_colors()

        while True:
            self.draw()
            try:
                key = self.stdscr.getch()
            except KeyboardInterrupt:
                self.cancelled = True
                break

            tab = self.current_tab()
            rows = self.get_visible_rows(tab)
            max_y, _ = self.stdscr.getmaxyx()
            available_height = max(1, max_y - 11)

            # Up navigation
            if key in (curses.KEY_UP, ord('k'), ord('K')):
                if self.cursor_idx > 0:
                    self.cursor_idx -= 1

            # Down navigation
            elif key in (curses.KEY_DOWN, ord('j'), ord('J')):
                if self.cursor_idx < len(rows) - 1:
                    self.cursor_idx += 1

            # Toggle Spacebar
            elif key == ord(' '):
                if self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category":
                        cat = current_row["data"]
                        any_unselected = any(not item.get("selected", False) for item in cat["items"])
                        for item in cat["items"]:
                            item["selected"] = any_unselected
                    else:
                        item = current_row["data"]
                        item["selected"] = not item.get("selected", False)

            # Expand / Collapse toggle ('e' or 'E')
            elif key in (ord('e'), ord('E')):
                if self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category":
                        current_row["data"]["expanded"] = not current_row["data"].get("expanded", False)
                    elif current_row["type"] == "item" and "parent" in current_row:
                        current_row["parent"]["expanded"] = not current_row["parent"].get("expanded", False)

            # Expand category (Right Arrow or 'l')
            elif key in (curses.KEY_RIGHT, ord('l'), ord('L')):
                if tab.get("is_tree") and self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category" and not current_row["data"].get("expanded", False):
                        current_row["data"]["expanded"] = True
                    else:
                        # Otherwise advance tab
                        self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                        self.cursor_idx = 0
                else:
                    self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                    self.cursor_idx = 0

            # Collapse category (Left Arrow or 'h')
            elif key in (curses.KEY_LEFT, ord('h'), ord('H')):
                if tab.get("is_tree") and self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category" and current_row["data"].get("expanded", False):
                        current_row["data"]["expanded"] = False
                    elif current_row["type"] == "item" and "parent" in current_row:
                        current_row["parent"]["expanded"] = False
                    else:
                        self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                        self.cursor_idx = 0
                else:
                    self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                    self.cursor_idx = 0

            # Next Tab (Tab key)
            elif key == ord('\t'):
                self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                self.cursor_idx = 0

            # Previous Tab (Shift+Tab)
            elif key == curses.KEY_BTAB:
                self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                self.cursor_idx = 0

            # Toggle All ('a')
            elif key in (ord('a'), ord('A')):
                if tab.get("is_tree"):
                    all_items = [i for c in tab["categories"] for i in c["items"]]
                    any_unselected = any(not item.get("selected", False) for item in all_items)
                    for item in all_items:
                        item["selected"] = any_unselected
                else:
                    any_unselected = any(not item.get("selected", False) for item in tab["items"])
                    for item in tab["items"]:
                        item["selected"] = any_unselected

            # Enter Key (Advance Tab or Finish)
            elif key in (curses.KEY_ENTER, 10, 13):
                if self.current_tab_idx < len(self.tabs) - 1:
                    self.current_tab_idx += 1
                    self.cursor_idx = 0
                else:
                    self.completed = True
                    break

            # Quit (q, Q, or Esc)
            elif key in (ord('q'), ord('Q'), 27):
                self.cancelled = True
                break

        return self.get_results()

    def get_results(self):
        if self.cancelled:
            return None

        results = {}
        for tab in self.tabs:
            if tab.get("is_tree"):
                cat_dict = {}
                flat_list = []
                for cat in tab["categories"]:
                    selected_items = [item["id"] for item in cat["items"] if item.get("selected", False)]
                    cat_dict[cat["id"]] = selected_items
                    flat_list.extend(selected_items)
                results[tab["id"]] = cat_dict
                results[f"{tab['id']}_flat"] = flat_list
                results[f"{tab['id']}_categories"] = [cat["id"] for cat in tab["categories"] if any(item.get("selected", False) for item in cat["items"])]
            else:
                results[tab["id"]] = [item["id"] for item in tab["items"] if item.get("selected", False)]

        return results

# ----------------------------------------------------------------------
# CLI Entrypoint
# ----------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Claude Code-style Dotfiles TUI Installer")
    parser.add_argument("--packages-only", action="store_true", help="Only show the Packages & Tools tab")
    parser.add_argument("--output", type=str, help="Write chosen JSON output to a file")
    parser.add_argument("--all", action="store_true", help="Return all items selected without showing TUI")
    args = parser.parse_args()

    # Non-interactive bypass
    if args.all or not sys.stdin.isatty():
        results = {}
        for tab in TABS_DATA:
            if args.packages_only and tab["id"] != "packages":
                continue
            if tab.get("is_tree"):
                cat_dict = {}
                flat_list = []
                for cat in tab["categories"]:
                    selected_items = [item["id"] for item in cat["items"] if item.get("selected", False)]
                    cat_dict[cat["id"]] = selected_items
                    flat_list.extend(selected_items)
                results[tab["id"]] = cat_dict
                results[f"{tab['id']}_flat"] = flat_list
                results[f"{tab['id']}_categories"] = [cat["id"] for cat in tab["categories"] if any(item.get("selected", False) for item in cat["items"])]
            else:
                results[tab["id"]] = [item["id"] for item in tab["items"] if item.get("selected", False)]

        if args.output:
            with open(args.output, "w") as f:
                json.dump(results, f)
        else:
            print(json.dumps(results))
        return 0

    # Run curses wrapper
    try:
        results = curses.wrapper(lambda stdscr: DotfilesTUI(stdscr, TABS_DATA, packages_only=args.packages_only).run())
    except Exception as e:
        sys.stderr.write(f"TUI error: {e}\n")
        return 1

    if results is None:
        sys.stderr.write("User cancelled setup.\n")
        return 130

    if args.output:
        with open(args.output, "w") as f:
            json.dump(results, f)
    else:
        print(json.dumps(results))

    return 0

if __name__ == "__main__":
    sys.exit(main())
