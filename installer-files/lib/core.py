#!/usr/bin/python3

from yaml import safe_load as yload, safe_dump as ydump
import subprocess
import sys


with open("./choices.yml") as f:
    config = yload(f)

def get(path):
    "'a.b.c' -> ['a']['b']['c']"
    c = config
    keys = path.split(".")
    for key in keys:
        # if something does not exist -> None
        if key not in c:
            return None
        c = c[key]
    return c


def system(cmd, stdin=None, stderr=False):
    "stdout[, stderr], errcode = system(command[, stdin][, stderr=True])"
    # merge stdout and stderr, and return error code instead
    if stdin is not None:
        stdin = stdin.encode()
    process = subprocess.Popen(cmd, shell=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE if stderr else subprocess.STDOUT)
    out, err = process.communicate(stdin)
    returncode = process.returncode
    if stderr:
        return out.decode(), err.decode(), returncode
    else:
        return out.decode(), returncode





