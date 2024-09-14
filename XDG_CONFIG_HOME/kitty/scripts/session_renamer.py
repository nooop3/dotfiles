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
    if (len(args) > 1):
        raise Exception(f"Too many arguments: {args}")

    default = os.path.basename(os.environ['PWD'])
    print(styled('Enter the new title for this session below.', bold=True))
    answer = input(f'({default}) > ')

    return answer or default

def handle_result_by_open(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    exists = os.path.isfile(SESSION_FILE)
    session_names = {}
    if exists:
        with open(SESSION_FILE, "r") as f:
            session_names = json.loads(f.read())

    session_names[str(current_focused_os_window_id())] = answer
    with open(SESSION_FILE, "w") as f:
        json.dump(session_names, f)

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    fd = os.open(SESSION_FILE, os.O_RDWR | os.O_CREAT)

    size = os.stat(SESSION_FILE).st_size
    content = os.read(fd, size).decode("utf-8") or '{}'
    os.truncate(SESSION_FILE, 0)

    session_names = json.loads(content)
    session_names[str(current_focused_os_window_id())] = answer

    os.lseek(fd, 0, 0)
    os.write(fd, json.dumps(session_names).encode("utf-8"))

    os.close(fd)
