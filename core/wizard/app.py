"""
CLI entry point and execution orchestration for the Dotfiles Installer Wizard.
"""

import argparse
import curses
import json
import sys

from .config import get_tabs
from .renderer import DotfilesTUI


def extract_results(tabs):
    """
    Extracts selected items from tabs data structure into a result dictionary.
    For macOS defaults, captures both enabled settings (=true) and settings to disable (=false)
    when a previously enabled setting is unselected.
    """
    results = {}
    for tab in tabs:
        if tab.get("is_tree"):
            cat_actions = {}
            enabled_dict = {}
            disabled_dict = {}
            active_cats = []
            flat_list = []

            for cat in tab["categories"]:
                actions = []
                enabled_items = []
                disabled_items = []

                for item in cat["items"]:
                    item_id = item["id"]
                    is_selected = item.get("selected", False)
                    was_initial = item.get("initial_state", False)

                    if is_selected:
                        actions.append(f"{item_id}=true")
                        enabled_items.append(item_id)
                        flat_list.append(item_id)
                    elif was_initial:
                        actions.append(f"{item_id}=false")
                        disabled_items.append(item_id)

                cat_actions[cat["id"]] = actions
                enabled_dict[cat["id"]] = enabled_items
                disabled_dict[cat["id"]] = disabled_items

                if actions:
                    active_cats.append(cat["id"])

            results[tab["id"]] = cat_actions
            results[f"{tab['id']}_enabled"] = enabled_dict
            results[f"{tab['id']}_disabled"] = disabled_dict
            results[f"{tab['id']}_flat"] = flat_list
            results[f"{tab['id']}_categories"] = active_cats
        else:
            selected_items = [
                item for item in tab["items"] if item.get("selected", False)
            ]
            has_kinds = any("kind" in item for item in tab["items"])
            if has_kinds:
                pkgs = []
                brew = []
                for it in selected_items:
                    if "dotfiles_pkg" in it:
                        pkgs.append(it["dotfiles_pkg"])
                    elif it.get("kind") == "package":
                        pkgs.append(it["id"])

                    if "brew_pkgs" in it:
                        brew.extend(it["brew_pkgs"])
                    elif it.get("kind") == "brew":
                        brew.append(it["id"])

                results["packages"] = pkgs
                results["brew"] = brew
                results["packages_and_apps"] = [it["label"] for it in selected_items]
            else:
                results[tab["id"]] = [it["id"] for it in selected_items]
    return results


def main():
    parser = argparse.ArgumentParser(
        description="Interactive Multi-Tab Dotfiles Installer Wizard"
    )
    parser.add_argument(
        "--packages-only",
        action="store_true",
        help="Only show the Packages & Tools tab",
    )
    parser.add_argument("--output", type=str, help="Write chosen JSON output to a file")
    parser.add_argument(
        "--all",
        action="store_true",
        help="Return all items selected without showing TUI",
    )
    args = parser.parse_args()

    tabs = get_tabs(packages_only=args.packages_only)

    if args.all:
        for tab in tabs:
            if tab.get("is_tree"):
                for cat in tab["categories"]:
                    for item in cat["items"]:
                        item["selected"] = True
            else:
                for item in tab["items"]:
                    item["selected"] = True

    # Non-interactive bypass
    if args.all or not sys.stdin.isatty():
        results = extract_results(tabs)
        if args.output:
            with open(args.output, "w") as f:
                json.dump(results, f)
        else:
            print(json.dumps(results))
        return 0

    # Run curses wrapper
    try:
        results = curses.wrapper(lambda stdscr: DotfilesTUI(stdscr, tabs).run())
    except Exception as e:  # noqa: BLE001
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
