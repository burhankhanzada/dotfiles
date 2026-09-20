"""
CLI entry point and execution orchestration for the Dotfiles Installer Wizard.
"""

import argparse
import curses
import json
import os
import sys

from .config import get_tabs
from .renderer import DotfilesTUI

def extract_results(tabs):
    """
    Extracts selected items from tabs data structure into a result dictionary.
    """
    results = {}
    for tab in tabs:
        if tab.get("is_tree"):
            cat_dict = {}
            flat_list = []
            for cat in tab["categories"]:
                selected_items = [item["id"] for item in cat["items"] if item.get("selected", False)]
                cat_dict[cat["id"]] = selected_items
                flat_list.extend(selected_items)
            results[tab["id"]] = cat_dict
            results[f"{tab['id']}_flat"] = flat_list
            results[f"{tab['id']}_categories"] = [
                cat["id"] for cat in tab["categories"] if any(item.get("selected", False) for item in cat["items"])
            ]
        else:
            results[tab["id"]] = [item["id"] for item in tab["items"] if item.get("selected", False)]
    return results

def main():
    parser = argparse.ArgumentParser(description="Interactive Multi-Tab Dotfiles Installer Wizard")
    parser.add_argument("--packages-only", action="store_true", help="Only show the Packages & Tools tab")
    parser.add_argument("--output", type=str, help="Write chosen JSON output to a file")
    parser.add_argument("--all", action="store_true", help="Return all items selected without showing TUI")
    args = parser.parse_args()

    tabs = get_tabs(packages_only=args.packages_only)

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
