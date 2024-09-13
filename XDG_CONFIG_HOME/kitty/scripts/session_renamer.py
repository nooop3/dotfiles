# pyright: reportMissingImports=false,reportGeneralTypeIssues=false,reportAttributeAccessIssue=false,reportCallIssue=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

import json
import os

from typing import List
from kitty.boss import Boss
from kitty.constants import config_dir
from kittens.tui.operations import styled
from kitty.fast_data_types import current_focused_os_window_id

SESSION_FILE = os.path.join(config_dir, '.kitty-sessions.json')

def main(args: List[str]) -> str:
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    default = os.path.basename(os.environ['PWD'])
    print(styled('Enter the new title for this session below.', bold=True))
    answer = input(f'({default}) > ')
    # whatever this function returns will be available in the
    # handle_result() function
    return answer or default

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    with open(SESSION_FILE) as f:
        session_names = json.loads(f.read())
        session_names[str(current_focused_os_window_id())] = answer
    with open(SESSION_FILE, "w") as f:
        f.write(json.dumps(session_names))
