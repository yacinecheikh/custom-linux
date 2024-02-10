#!/bin/sh

# this script has to be ran from (my) Alpine with the correct key
cd local-apks/x86_64
apk index -vU -o APKINDEX.tar.gz *.apk

abuild-sign -k ~/.abuild/user-65ba7738.rsa APKINDEX.tar.gz


