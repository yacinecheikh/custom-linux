#!/bin/sh

rm -r extracted

./iso/extract.sh base.iso extracted

cp -r scripts extracted/custom
# output/custom-scripts.apk is a symbolic link to (some complicated path)
#cp output/custom-scripts.apk extracted/


./iso/pack.sh extracted output.iso

