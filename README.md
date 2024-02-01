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

Building .apk packages requires using an existing Alpine setup.
To setup my environment on my Alpine VM, i used these commands:
```
apk add alpine-sdk
adduser $USER abuild
abuild-keygen -a -i
```


## ISO

To be able to mount the iso without being root, I used `udisksctl`, which is builtin on Ubuntu.
I also used the `mkisofs` command to build the iso.

# How to build

## Iso extraction

In the `iso` folder, run `extract.sh` to extract the iso to the `extracted` folder.
You can ignore the `iso/build.sh` script (it only contains leftovers from previous build steps).

## APK packaging

In the root folder, run `build.sh` to package the scripts as custom-scripts-{version}-{release}.apk.

By default, `abuild` will output the apk to `~/apk-package/`. This has to be changed in /etc/abuild.conf for the output to be located in the iso files. However, doing so modifies the APKINDEX, which prevents the resulting live system from finishing loading.

I have not found how to fix this issue yet. 


## Iso packing

Once the extracted iso files have been modified, the iso can be rebuilt by running the `pack.sh` script in the `iso` folder.

