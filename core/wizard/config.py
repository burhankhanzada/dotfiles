"""
Configuration data and tab definitions for the Dotfiles TUI Installer Wizard.
"""

import copy

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

def get_tabs(packages_only=False):
    """
    Returns a fresh deep copy of the tabs configuration.
    """
    tabs = copy.deepcopy(TABS_DATA)
    if packages_only:
        return [t for t in tabs if t["id"] == "packages"]
    return tabs
