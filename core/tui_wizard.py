#!/usr/bin/env python3
"""
Interactive Multi-Tab TUI Wizard for Dotfiles Installer.
Zero external dependencies (uses Python standard library curses).
"""

import os
import sys

# Ensure core directory is on module lookup path
CORE_DIR = os.path.dirname(os.path.abspath(__file__))
if CORE_DIR not in sys.path:
    sys.path.insert(0, CORE_DIR)

from wizard.app import main

if __name__ == "__main__":
    sys.exit(main())
