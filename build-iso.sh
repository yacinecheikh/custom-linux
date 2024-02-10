#!/bin/sh

./iso/extract.sh base.iso extracted

cp -r installer-files extracted/custom
#mkdir extracted/custom/apks
#cp local-apks/*.apk extracted/custom/apks
cp -r local-apks extracted/custom/apks
cp user-65ba7738.rsa.pub extracted/custom/
# output/custom-scripts.apk is a symbolic link to (some complicated path)
#cp output/custom-scripts.apk extracted/


./iso/pack.sh extracted output.iso

