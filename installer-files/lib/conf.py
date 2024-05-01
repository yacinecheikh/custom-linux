"""
Generate config files from templates, and insert them in the mounted environment
"""

from lib.wrappers import do, cp, chmod

# xfce

def xkeyboard(mountpoint, layout, variant):
    path = "etc/X11/xorg.conf.d/00-keyboard.conf"
    sed1 = "sed 's/{layout}/" + layout + "/'"
    sed2 = "sed 's/{variant}/" + variant + "/'"
    do(f"cat config/{path} | {sed1} | {sed2} > {mountpoint}/{path}")
    #with open("config/etc/X11/xorg.conf.d/00-keyboard.conf") as f:
    #    config = f.read()

    #config = config.replace("{layout}", layout)
    #config = config.replace("{variant}", variant)
    #
    #with open(dest, "w") as f:
    #    f.write(config)


# riverwm

def greetd(mountpoint):
    path = "etc/greetd/config.toml"
    cp(f"config/{path}", f"{mountpoint}/{path}")


def polkit(mountpoint):
    path = "etc/polkit-1/rules.d"
    cp(f"config/{path}/*", f"{mountpoint}/{path}/")


def xdg_profile(mountpoint):
    path = "etc/profile.d/xdg-runtime-dir.sh"
    cp(f"config/{path}", f"{mountpoint}/{path}")


def river_wlgreet(mountpoint):
    path = "etc/greetd/river-wlgreet-config"
    cp(f"config/{path}", f"{mountpoint}/{path}")


def river(mnt, user):
    path = ".config/river/init"
    dest = f"{mnt}/home/{user}/{path}"
    mkdir(f"{mnt}/home/{user}/.config/river")
    cp(f"config/user/{path}", dest)
    chmod("+x", dest)


def waybar(mnt, user):
    home = f"{mnt}/home/{user}"
    mkdir(f"{home}/.config/waybar")
    cp(f"config/user/.config/waybar/config", "{home}/.config/waybar/config")

