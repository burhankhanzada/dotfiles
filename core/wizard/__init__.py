"""
Dotfiles TUI Wizard Package.
"""

from .config import TABS_DATA, get_tabs
from .renderer import DotfilesTUI
from .banner import draw_banner, BANNER_LINES
from .app import main, extract_results

__all__ = [
    "TABS_DATA",
    "get_tabs",
    "DotfilesTUI",
    "draw_banner",
    "BANNER_LINES",
    "main",
    "extract_results",
]
