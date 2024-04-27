"""
Wrappers around shell commands
"""
from deps import get
from install_settings import verbose, auto

import sys

def confirm(question, default=None):
    while True:
        if default:
            x = input(f"{question} (Y/n): ")
            if not x or x.lower().startswith("y"):
                return True
            elif x.lower().startswith("n"):
                return False
        elif default is None:
            x = input(f"{question} (y/n): ")
            if x.lower().startswith("y"):
                return True
            elif x.lower().startswith("n"):
                return False
        else:
            x = input(f"{question} (y/N): ")
            if not x or x.lower().startswith("n"):
                return False
            elif x.lower().startswith("n"):
                return True

def error(src, msg):
    print(f"error: {msg} ({src})")
    sys.exit(1)

def todo(src):
    error(src, "not implemented")


def unknown(setting):
    value = get(setting)
    error(setting,"unrecognized setting: {value}")

