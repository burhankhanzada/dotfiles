"""
Curses-based TUI Renderer and Event Loop for the Dotfiles Installer Wizard.
"""

import curses

from .banner import draw_banner


class DotfilesTUI:
    """
    Interactive Multi-Tab Terminal User Interface for dotfiles setup.
    """

    def __init__(self, stdscr, tabs):
        self.stdscr = stdscr
        self.tabs = tabs
        self.current_tab_idx = 0
        self.cursor_idx = 0
        self.scroll_offsets = [0] * len(self.tabs)
        self.completed = False
        self.cancelled = False

    def init_colors(self):
        curses.start_color()
        curses.use_default_colors()
        curses.curs_set(0)

        # Color pairs
        curses.init_pair(1, curses.COLOR_CYAN, -1)  # Accent / headers
        curses.init_pair(2, curses.COLOR_GREEN, -1)  # Checked / success
        curses.init_pair(3, curses.COLOR_YELLOW, -1)  # Warnings / counts / badges
        curses.init_pair(4, curses.COLOR_MAGENTA, -1)  # Active pointer
        curses.init_pair(5, curses.COLOR_WHITE, -1)  # Normal text
        curses.init_pair(
            6, curses.COLOR_BLACK, curses.COLOR_CYAN
        )  # Active tab highlight
        curses.init_pair(
            7, curses.COLOR_BLACK, curses.COLOR_WHITE
        )  # Inverted cursor highlight

    def safe_addstr(self, y, x, s, attr=0):
        """
        Safely writes a string to stdscr with boundaries checking to prevent curses errors.
        """
        max_y, max_x = self.stdscr.getmaxyx()
        if y < 0 or y >= max_y or x < 0 or x >= max_x:
            return
        if x + len(s) > max_x:
            s = s[: max_x - x]
        if not s:
            return
        try:
            self.stdscr.addstr(y, x, s, attr)
        except curses.error:
            pass

    def current_tab(self):
        return self.tabs[self.current_tab_idx]

    def get_visible_rows(self, tab):
        rows = []
        if tab.get("is_tree"):
            for cat in tab["categories"]:
                rows.append({"type": "category", "data": cat})
                if cat.get("expanded", False):
                    for item in cat["items"]:
                        rows.append({"type": "item", "parent": cat, "data": item})
        else:
            for item in tab["items"]:
                rows.append({"type": "item", "data": item})
        return rows

    def draw(self):
        self.stdscr.erase()
        max_y, max_x = self.stdscr.getmaxyx()

        if max_y < 12 or max_x < 50:
            self.safe_addstr(0, 0, "Terminal window too small. Please resize.")
            self.stdscr.refresh()
            return

        # 1. Header Banner (renders ASCII art banner or compact title based on terminal height)
        tab_bar_y = draw_banner(self.stdscr, max_y, max_x)

        # 2. Tabs Bar
        col = 2
        for idx, tab in enumerate(self.tabs):
            is_active = idx == self.current_tab_idx
            tab_str = f" [ {tab['title']} ] "
            if is_active:
                self.safe_addstr(
                    tab_bar_y, col, tab_str, curses.color_pair(6) | curses.A_BOLD
                )
            else:
                self.safe_addstr(
                    tab_bar_y, col, tab_str, curses.color_pair(5) | curses.A_DIM
                )
            col += len(tab_str) + 1

        # Divider line
        divider = "─" * min(max_x - 4, 80)
        self.safe_addstr(tab_bar_y + 1, 2, divider, curses.color_pair(5) | curses.A_DIM)

        # 3. Tab Subtitle & Live Counter
        tab = self.current_tab()
        rows = self.get_visible_rows(tab)

        if tab.get("is_tree"):
            total_items = sum(len(c["items"]) for c in tab["categories"])
            selected_items = sum(
                sum(1 for i in c["items"] if i.get("selected", False))
                for c in tab["categories"]
            )
        else:
            total_items = len(tab["items"])
            selected_items = sum(1 for i in tab["items"] if i.get("selected", False))

        count_str = f"({selected_items}/{total_items} selected)"
        subtitle_y = tab_bar_y + 2
        self.safe_addstr(
            subtitle_y, 2, tab["description"], curses.color_pair(5) | curses.A_BOLD
        )
        self.safe_addstr(
            subtitle_y,
            max(2, len(tab["description"]) + 4),
            count_str,
            curses.color_pair(3) | curses.A_BOLD,
        )

        # 4. Scrollable Rows Area
        list_start_y = subtitle_y + 2
        available_height = max(1, max_y - list_start_y - 4)

        if self.cursor_idx >= len(rows):
            self.cursor_idx = max(0, len(rows) - 1)

        offset = self.scroll_offsets[self.current_tab_idx]
        if self.cursor_idx < offset:
            offset = self.cursor_idx
        elif self.cursor_idx >= offset + available_height:
            offset = self.cursor_idx - available_height + 1
        self.scroll_offsets[self.current_tab_idx] = offset

        visible_slice = rows[offset : offset + available_height]

        for i, row in enumerate(visible_slice):
            row_idx = offset + i
            row_y = list_start_y + i
            is_cursor = row_idx == self.cursor_idx

            pointer = " ❯ " if is_cursor else "   "
            pointer_color = (
                curses.color_pair(4) | curses.A_BOLD
                if is_cursor
                else curses.color_pair(5)
            )

            if row["type"] == "category":
                cat = row["data"]
                is_expanded = cat.get("expanded", False)
                expander = "▼ " if is_expanded else "▶ "
                cat_items = cat["items"]
                sel_count = sum(1 for item in cat_items if item.get("selected", False))

                if sel_count == len(cat_items):
                    marker = "[●]"
                    marker_color = curses.color_pair(2) | curses.A_BOLD
                elif sel_count > 0:
                    marker = "[◑]"
                    marker_color = curses.color_pair(3) | curses.A_BOLD
                else:
                    marker = "[○]"
                    marker_color = curses.color_pair(5) | curses.A_DIM

                label = f"{expander}{cat['label']}".ljust(24)
                count_badge = f"({sel_count}/{len(cat_items)} enabled)"
                hint = " [← to collapse]" if is_expanded else " [→/e to expand]"

                self.safe_addstr(row_y, 2, pointer, pointer_color)
                self.safe_addstr(row_y, 5, marker, marker_color)
                self.safe_addstr(
                    row_y, 9, f" {label} ", curses.color_pair(1) | curses.A_BOLD
                )
                self.safe_addstr(row_y, 35, count_badge, curses.color_pair(3))
                self.safe_addstr(row_y, 50, hint, curses.color_pair(5) | curses.A_DIM)

            else:
                item = row["data"]
                is_checked = item.get("selected", False)
                marker = "[●]" if is_checked else "[○]"
                marker_color = (
                    curses.color_pair(2) | curses.A_BOLD
                    if is_checked
                    else curses.color_pair(5) | curses.A_DIM
                )

                is_nested = "parent" in row
                indent = "    " if is_nested else ""
                label = f"{indent}{item['label']}".ljust(22)
                desc = item.get("desc", "")

                max_desc_len = max_x - 34
                if len(desc) > max_desc_len > 3:
                    desc = desc[: max_desc_len - 3] + "..."

                self.safe_addstr(row_y, 2, pointer, pointer_color)
                self.safe_addstr(
                    row_y, 5 + (2 if is_nested else 0), marker, marker_color
                )
                self.safe_addstr(
                    row_y,
                    9 + (2 if is_nested else 0),
                    f" {label} ",
                    curses.color_pair(5) | (curses.A_BOLD if is_cursor else 0),
                )
                if desc:
                    self.safe_addstr(
                        row_y,
                        33 + (2 if is_nested else 0),
                        desc,
                        curses.color_pair(5) | curses.A_DIM,
                    )

        # 5. Scroll indicators
        if offset > 0:
            self.safe_addstr(
                list_start_y - 1, min(max_x - 8, 72), " ▲ more", curses.color_pair(3)
            )
        if offset + available_height < len(rows):
            self.safe_addstr(
                list_start_y + available_height,
                min(max_x - 8, 72),
                " ▼ more",
                curses.color_pair(3),
            )

        # 6. Bottom Keybindings Bar
        footer_y = max_y - 2
        is_last_tab = self.current_tab_idx == len(self.tabs) - 1
        next_action = "Enter: Finish & Install" if is_last_tab else "Enter: Next Tab"

        if tab.get("is_tree"):
            keys_help = f" ↑/↓: Move • Space: Toggle • →/←: Expand/Collapse • a: All • {next_action} • q: Cancel"
        else:
            keys_help = f" ↑/↓: Navigate • Space: Toggle • Tab: Switch Tab • a: Toggle All • {next_action} • q: Cancel"

        if len(keys_help) > max_x - 4:
            keys_help = " ↑/↓: Move • Space: Toggle • →/←: Tree • Enter: Next • q: Quit"

        self.safe_addstr(footer_y - 1, 2, divider, curses.color_pair(5) | curses.A_DIM)
        self.safe_addstr(footer_y, 2, keys_help, curses.color_pair(1))

        self.stdscr.refresh()

    def run(self):
        self.init_colors()

        while True:
            self.draw()
            try:
                key = self.stdscr.getch()
            except KeyboardInterrupt:
                self.cancelled = True
                break

            tab = self.current_tab()
            rows = self.get_visible_rows(tab)

            # Up navigation
            if key in (curses.KEY_UP, ord("k"), ord("K")):
                if self.cursor_idx > 0:
                    self.cursor_idx -= 1

            # Down navigation
            elif key in (curses.KEY_DOWN, ord("j"), ord("J")):
                if self.cursor_idx < len(rows) - 1:
                    self.cursor_idx += 1

            # Toggle Spacebar
            elif key == ord(" "):
                if self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category":
                        cat = current_row["data"]
                        any_unselected = any(
                            not item.get("selected", False) for item in cat["items"]
                        )
                        for item in cat["items"]:
                            item["selected"] = any_unselected
                    else:
                        item = current_row["data"]
                        item["selected"] = not item.get("selected", False)

            # Expand / Collapse toggle ('e' or 'E')
            elif key in (ord("e"), ord("E")):
                if self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category":
                        current_row["data"]["expanded"] = not current_row["data"].get(
                            "expanded", False
                        )
                    elif current_row["type"] == "item" and "parent" in current_row:
                        current_row["parent"]["expanded"] = not current_row[
                            "parent"
                        ].get("expanded", False)

            # Expand category (Right Arrow or 'l')
            elif key in (curses.KEY_RIGHT, ord("l"), ord("L")):
                if tab.get("is_tree") and self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category" and not current_row[
                        "data"
                    ].get("expanded", False):
                        current_row["data"]["expanded"] = True
                    else:
                        self.current_tab_idx = (self.current_tab_idx + 1) % len(
                            self.tabs
                        )
                        self.cursor_idx = 0
                else:
                    self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                    self.cursor_idx = 0

            # Collapse category (Left Arrow or 'h')
            elif key in (curses.KEY_LEFT, ord("h"), ord("H")):
                if tab.get("is_tree") and self.cursor_idx < len(rows):
                    current_row = rows[self.cursor_idx]
                    if current_row["type"] == "category" and current_row["data"].get(
                        "expanded", False
                    ):
                        current_row["data"]["expanded"] = False
                    elif current_row["type"] == "item" and "parent" in current_row:
                        current_row["parent"]["expanded"] = False
                    else:
                        self.current_tab_idx = (self.current_tab_idx - 1) % len(
                            self.tabs
                        )
                        self.cursor_idx = 0
                else:
                    self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                    self.cursor_idx = 0

            # Next Tab (Tab key)
            elif key == ord("\t"):
                self.current_tab_idx = (self.current_tab_idx + 1) % len(self.tabs)
                self.cursor_idx = 0

            # Previous Tab (Shift+Tab)
            elif key == curses.KEY_BTAB:
                self.current_tab_idx = (self.current_tab_idx - 1) % len(self.tabs)
                self.cursor_idx = 0

            # Toggle All ('a')
            elif key in (ord("a"), ord("A")):
                if tab.get("is_tree"):
                    all_items = [i for c in tab["categories"] for i in c["items"]]
                    any_unselected = any(
                        not item.get("selected", False) for item in all_items
                    )
                    for item in all_items:
                        item["selected"] = any_unselected
                else:
                    any_unselected = any(
                        not item.get("selected", False) for item in tab["items"]
                    )
                    for item in tab["items"]:
                        item["selected"] = any_unselected

            # Enter Key (Advance Tab or Finish)
            elif key in (curses.KEY_ENTER, 10, 13):
                if self.current_tab_idx < len(self.tabs) - 1:
                    self.current_tab_idx += 1
                    self.cursor_idx = 0
                else:
                    self.completed = True
                    break

            # Quit (q, Q, or Esc)
            elif key in (ord("q"), ord("Q"), 27):
                self.cancelled = True
                break

        return self.get_results()

    def get_results(self):
        if self.cancelled:
            return None

        results = {}
        for tab in self.tabs:
            if tab.get("is_tree"):
                cat_dict = {}
                flat_list = []
                for cat in tab["categories"]:
                    selected_items = [
                        item["id"]
                        for item in cat["items"]
                        if item.get("selected", False)
                    ]
                    cat_dict[cat["id"]] = selected_items
                    flat_list.extend(selected_items)
                results[tab["id"]] = cat_dict
                results[f"{tab['id']}_flat"] = flat_list
                results[f"{tab['id']}_categories"] = [
                    cat["id"]
                    for cat in tab["categories"]
                    if any(item.get("selected", False) for item in cat["items"])
                ]
            else:
                results[tab["id"]] = [
                    item["id"] for item in tab["items"] if item.get("selected", False)
                ]

        return results
