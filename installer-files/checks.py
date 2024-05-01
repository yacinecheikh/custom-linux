from lib.core import get


def check_dependencies():
    if get("graphics.preset") == "river" and not get("system.repository.apk.edge-testing"):
        print("riverwm cannot be installed without enabling the APK edge/testing repository")
        sys.exit()

def check_compat():
    if get("install.mode") == "full" and get("installer.auto"):
        print("full install cannot be completely automated (due to the luks encryption passphrase)")
        sys.exit()

# TODO: openssh/other ssh
