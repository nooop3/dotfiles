"""draw kitty tab"""
# pyright: reportMissingImports=false,reportGeneralTypeIssues=false,reportAttributeAccessIssue=false,reportCallIssue=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

import datetime
import json

from os.path import expanduser

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options, current_focused_os_window_id
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

opts = get_options()

def get_current_session():
    session_id = current_focused_os_window_id()
    session_name = ""
    try:
        with open(f"{expanduser('~')}/.config/kitty/.kitty-sessions.json") as f:
            session_name = json.loads(f.read())[str(session_id)]
    except:
        for idx, window in enumerate(get_boss().list_os_windows()):
            if window['id'] == session_id:
                session_name = idx
    return f"{session_name}"

def _draw_left_status(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_tab_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    if draw_data.leading_spaces:
        screen.draw(' ' * draw_data.leading_spaces)
    draw_title(draw_data, screen, tab, index, max_tab_length)
    trailing_spaces = min(max_tab_length - 1, draw_data.trailing_spaces)
    max_tab_length -= trailing_spaces
    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw('…')
    if trailing_spaces:
        screen.draw(' ' * trailing_spaces)
    end = screen.cursor.x
    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return end

def _draw_right_status(draw_data: DrawData, screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x

    session_name = get_current_session()
    DATE_FG = as_rgb(int("ffffff", 16))
    cells = [
        (DATE_FG, as_rgb(color_as_int(draw_data.default_bg)), f" {session_name} "),
        (DATE_FG, as_rgb(color_as_int(draw_data.default_bg)), datetime.datetime.now().strftime(" %a %b %-d %H:%M ")),
    ]

    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Set cursor to where `left_status` ends, instead `right_status`,
    # to enable `open new tab` feature
    end = _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    _draw_right_status(
        draw_data,
        screen,
        is_last,
    )
    return end
