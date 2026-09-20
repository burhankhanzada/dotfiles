"""
ASCII art banner for the Dotfiles TUI Installer.
"""

import curses

BANNER_LINES = [
    "    ____        __  _____ __           ",
    "   / __ \\____  / /_/ __(_) /__  _____  ",
    "  / / / / __ \\/ __/ /_/ / / _ \\/ ___/  ",
    " / /_/ / /_/ / /_/ __/ / /  __(__  )   ",
    "/_____/\\____/\\__/_/ /_/_/\\___/____/    ",
    " Burhan Khanzada - Personal Dotfiles  ",
]


def draw_banner(stdscr, max_y, max_x):
    """
    Renders the banner adaptively based on terminal height.
    Returns the next available y-coordinate for the tabs bar.
    """
    if max_y >= 22 and max_x >= 50:
        for idx, line in enumerate(BANNER_LINES):
            try:
                # Top 5 lines in bold cyan, subtitle in bold blue
                stdscr.addstr(1 + idx, 2, line, curses.color_pair(1) | curses.A_BOLD)
            except curses.error:
                pass
        return 8
    else:
        # Compact header for smaller terminal windows
        try:
            stdscr.addstr(
                1,
                2,
                " Burhan Khanzada - Personal Dotfiles",
                curses.color_pair(1) | curses.A_BOLD,
            )
        except curses.error:
            pass
        return 3
