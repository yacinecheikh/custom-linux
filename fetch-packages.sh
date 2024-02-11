#!/bin/sh
cd local-apks/x86_64/
apk fetch --recursive yq networkmanager networkmanager-cli eudev networkmanager-openrc eudev-openrc udev-init-scripts-openrc dbus-openrc
