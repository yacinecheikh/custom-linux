"""
Wrappers around shell commands
"""
from lib.core import system
from installer_settings import verbose, auto

import sys


#==================
# system() wrappers
#==================


def do(cmd, expected_code=0):
    "fire and forget"
    output, code = system(cmd)
    if code == expected_code:
        if verbose:
            print(f"running: {cmd}")
        return output
    else:
        print("error running:")
        print(cmd)
        print(f"return code: {code}")
        print("output:")
        print(output)
        #raise AssertionError("command did not run as expected")
        


#================
# chroot wrappers
#================

def chroot(mnt, cmd, stdin=None, stderr=False):
    return system(f"arch-chroot {mnt} {cmd}", stdin, stderr=stderr)

def chdo(mnt, cmd, expected=0):
    return do(f"arch-chroot {mnt} {cmd}", expected_code=expected)

#===============
# shell wrappers
#===============
def passwd(prompt):
    while True:
        x = input(f"{question}: ")
        if x == input(f"confirm: "):
            return x


# ====================
# more chroot wrappers
# ====================

def chadd(mnt, pkg):
    out, code = chroot(mnt, f"apk add {pkg}")
    if verbose:
        print(out)

def chdel(mnt, pkg):
    out, code = chroot(mnt, f"apk del {pkg}")
    if verbose:
        print(out)

def chrcstart(mnt, service):
    chroot(mnt, f"rc-service {service} start")

def chrcstop(mnt, service):
    chroot(mnt, f"rc-service {service} stop")

def chrcadd(mnt, service):
    chroot(mnt, f"rc-update add {service}")

def chrcdel(mnt, service):
    chroot(mnt, f"rc-update del {service}")


