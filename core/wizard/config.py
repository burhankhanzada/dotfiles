"""
Dynamic Configuration & Discovery Engine for the Dotfiles TUI Installer Wizard.

Discovers packages, macOS defaults functions, and Homebrew bundle components
directly from the filesystem at runtime:
  - packages/*            -> Discovered as selectable tools and toolchains
  - macos/defaults/*.sh   -> Discovered as categories and specific settings
  - Brewfile              -> Discovered as bundle sections and formula groups
"""

import copy
import glob
import os
import plistlib
import re
import subprocess
import sys

# Resolve dotfiles base directory
DOTFILES_DIR = os.environ.get("DOTFILES") or os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../..")
)

# --------------------------------------------------
# 1. Packages Metadata & Discovery
# --------------------------------------------------


# Overrides where dotfiles package directory name differs from Brewfile package name,
# or where a single package maps to multiple Brewfile formulas/casks.
PACKAGE_BREW_OVERRIDES = {
    "git": ["git", "git-lfs"],
    "vscode": ["visual-studio-code"],
    "android-tools": ["android-platform-tools", "android-commandlinetools"],
    "flutter": ["fvm"],
    "python": ["pyenv", "jupyterlab", "python-tk"],
    "ruby": ["ruby-install", "chruby"],
    "yabai": ["yabai", "skhd"],
    "parallels": ["parallels", "parallels-toolbox"],
}


def get_brewfile_package_names(dotfiles_dir=DOTFILES_DIR):
    """
    Extracts all formula, cask, and mas package names defined in Brewfile.
    """
    brewfile = os.path.join(dotfiles_dir, "Brewfile")
    if not os.path.isfile(brewfile):
        return set()
    with open(brewfile, "r", errors="ignore") as f:
        return set(
            re.findall(r"^(?:brew|cask|mas)\s+[\"']([^\"']+)[\"']", f.read(), re.MULTILINE)
        )


def get_package_brew_mappings(dotfiles_dir=DOTFILES_DIR):
    """
    Dynamically maps dotfiles package names to Brewfile packages.
    Uses explicit overrides when specified, and auto-links identical matching names.
    """
    brew_names = get_brewfile_package_names(dotfiles_dir)
    packages_dir = os.path.join(dotfiles_dir, "packages")
    mappings = dict(PACKAGE_BREW_OVERRIDES)

    if os.path.isdir(packages_dir):
        for d in os.listdir(packages_dir):
            if d not in mappings and d in brew_names:
                mappings[d] = [d]

    return mappings


def discover_packages(dotfiles_dir=DOTFILES_DIR):
    """
    Scans $DOTFILES/packages directory for package components dynamically.
    """
    packages_dir = os.path.join(dotfiles_dir, "packages")
    if not os.path.isdir(packages_dir):
        return []

    subdirs = sorted(
        [
            d
            for d in os.listdir(packages_dir)
            if os.path.isdir(os.path.join(packages_dir, d)) and not d.startswith(".")
        ],
        key=lambda d: d.lower(),
    )

    mappings = get_package_brew_mappings(dotfiles_dir)
    items = []
    for pkg in subdirs:
        label = pkg.replace("-", " ").replace("_", " ").title()
        brew_pkgs = mappings.get(pkg, [])
        items.append(
            {
                "id": pkg,
                "label": label,
                "desc": "",
                "dotfiles_pkg": pkg,
                "brew_pkgs": brew_pkgs,
                "kind": "package",
                "selected": False,
            }
        )
    return items


# --------------------------------------------------
# 2. macOS Defaults Metadata & Discovery
# --------------------------------------------------


