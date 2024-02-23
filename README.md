# Custom Linux
Build scripts for an alpine based distro

# Description

This distro is mostly an auto-installer for lightweight, configurable and user-friendly Alpine systems.

The project is used to patch the latest Alpine images and generate a Custom live iso.
Building the iso this way allows Custom to work on every architecture that is supported by Alpine Linux.


The goals that i try to follow while adding features to this project are:
- VM-first: the setup is entirely automatic and completely optional
	* the critical services like crond, acpid or networkmanager are optional, so that the config and the install script can be used as an educational example of what makes up a modern Linux distro
	* the user packages (zsh, libreoffice, firefox,...) are also optional, in order to allow extremely lightweight virtual machines
- "cross-distro": with the cross-platform Guix package manager, the Custom distro *should* be easy to port to an other distro (this part is postponed until the graphics work correctly, and might be canceled due to the disk space required by Guix)
- minimalist: currently, my wayland/riverwm setup takes about 300MB of ram and 700MB of disk space
- user-friendly: The setup should be useable by people who don't use Arch or rice their setup too hard


Most of my motivation comes from using virtual machines and having to choose between large ubuntu install sizes and light but unusable Alpine VMs.


# Status

Custom Linux can be installed in a VM, but some parts do not work as intended.

The iso can be built from Alpine Linux or from a Custom Linux install (since both distros are low level, there is a setup required before building the Custom image).


# What's in the project

The `installer-files` folder contains scripts and a yaml installation config file.
These files are bundled in the Alpine image.

The `local-apks` directory contains offline packages downloaded with apk from Alpine Linux. These packages are required to bootstrap the installer.

The `build.sh` script will patch the Alpine image by inserting the installer files and local packages.


<!--
The `apks` directory contains an Alpine apk package build script.

The package is built by the `build-apk.sh` script.
This .apk package contains the scripts and configs that will be used to install and setup the system.
The .apk package is not required for a functional setup, since the same files are bundled as a simple directory in the live iso.
-->

<!--
The `output` folder contains an existing .apk packaged version of the `scripts` folder.
-->

# Setup for building

You will need an Alpine Linux install to build the ISO. If you do not hav one already, you can install it in a virtual machine with virt-manager.

## Local package repository

Ths step is needed because the `local-apks` packages have to be indexed and signed for the apk command to use them.

This requires having installed the Alpine SDK and generating a key to sign the packages

You will also need to enable the Alpine community repository for some packages.

### Alpine SDK
```sh
apk add alpine-sdk
adduser $USER abuild
abuild-keygen -a -i
```

You will need to put your own public key (in ~/.abuild/ and in /etc/apk/keys) in `installer-files/keys` in order for them to be recognized as valid Custom keys.


### Community repository
You can reconfigure the Alpine mirrors and enable community repositories by running `setup-apkrepos`. This will modify the `/etc/apk/repositories` mirror list.



## Udisks2

The Udisks2 service is what allows users to mount removable devices without being root.
This features can be used in script with the `udisksctl` command.
Polkit is a service that manages controlled privilege escalation, and is used by Udisks2 to check if the user is allowed to manage devices.

Both of these services are builtin on Ubuntu, but have to be setup manually on Alpine Linux.

Note: if you use a shared filesystem with an Alpine Linux, you can also go through the `build.sh` script and split the tasks between your main OS, which should have udisks enabled, and Alpine.

To setup Udisks2:
```sh
apk add udisks2 polkit
rc-service polkit start
```

After restarting your shell session, udisks will allow you to mount devices with udisksctl, but will ask you to authenticate every time.

To skip this authentication step, you can add this polkit JS config to `/etc/polkit-1/rules/d/udisks.rules`:

```javascript
polkit.addRule(function(action, subject) {
    if (action.id.startsWith("org.freedesktop.udisks2."
     && subject.isInGroup("plugdev")) {
        return polkit.Result.YES;
    }
});
```

This will allow any user in the `plugdev` group to use udisksctl without authentication. The `plugdev` group is used by NetworkManager to allow rootless users to manage network connections.


## ISO

The `build.sh` script uses the mkisofs command.
To add this command:
`apk add xorriso`

<!--

## APK

note: this part is currently completely useless, and should be ignored

Building .apk packages requires using an existing Alpine setup.
To setup my environment on my Alpine VM, i used these commands:
```
apk add alpine-sdk
adduser $USER abuild	# add current user to the abuild groups
abuild-keygen -a -i -n	# Add a key in ~/.abuild and Install it in /etc/apk/keys, Non-interactively 
```
-->


# How to build

Once the requirements are ready, run:
```sh
./build.sh alpine.iso custom.iso
```
The `alpine.iso` image is not in this git repository, but it can be downloaded from the [official alpine downloads](https://www.alpinelinux.org/downloads/). Any Alpine image should work, but I test with the virt and standard images.

The script will:
* fetch packages from the APK repositories
* extract the contents of the alpine iso image
* insert Custom files
* package the files as a new bootable iso image

# Custom installation

After booting the Custom iso, execute these commands to install the OS:
```sh
# configure the keyboard layout (optional)
setup-keymap
# OR (non-interactive)
setup-keymap <layout> <variant>

# configure the Alpine repositories (optional)
setup-apkrepos
# OR (non-interactive):
setup-apkrepos -1 -c # -1 is the first repository mirror, -c enables the community repository

# initialize the install scripts
# this will install vim, nano and NetworkManager in the live environment
/media/cdrom/custom/init

# install the OS according to the config in ./choices.yml
./install
```

