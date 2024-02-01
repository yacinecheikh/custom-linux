# custom-linux
Build scripts for an alpine based distro

# Status

Not working.
The iso build scripts work, but the iso patching does not.
The setup scripts are incomplete and need to be tested more thoroughly.

# What's in the project

The `apks` directory contains an Alpine apk package build script.

The package is built by the `build.sh` script.
This .apk package contains the scripts and configs that will be used to install and setup the system.

The `iso` folder is used to patch the Alpine Linux iso file, by extracting, patching and packaging its contents.

The `scripts` folder contains the configurations and scripts that are used to install and prepare the system from a yaml config file.

# Setup for building

## APK

## ISO

# How to run

## Iso extraction

## APK packaging

## Iso packing

