"""
Dotfiles TUI Wizard Package.
"""

from .app import extract_results, main
from .banner import BANNER_LINES, draw_banner
from .config import TABS_DATA, get_tabs
from .renderer import DotfilesTUI

__all__ = [
    "BANNER_LINES",
    "TABS_DATA",
    "DotfilesTUI",
    "draw_banner",
    "extract_results",
    "get_tabs",
    "main",
]
