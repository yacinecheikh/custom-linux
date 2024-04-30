"""
Generate config files from templates
"""

def xkeyboard(dest, layout, variant):
    with open("config/etc/X11/xorg.conf.d/00-keyboard.conf") as f:
        config = f.read()

    config = config.replace("{layout}", layout)
    config = config.replace("{variant}", variant)
    
    with open(dest, "w") as f:
        f.write(config)
