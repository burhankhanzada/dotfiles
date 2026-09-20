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
import re

# Resolve dotfiles base directory
DOTFILES_DIR = os.environ.get("DOTFILES") or os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../..")
)

# ----------------------------------------------------------------------
# 1. Packages Metadata & Discovery
# ----------------------------------------------------------------------


PACKAGE_PREFERRED_ORDER = [
    "git",
    "vscode",
    "antigravity-ide",
    "android-tools",
    "android-studio",
    "flutter",
    "python",
    "node",
    "rust",
    "ruby",
    "java",
    "cmake",
    "cocoapods",
    "llvm",
    "warp",
    "xcode",
    "yabai",
    "firebase",
    "parallels",
    "wine",
    "generic",
]


def extract_package_description(pkg_dir, default_label):
    """
    Extracts a human description from package files (README.md, env.zsh, install.sh).
    """
    readme_path = os.path.join(pkg_dir, "README.md")
    if os.path.exists(readme_path):
        with open(readme_path, "r", errors="ignore") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    return line

    for fname in ("env.zsh", "install.sh", "links.sh", "setup.sh"):
        fpath = os.path.join(pkg_dir, fname)
        if os.path.exists(fpath):
            with open(fpath, "r", errors="ignore") as f:
                for line in f:
                    line = line.strip()
                    if line.startswith("#") and not line.startswith("#!"):
                        clean = line.lstrip("# \t").strip()
                        if clean.startswith(("!", "Fallback", "command -v")):
                            continue
                        if clean.lower().startswith("description:"):
                            return clean.split(":", 1)[1].strip()
                        if len(clean) > 5 and not any(
                            clean.startswith(w)
                            for w in ("if ", "for ", "while ", "case ", "[ ")
                        ):
                            return clean
    return f"Configuration and environment for {default_label}"


def discover_packages(dotfiles_dir=DOTFILES_DIR):
    """
    Scans $DOTFILES/packages directory for package components dynamically.
    """
    packages_dir = os.path.join(dotfiles_dir, "packages")
    if not os.path.isdir(packages_dir):
        return []

    subdirs = [
        d
        for d in os.listdir(packages_dir)
        if os.path.isdir(os.path.join(packages_dir, d)) and not d.startswith(".")
    ]

    def sort_key(d):
        return (
            (0, PACKAGE_PREFERRED_ORDER.index(d))
            if d in PACKAGE_PREFERRED_ORDER
            else (1, d.lower())
        )

    subdirs.sort(key=sort_key)

    items = []
    for pkg in subdirs:
        pkg_dir = os.path.join(packages_dir, pkg)
        label = pkg.replace("-", " ").replace("_", " ").title()
        desc = extract_package_description(pkg_dir, label)
        items.append({"id": pkg, "label": label, "desc": desc, "selected": False})
    return items


# ----------------------------------------------------------------------
# 2. macOS Defaults Metadata & Discovery
# ----------------------------------------------------------------------


DEFAULT_UNSELECTED_FUNCTIONS = {"system_metal_hud"}


def discover_macos_defaults(dotfiles_dir=DOTFILES_DIR):
    """
    Scans $DOTFILES/macos/defaults/*.sh files and parses category metadata and function definitions.
    """
    defaults_dir = os.path.join(dotfiles_dir, "macos", "defaults")
    if not os.path.isdir(defaults_dir):
        return []

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

        funcs = re.findall(r"function\s+([a-zA-Z0-9_]+)\s*\(\)\s*\{([^}]+)\}", content)
        items = []
        for func_name, body in funcs:
            clean_name = (
                func_name[len(cat_id) + 1 :]
                if func_name.startswith(f"{cat_id}_")
                else func_name
            )
            label = clean_name.replace("-", " ").replace("_", " ").title()

            echo_m = re.search(
                r"echo(?:\.[a-zA-Z]+)?\s+[\"\']?\s*(.*?)\s*[\"\']?\s*$",
                body,
                re.MULTILINE,
            )
            desc_func = (
                echo_m.group(1).strip("\"'\t ")
                if echo_m
                else f"Configure {label} default setting"
            )

            selected = func_name not in DEFAULT_UNSELECTED_FUNCTIONS
            items.append(
                {
                    "id": func_name,
                    "label": label,
                    "desc": desc_func,
                    "selected": selected,
                }
            )

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


# ----------------------------------------------------------------------
# 3. Homebrew Components Metadata & Discovery
# ----------------------------------------------------------------------


def discover_brew_components(dotfiles_dir=DOTFILES_DIR):
    """
    Parses $DOTFILES/Brewfile sections dynamically and summarizes formulas/casks.
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
            m = re.match(r"^(?:brew|cask|mas)\s+[\"\']([^\"\']+)[\"\']", line)
            if m:
                current_items.append(m.group(1))
        i += 1

    if current_sec and current_items:
        sections.append((current_sec, current_items))

    items = []
    for sec_title, sec_items in sections:
        item_id = "brew_" + re.sub(r"[^a-zA-Z0-9]+", "_", sec_title.lower()).strip("_")
        clean_label = re.sub(r"\s*\([^)]*\)", "", sec_title).strip()
        summary = ", ".join(sec_items[:5])
        if len(sec_items) > 5:
            summary += f", etc. ({len(sec_items)} items)"

        items.append(
            {"id": item_id, "label": clean_label, "desc": summary, "selected": False}
        )

    return items


# ----------------------------------------------------------------------
# 4. Tab Structure Assembly
# ----------------------------------------------------------------------


def build_tabs(dotfiles_dir=DOTFILES_DIR):
    """
    Builds the complete tab hierarchy dynamically from filesystem state.
    """
    return [
        {
            "id": "packages",
            "title": "1. Packages & Tools",
            "description": "Select development toolchains, languages, and IDEs to configure:",
            "is_tree": False,
            "items": discover_packages(dotfiles_dir),
        },
        {
            "id": "macos",
            "title": "2. macOS Defaults",
            "description": "Customize macOS settings (Press → or e to expand/collapse categories):",
            "is_tree": True,
            "categories": discover_macos_defaults(dotfiles_dir),
        },
        {
            "id": "brew",
            "title": "3. Homebrew & Apps",
            "description": "Select Homebrew bundle components to install:",
            "is_tree": False,
            "items": discover_brew_components(dotfiles_dir),
        },
    ]


# Module-level static reference for backward compatibility
TABS_DATA = build_tabs()


def get_tabs(packages_only=False, dotfiles_dir=DOTFILES_DIR):
    """
    Returns a fresh copy of tabs dynamically parsed from current filesystem state.
    """
    tabs = copy.deepcopy(build_tabs(dotfiles_dir))
    if packages_only:
        return [t for t in tabs if t["id"] == "packages"]
    return tabs
