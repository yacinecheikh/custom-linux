#!/bin/sh

# get the absolute path of ./output
# (needed for abuild -r)
abs_path=$(cd ./output && pwd)
echo $abs_path

# tarball setup scripts
rm apks/apk/files.tar.gz
tar cvzf apks/apk/files.tar.gz scripts

# build the apk
cd apks/apk
abuild checksum
REPODEST="$abs_path" abuild -r
cd ../..

# output/custom-scripts.apk is a symbolic link to (some complicated path)
cp output/custom-scripts.apk iso/extracted/

