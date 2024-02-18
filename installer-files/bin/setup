#!/bin/sh

# assumes alpine linux is already installed, and the script is running from an existing fresh install

# setup config:
config() {
	cat configs/choices.yml | yq eval $1 -
}

config '.editor.[0]'
config '.wm-presets.[0]'
config '.system.user'
config '.wm-presets.[0].options.launchbar.[0]'
# do not test for real without a virtual environment
exit 0

# script dependencies
# not big enough to matter, probably
apk add yq

# lock root account
# (requires the initial setup of a (wheel) account during install to use doas)
passwd -l root

apk update
apk add $(config '.editor')


apk update
gui=$(config '.wm-presets.[0].name')
# case/esac
if [ "$gui" = "river" ]
then
	echo "setting up river window manager"
	# add edge testing repos
	# TODO: fix the content of repository-config
	# TODO: refactor configs into a file
	cat configs/river/apk-edge-repository >> /etc/apk/repositories
	apk add river
	rc-service seatd start
	rc-update add seatd
	adduser $(config '.system.user') seat
	apk add xwayland
	setup-devd udev
	# TODO: make this path-independant
	# (/home/{system user}/.config/river/init)
	path=".config/river"
	mkdir -p .config/river
	#touch .config/river/init
	#chmod +x .config/river/init
	cp configs/river/river-init .config/river/init
	chmod +x .config/river/init

	mkdir .config/waybar
	cp configs/river/waybar-config.json .config/waybar/config

	cp configs/river/xdg-profile.sh /etc/profile.d/xdg-runtime-dir.sh
	# TODO: chmod +x ?

	apk add font-dejavu

	# utilities
	apk add swaybg
	apk add firefox
	apk add foot
	apk add waybar
	apk add dbus dbus-x11 # needed for waybar
	launchbar=$(config '.wm-presets.[0].options.launchbar.[0]')
	# TODO: implement wofi choice
	if [ "$launchbar" = "bemenu" ]
	then
		apk add bemenu
	fi
	apk add thunar



	# session management
	login=$(config '.wm-presets.[0].options.login.[0]')
	if [ "$login" = "greetd-wlgreet" ]
	then
		echo "setting up greetd session manager"
		apk add greetd-wlgreet
		cp configs/river/greetd-config.toml /etc/greetd/config.toml
		cp configs/river/river-wlgreet-config /etc/greetd/river-wlgreet-config

		adduser greetd seat
		# TODO: carefully test before doing this
		#rc-service greetd start
		#rc-update add greetd
	fi

fi


optionals=$(config '.optional')
# TODO: for loop and apk add on each item
echo "not implemented: auto-installing optional features: $optionals"
