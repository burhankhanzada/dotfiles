#!/usr/bin/env python3
"""
Claude Code-style Interactive Multi-Tab TUI Wizard for Dotfiles Installer.
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
        "description": "Select macOS system preference categories to apply:",
        "items": [
            {"id": "ui", "label": "UI & Dock", "desc": "Dark mode, auto-hide dock, fast animations, menu bar", "selected": True},
            {"id": "finder", "label": "Finder & Desktop", "desc": "Show extensions, path bar, hide desktop clutter", "selected": True},
            {"id": "hardware", "label": "Hardware & Trackpad", "desc": "Fast keyboard repeat, tap-to-click, mute startup chime", "selected": True},
            {"id": "system", "label": "System & Screenshots", "desc": "Screenshot dir, disable crash dialogs, Disk Utility", "selected": True},
        ]
    },
    {
        "id": "brew",
        "title": "3. Homebrew & Apps",
        "description": "Select Homebrew bundle components to install:",
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
        divider = "─" * min(max_x - 4, 76)
        self.stdscr.addstr(tab_bar_y + 1, 2, divider, curses.color_pair(5) | curses.A_DIM)

        # 3. Tab Subtitle & Live Selected Counter
        tab = self.current_tab()
        items = tab["items"]
        selected_count = sum(1 for item in items if item.get("selected", False))
        count_str = f"({selected_count}/{len(items)} selected)"

        self.stdscr.addstr(5, 2, tab["description"], curses.color_pair(5) | curses.A_BOLD)
        self.stdscr.addstr(5, max(2, len(tab["description"]) + 4), count_str, curses.color_pair(3) | curses.A_BOLD)

        # 4. Item List (Scrollable Area)
        list_start_y = 7
        available_height = max_y - list_start_y - 4
        if available_height < 1:
            available_height = 1

        offset = self.scroll_offsets[self.current_tab_idx]
        visible_items = items[offset:offset + available_height]

        for i, item in enumerate(visible_items):
            item_idx = offset + i
            row_y = list_start_y + i
            is_cursor = (item_idx == self.cursor_idx)
            is_checked = item.get("selected", False)

            # Cursor symbol
            pointer = " ❯ " if is_cursor else "   "
            pointer_color = curses.color_pair(4) | curses.A_BOLD if is_cursor else curses.color_pair(5)

            # Checkbox marker
            marker = "[●]" if is_checked else "[○]"
            marker_color = curses.color_pair(2) | curses.A_BOLD if is_checked else curses.color_pair(5) | curses.A_DIM

            # Label & Description formatting
            label = item["label"].ljust(18)
            desc = item.get("desc", "")

            # Truncate description if exceeds terminal width
            max_desc_len = max_x - 30
            if len(desc) > max_desc_len and max_desc_len > 3:
                desc = desc[:max_desc_len - 3] + "..."

            try:
                self.stdscr.addstr(row_y, 2, pointer, pointer_color)
                self.stdscr.addstr(row_y, 5, marker, marker_color)
                self.stdscr.addstr(row_y, 9, f" {label} ", curses.color_pair(5) | (curses.A_BOLD if is_cursor else 0))
                self.stdscr.addstr(row_y, 29, desc, curses.color_pair(5) | curses.A_DIM)
            except curses.error:
                pass

        # 5. Scroll indicators if needed
        if offset > 0:
            self.stdscr.addstr(list_start_y - 1, min(max_x - 6, 70), " ▲ more", curses.color_pair(3))
        if offset + available_height < len(items):
            self.stdscr.addstr(list_start_y + available_height, min(max_x - 6, 70), " ▼ more", curses.color_pair(3))

        # 6. Bottom Keybindings Bar
        footer_y = max_y - 2
        is_last_tab = (self.current_tab_idx == len(self.tabs) - 1)
        next_action = "Enter: Finish & Install" if is_last_tab else "Enter: Next Tab"

        keys_help = f" ↑/↓: Navigate • Space: Toggle • Tab: Switch Tab • a: Toggle All • {next_action} • q: Cancel"
        if len(keys_help) > max_x - 4:
            keys_help = " ↑/↓: Move • Space: Toggle • Tab: Next Tab • Enter: Done • q: Quit"

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
            items = tab["items"]
            max_y, _ = self.stdscr.getmaxyx()
            available_height = max(1, max_y - 11)

            # Up navigation
            if key in (curses.KEY_UP, ord('k'), ord('K')):
                if self.cursor_idx > 0:
                    self.cursor_idx -= 1
                    if self.cursor_idx < self.scroll_offsets[self.current_tab_idx]:
                        self.scroll_offsets[self.current_tab_idx] = self.cursor_idx

            # Down navigation
            elif key in (curses.KEY_DOWN, ord('j'), ord('J')):
                if self.cursor_idx < len(items) - 1:
                    self.cursor_idx += 1
                    if self.cursor_idx >= self.scroll_offsets[self.current_tab_idx] + available_height:
                        self.scroll_offsets[self.current_tab_idx] = self.cursor_idx - available_height + 1

            # Toggle Spacebar
            elif key == ord(' '):
                items[self.cursor_idx]["selected"] = not items[self.cursor_idx].get("selected", False)

            # Toggle All ('a')
            elif key in (ord('a'), ord('A')):
                any_unselected = any(not item.get("selected", False) for item in items)
                for item in items:
                    item["selected"] = any_unselected

            # Next Tab (Tab or Right Arrow or 'l')
            elif key in (ord('\t'), curses.KEY_RIGHT, ord('l'), ord('L')):
                self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                self.cursor_idx = 0

            # Previous Tab (Shift+Tab or Left Arrow or 'h')
            elif key in (curses.KEY_BTAB, curses.KEY_LEFT, ord('h'), ord('H')):
                self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                self.cursor_idx = 0

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
            selected_ids = [item["id"] for item in tab["items"] if item.get("selected", False)]
            results[tab["id"]] = selected_ids
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
