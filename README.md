# Custom Linux
Build scripts for an alpine based distro

# Description

This distro is mostly an auto-installer for lightweight, configurable and user-friendly Alpine systems.

The project is used to patch the latest Alpine images and generate a Custom live iso.
Building the iso this way allows Custom to work on every architecture that is supported by Alpine Linux.


The goals i try to follow while adding features to this project are:
- VM-first: the setup is entirely automatic and all the wanted packages (like zsh, docker,...) can be checked in the installer
	* this is just a convenience feature for quick, minimal and reproducible setups, and does not prevent the user from installing packages after install
- "cross-distro": with the cross-platform Guix package manager, the installation scripts *should* be easy to port to an other distro if needed (very WIP, might be canceled)
- minimalist: currently, my wayland/riverwm setup takes about 300MB of ram and 700MB of disk space
- user-friendly: The setup should be useable by people who don't use Arch or rice their setup too hard


Most of my motivation comes from using virtual machines and having to choose between large ubuntu images and maintaining custom Alpine VMs.
I would rather have a one-size-fits-all installer to quickly spawn new lightweight VMs.


# Status

Not ready for use.

The iso can be built on Ubuntu and installed in a VM.


# What's in the project

<!--
The `apks` directory contains an Alpine apk package build script.

The package is built by the `build-apk.sh` script.
This .apk package contains the scripts and configs that will be used to install and setup the system.
The .apk package is not required for a functional setup, since the same files are bundled as a simple directory in the live iso.
-->

The `iso` folder contains scripts to patch the Alpine Linux iso file.
These scripts are used by `build-iso.sh`.

The `scripts` folder contains the install scripts and a default yaml installation config.

<!--
The `output` folder contains an existing .apk packaged version of the `scripts` folder.
-->

# Setup for building

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

## Package cache

The Custom iso relies on packages that are not included with the standard Alpine image.

These required packages can be downloaded with the `fetch-packages.sh` script.
Some packages require having enabled the Alpine community repository first.

The main dependencies are `yq`, `networkmanager`, `networkmanager-cli` and `eudev`.
The reason I am publishing build instructions instead of a pre-built iso is that I am not sure if I am legally allowed to distribute these packages as part of an ISO.

After fetching the packages, they have to be indexed and signed with the `build-apkindex.sh` script.

<!--TODO: write how to setup abuild-->

## ISO

To be able to mount the iso without being root, I used `udisksctl`, which is already installed by default on Ubuntu.
I also used the `mkisofs` command to build the iso.


The `build-iso.sh` script assumes the presence of an Alpine iso named "base.iso" in the root of the project.

The `base.iso` is not in this git repository, but it can be downloaded from the [official alpine downloads](https://www.alpinelinux.org/downloads/).




# How to build

Once the requirements are ready, run `build-iso.sh`.

The script will:
* extract the contents of the `base.iso`
* insert Custom files
* package everything as a new bootable ISO file under the name `output.iso`

# Custom installation

After booting the Custom iso, execute these commands to install the OS:
```sh
# initialize the install scripts
/media/cdrom/custom/init
# prepare the environment for the user (keyboard layout, internet access and text editor)
./prepare
# install the OS according to the config in ./config/choices.yml
./install
```

