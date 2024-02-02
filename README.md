# Custom Linux
Build scripts for an alpine based distro

# Description

This distro is mostly an auto-installer for lightweight, configurable and user-friendly Alpine systems.

Currently, the Custom iso is just an Alpine iso with new files under /media/cdrom to install a Custom setup.

This repository contains the tools used to build this iso.


The goals i try to follow while adding features to this project are:
- VM-first: the setup is entirely automatic and all the wanted packages (like zsh, docker,...) can be checked in the installer
	* this is just a convenience feature for quick, minimal and reproducible setups, and does not prevent the user from installing packages after install
- "cross-distro": with the cross-platform Guix package manager, the installation scripts *should* be easy to port to an other distro if needed (very WIP, might be canceled)
- minimalist: currently, my wayland/riverwm setup takes about 300MB of ram and 700MB of disk space
- user-friendly: The setup should be useable by people who don't use Arch or rice their setup too hard


Most of my motivation comes from using virtual machines and having to choose between large ubuntu images and maintaining custom Alpine VMs.
I would rather have a one-size-fits-all installer to quickly spawn new VMs.


# Status

Not ready for use.

The iso can be built and tested in a VM.


# What's in the project

The `apks` directory contains an Alpine apk package build script.

The package is built by the `build-apk.sh` script.
This .apk package contains the scripts and configs that will be used to install and setup the system.
The .apk package is not required for a functional setup, since the same files are bundled as a simple directory in the live iso.

The `iso` folder is used to patch the Alpine Linux iso file, by extracting its files, adding Custom files, and packing everything together in a new iso file.
The iso can be build with the `build-iso.sh` script.

The `scripts` folder contains the configurations and scripts that are used to install and prepare the system from a yaml config file.

The `output` folder contains an existing .apk packaged version of the `scripts` folder.

# Setup for building

## APK

note: this part is currently completely useless, and should be ignored

Building .apk packages requires using an existing Alpine setup.
To setup my environment on my Alpine VM, i used these commands:
```
apk add alpine-sdk
adduser $USER abuild	# add current user to the abuild groups
abuild-keygen -a -i -n	# Add a key in ~/.abuild and Install it in /etc/apk/keys, Non-interactively 
```


## ISO

To be able to mount the iso without being root, I used `udisksctl`, which is builtin on Ubuntu.
I also used the `mkisofs` command to build the iso.


The `build-iso.sh` script assumes the presence of an Alpine iso named "base.iso" in the root of the project.

The `base.iso` is not in this git repository, but it can be downloaded from the [official alpine downloads](https://www.alpinelinux.org/downloads/).



This whole project relies on dynamically patching the latest Alpine iso, so it should work on every architecture and every type of image.

# How to build

Building the iso is as simple as running `build-iso.sh` (while having a `base.iso` file at the root of this project).

The script will:
* extract the contents of the `base.iso`
* add the `scripts` folder and the custom-scripts.apk package to these files
* package everything as a new bootable ISO file under the name `output.iso`

# Test the resulting ISO

Once generated, the ISO can be tested in a KVM virtual machine.
The files added to the ISO can be found in /media/cdrom.

To prepare the live environment before the setup:
```sh
/media/cdrom/custom/bin/custom-prepare.sh
```
This script will let you configure the keyboard layout and the internet access, and install required packages for the setup.



## APK

If the iso contains an apk, it can be installed with:
```sh
apk add /media/cdrom/<apk> --force-non-repository --allow-untrusted
```