def get_macos_system_states():
    """
    Queries current macOS system defaults directly from preference plists.
    Returns a dict mapping function_name -> bool (True if enabled on machine, False otherwise).
    Zero external dependencies, completes in ~0.1s.
    """
    if sys.platform != "darwin":
        return {}

    domains = [
        "com.apple.screencapture",
        "com.apple.DiskUtility",
        "NSGlobalDomain",
        "com.apple.finder",
        "com.apple.LaunchServices",
        "com.apple.desktopservices",
        "com.apple.AppleMultitouchTrackpad",
        "com.google.Chrome",
        "com.apple.Accessibility",
        "com.apple.dock",
        "com.apple.controlcenter",
        "com.apple.Spotlight",
    ]

    domain_data = {}
    for d in domains:
        try:
            out = subprocess.check_output(
                ["defaults", "export", d, "-"], stderr=subprocess.DEVNULL
            )
            domain_data[d] = plistlib.loads(out)
        except Exception:
            domain_data[d] = {}

    g = domain_data.get("NSGlobalDomain", {})
    sc = domain_data.get("com.apple.screencapture", {})
    du = domain_data.get("com.apple.DiskUtility", {})
    f = domain_data.get("com.apple.finder", {})
    ls = domain_data.get("com.apple.LaunchServices", {})
    ds = domain_data.get("com.apple.desktopservices", {})
    tp = domain_data.get("com.apple.AppleMultitouchTrackpad", {})
    gc = domain_data.get("com.google.Chrome", {})
    ac = domain_data.get("com.apple.Accessibility", {})
    dk = domain_data.get("com.apple.dock", {})
    cc = domain_data.get("com.apple.controlcenter", {})
    sp = domain_data.get("com.apple.Spotlight", {})

    checkers = {
        # System
        "system_screenshot_dir": lambda: sc.get("location") == os.path.expanduser("~/Pictures/Screenshots"),
        "system_screenshot_no_shadow": lambda: bool(sc.get("disable-shadow")),
        "system_screenshot_jpg": lambda: str(sc.get("type", "")).lower() == "jpg",
        "system_screenshot_no_thumbnail": lambda: sc.get("show-thumbnail") is False,
        "system_screenshot_no_date": lambda: sc.get("include-date") is False,
        "system_disk_utility_all_devices": lambda: bool(du.get("SidebarShowAllDevices")),
        "system_metal_hud": lambda: bool(g.get("MetalForceHudEnabled")),

        # Finder
        "finder_clean_desktop": lambda: f.get("CreateDesktop") is False,
        "finder_show_extensions": lambda: bool(g.get("AppleShowAllExtensions")),
        "finder_show_pathbar": lambda: bool(f.get("ShowPathbar")),
        "finder_folders_on_top": lambda: bool(f.get("_FXSortFoldersFirst")),
        "finder_search_current_folder": lambda: f.get("FXDefaultSearchScope") == "SCcf",
        "finder_show_hidden": lambda: bool(f.get("AppleShowAllFiles")),
        "finder_disable_trash_warning": lambda: f.get("WarnOnEmptyTrash") is False,
        "finder_disable_extension_warning": lambda: f.get("FXEnableExtensionChangeWarning") is False,
        "finder_disable_quarantine": lambda: ls.get("LSQuarantine") is False,
        "finder_no_ds_store_usb_network": lambda: bool(ds.get("DSDontWriteNetworkStores")),
        "finder_expand_save_panels": lambda: bool(g.get("NSNavPanelExpandedStateForSaveMode")),
        "finder_sidebar_clean": lambda: f.get("ShowRecentTags") is False,

        # Hardware
        "hardware_fast_key_repeat": lambda: int(g.get("KeyRepeat", 10)) <= 3,
        "hardware_disable_press_hold": lambda: g.get("ApplePressAndHoldEnabled") is False,
        "hardware_disable_autocap": lambda: g.get("NSAutomaticCapitalizationEnabled") is False,
        "hardware_tap_to_click": lambda: bool(tp.get("Clicking")),
        "hardware_three_finger_drag": lambda: bool(tp.get("TrackpadThreeFingerDrag")),
        "hardware_disable_chrome_swipe": lambda: gc.get("AppleEnableSwipeNavigateWithScrolls") is False,
        "hardware_mute_startup_chime": lambda: False,
        "hardware_display_sleep": lambda: True,

        # UI
        "ui_dark_mode": lambda: g.get("AppleInterfaceStyle") == "Dark",
        "ui_reduce_motion": lambda: bool(ac.get("ReduceMotionEnabled")),
        "ui_dock_left": lambda: dk.get("orientation") == "left",
        "ui_dock_compact": lambda: int(dk.get("tilesize", 0)) == 35,
        "ui_dock_active_only": lambda: bool(dk.get("static-only")),
        "ui_dock_minimize_app": lambda: bool(dk.get("minimize-to-application")),
        "ui_dock_dim_hidden": lambda: bool(dk.get("showhidden")),
        "ui_spaces_fixed": lambda: dk.get("mru-spaces") is False,
        "ui_launchpad_grid": lambda: int(dk.get("springboard-rows", 0)) == 6,
        "ui_battery_percent": lambda: bool(cc.get("BatteryShowPercentage")),
        "ui_hide_spotlight": lambda: bool(sp.get("MenuItemHidden")),
    }

    states = {}
    for func_id, check_fn in checkers.items():
        try:
            states[func_id] = bool(check_fn())
        except Exception:
            states[func_id] = False
    return states


