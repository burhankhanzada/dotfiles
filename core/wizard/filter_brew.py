#!/usr/bin/env python3
"""
Brewfile Filter Helper.
Extracts user-selected formulae, casks, and mas applications from a Brewfile,
preserving all required taps and category headers.
"""

import argparse
import os
import re
import sys


def filter_brewfile(brewfile_path, selected_ids, output_path):
    """
    Reads brewfile_path and writes a filtered version to output_path
    containing only the items matching selected_ids, plus required taps.
    """
    if not os.path.isfile(brewfile_path):
        return False

    selected_set = {s.strip().lower() for s in selected_ids if s.strip()}
    if not selected_set:
        # No packages selected
        with open(output_path, "w", encoding="utf-8") as f:
            f.write("# No Homebrew packages selected.\n")
        return False

    with open(brewfile_path, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    taps = []
    matched_sections = []
    current_sec_header = []
    current_sec_matched_lines = []

    for line in lines:
        stripped = line.strip()

        # Capture valid taps (excluding deprecated homebrew/bundle)
        if re.match(r"^tap\s+[\"']", stripped):
            if "homebrew/bundle" not in stripped:
                taps.append(line)
            continue

        # Check for section header
        if (
            stripped.startswith("# ---")
            or (stripped.startswith("#") and "---" in stripped)
        ):
            if current_sec_matched_lines:
                matched_sections.append(
                    (current_sec_header, current_sec_matched_lines)
                )
                current_sec_matched_lines = []
            current_sec_header = [line]
            continue

        if current_sec_header and not stripped.startswith("#"):
            # Header block ended
            pass
        elif current_sec_header and stripped.startswith("#"):
            current_sec_header.append(line)
            continue

        # Check for brew / cask / mas declarations
        m = re.match(r"^(?:brew|cask|mas)\s+[\"']([^\"']+)[\"']", stripped)
        if m:
            item_name = m.group(1).lower()
            base_name = item_name.split("/")[-1]
            if item_name in selected_set or base_name in selected_set:
                current_sec_matched_lines.append(line)
            continue

        # Keep comments associated with matched items
        if stripped.startswith("#") and not current_sec_header:
            continue

    if current_sec_matched_lines:
        matched_sections.append((current_sec_header, current_sec_matched_lines))

    # Assemble output file
    output_lines = [
        "# Filtered Brewfile generated dynamically by Dotfiles Installer\n",
        f"# Total selected components: {len(selected_set)}\n\n",
    ]

    if taps:
        output_lines.append("# ----------------------------------------------------------------------\n")
        output_lines.append("# Taps\n")
        output_lines.append("# ----------------------------------------------------------------------\n")
        output_lines.extend(taps)
        output_lines.append("\n")

    for header, items in matched_sections:
        if header:
            output_lines.extend(header)
        output_lines.extend(items)
        output_lines.append("\n")

    with open(output_path, "w", encoding="utf-8") as f:
        f.writelines(output_lines)

    return True


def main():
    parser = argparse.ArgumentParser(description="Filter Brewfile by selected packages")
    parser.add_argument("--brewfile", required=True, help="Path to source Brewfile")
    parser.add_argument("--output", required=True, help="Path to output filtered Brewfile")
    parser.add_argument("selected", nargs="*", help="List of selected package IDs")
    args = parser.parse_args()

    filter_brewfile(args.brewfile, args.selected, args.output)
    return 0


if __name__ == "__main__":
    sys.exit(main())
