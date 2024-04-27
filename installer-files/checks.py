from lib.core import get


def check_dependencies():
    if get("install.mode") == "full" and get("installer.auto"):
        print("full install cannot be completely automated (due to the luks encryption passphrase)")
        sys.exit()


# TODO: openssh/other ssh