def discover_macos_defaults(dotfiles_dir=DOTFILES_DIR):
    """
    Scans $DOTFILES/macos/defaults/*.sh files and parses category metadata and function definitions.
    Initializes each item with its live macOS system state (True/False).
    """
    defaults_dir = os.path.join(dotfiles_dir, "macos", "defaults")
    if not os.path.isdir(defaults_dir):
        return []

    system_states = get_macos_system_states()
    categories = []
    for fpath in sorted(glob.glob(os.path.join(defaults_dir, "*.sh"))):
        cat_id = os.path.splitext(os.path.basename(fpath))[0]
        title = cat_id.replace("-", " ").replace("_", " ").title()
        desc = f"{title} settings and defaults"

        with open(fpath, "r", errors="ignore") as f:
            content = f.read()

        for line in content.splitlines()[:5]:
            line = line.strip()
            if (
                line.startswith("#")
                and not line.startswith("#!")
                and "Fallback" not in line
                and "command -v" not in line
            ):
                clean = line.lstrip("# \t").strip()
                if len(clean) > 3:
                    desc = clean
                    break

        funcs = re.findall(r"function\s+([a-zA-Z0-9_]+)\s*\(\)", content)
        items = []
        for func_name in funcs:
            if not func_name.startswith(f"{cat_id}_"):
                continue
            clean_name = func_name[len(cat_id) + 1 :]
            label = clean_name.replace("-", " ").replace("_", " ").title()
            is_active = system_states.get(func_name, False)

            items.append(
                {
                    "id": func_name,
                    "label": label,
                    "desc": "",
                    "selected": is_active,
                    "initial_state": is_active,
                }
            )

        items.sort(key=lambda x: x["label"].lower())

        categories.append(
            {
                "id": cat_id,
                "label": title,
                "desc": desc,
                "expanded": False,
                "items": items,
            }
        )

    return categories


# --------------------------------------------------
# 3. Homebrew Components Metadata & Discovery
# --------------------------------------------------


def discover_brew_components(dotfiles_dir=DOTFILES_DIR):
    """
    Parses $DOTFILES/Brewfile sections dynamically into category trees
    with individual formulas, casks, and mas applications.
    """
    brewfile = os.path.join(dotfiles_dir, "Brewfile")
    if not os.path.isfile(brewfile):
        return []

    with open(brewfile, "r", errors="ignore") as fh:
        lines = fh.readlines()

    sections = []
    current_sec = None
    current_items = []
    i = 0

    while i < len(lines):
        line = lines[i].strip()
        if (
            line.startswith("# ---")
            and i + 2 < len(lines)
            and lines[i + 2].strip().startswith("# ---")
        ):
            if current_sec and current_items:
                sections.append((current_sec, current_items))
            current_sec = lines[i + 1].strip().lstrip("# ").strip()
            current_items = []
            i += 3
            continue
        elif current_sec:
            m = re.match(
                r"^(brew|cask|mas)\s+[\"']([^\"']+)[\"'](?:\s*,\s*id:\s*(\d+))?", line
            )
            if m:
                pkg_type = m.group(1)
                pkg_name = m.group(2)
                mas_id = m.group(3)
                current_items.append((pkg_type, pkg_name, mas_id))
        i += 1

    if current_sec and current_items:
        sections.append((current_sec, current_items))

    mappings = get_package_brew_mappings(dotfiles_dir)
    mapped_brew_pkgs = {
        bp for brew_list in mappings.values() for bp in brew_list
    }

    flat_items = []
    for sec_title, sec_items in sections:
        if sec_title.lower() == "taps":
            # Taps are managed automatically when generating filtered Brewfiles
            continue

        clean_sec = re.sub(r"\s*\([^)]*\)", "", sec_title).strip()
        for pkg_type, pkg_name, mas_id in sec_items:
            # Skip brew packages that are already unified with a dotfiles package
            if pkg_name in mapped_brew_pkgs:
                continue

            clean_name = pkg_name.split("/")[-1].replace("-", " ").replace("_", " ").title()
            flat_items.append(
                {
                    "id": pkg_name,
                    "label": clean_name,
                    "desc": "",
                    "brew_pkgs": [pkg_name],
                    "kind": "brew",
                    "selected": False,
                }
            )

    return flat_items


# --------------------------------------------------
# 4. Tab Structure Assembly
# --------------------------------------------------


def build_tabs(dotfiles_dir=DOTFILES_DIR):
    """
    Builds the complete tab hierarchy dynamically from filesystem state.
    Combines packages and brew components into a single unified tab.
    """
    all_packages_and_apps = (
        discover_packages(dotfiles_dir) + discover_brew_components(dotfiles_dir)
    )
    all_packages_and_apps.sort(key=lambda x: x["label"].lower())

    return [
        {
            "id": "packages",
            "title": "1. Packages & Apps",
            "description": "Select development packages, toolchains, and Homebrew apps to install:",
            "is_tree": False,
            "items": all_packages_and_apps,
        },
        {
            "id": "macos",
            "title": "2. macOS Defaults",
            "description": "Customize macOS settings (Press → or e to expand/collapse categories):",
            "is_tree": True,
            "categories": discover_macos_defaults(dotfiles_dir),
        },
    ]





def get_tabs(packages_only=False, dotfiles_dir=DOTFILES_DIR):
    """
    Returns a fresh copy of tabs dynamically parsed from current filesystem state.
    """
    tabs = copy.deepcopy(build_tabs(dotfiles_dir))
    if packages_only:
        pkg_tab = [t for t in tabs if t["id"] == "packages"][0]
        pkg_tab["items"] = [
            it for it in pkg_tab["items"] if it.get("kind") == "package"
        ]
        pkg_tab["title"] = "1. Packages & Tools"
        return [pkg_tab]
    return tabs
