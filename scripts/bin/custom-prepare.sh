# this script is used to give the user basic capabilities while in the live system
# (internet access, correct keyboard layout, config edition)

# keymap (interactive)
setup-keymap
# setup network (interactive)
setup-interfaces
rc-service networking restart
# default repo config
setup-apkrepos -c -1

# instead of reading from a config file, install everything needed in the live system
apk add vim nano
apk add yq
