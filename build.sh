#!/bin/sh

./iso/extract.sh iso/base.iso iso/extracted

cp -r scripts iso/extracted/custom
# output/custom-scripts.apk is a symbolic link to (some complicated path)
cp output/custom-scripts.apk iso/extracted/


./iso/pack.sh ./iso/extracted ./iso/output.iso

