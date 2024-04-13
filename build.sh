#!/bin/sh

usage() {
	echo "usage: ./build.sh alpine.iso custom.iso"
	exit 0
}


source_iso="$1"
dest_iso="$2"



if [ -z "$source_iso" ]
then
	usage
fi
if [ -z "$dest_iso" ]
then
	usage
fi


# erase previous files
# (to keep updated version of packages and fix permission issues after using custom.iso in a libvirt VM)
if [ -d "local-apks" ]
then
	rm -r local-apks
	echo "cleaned package cache"
fi
if [ -e "$dest_iso" ]
then
	rm -f "$dest_iso"
fi

# fetch packages from alpine repos
mkdir -p local-apks/x86_64
cd local-apks/x86_64/
for pkg in $(cat ../../packages)
do
	apk fetch --recursive $pkg --repository "http://dl-cdn.alpinelinux.org/alpine/v3.19/main"
done
# index local packages
apk index -vU -o APKINDEX.tar.gz *.apk
# sign the index with the key generated with default settings by abuild-keygen
abuild-sign -k ~/.abuild/user-*.rsa APKINDEX.tar.gz
cd ../..



# extract the iso files to extracted/

temp_dir="./extracted"

if [ -d "$temp_dir" ]
then
	echo "cleaning previously extracted files"
	rm -r "$temp_dir"
fi

## a loop device is a virtual device that points to a file
## this is the linux version of using daemon tools to connect an iso to a virtual CD reader
loop_device=$(udisksctl loop-setup -f "$source_iso" | cut -d " " -f 5 | cut -d "." -f 1)
echo "created loop device at $loop_device"

## wait for device partitions to be detected ("while !check() {}" pattern)
while [ -z "$(udisksctl info -b "$loop_device" | grep PartitionTable)" ]
do
	:
done
echo "detected partitions on $loop_device"

## mount the partition
## there are 2 partitions on the stock Alpine images, but only one of them is useful and used
mount_path=$(udisksctl mount -b "$loop_device"p1 | cut -c 25-)
echo "mounted loop device at $mount_path"

## extract files and fix permissions (to add new files)
cp -r "$mount_path" "$temp_dir"
chmod -R u+rwx "$temp_dir"

echo "extracted files from $loop_device"

## disconnect the iso
udisksctl unmount -b "$loop_device"p1
echo "unmounted $mount_path"
udisksctl loop-delete -b "$loop_device"
echo "removed $loop_device loop device"

# add Custom files
cp -r installer-files extracted/custom
cp -r local-apks extracted/custom/apks
echo "added Custom files to extracted iso contents"


# generate the iso

## the destination directory (. for example) needs to be saved as an absolute path because of the cd command
dest_dir="$(dirname "$dest_iso")"
dest_file="$(basename "$dest_iso")"
absolute_dest_dir="$(cd "$dest_dir" && pwd)"
absolute_dest="$absolute_dest_dir/$dest_file"

cd "$temp_dir"
#mkisofs -o "$absolute_dest" -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -J -R -V "Custom Linux" .
boot="boot/syslinux/isolinux.bin"
boot_catalog="boot/syslinux/boot.cat"
efi="boot/grub/efi.img"
args="-no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot"
name="Custom Linux"
cmd="mkisofs -o "$absolute_dest" -b $boot -c $boot_catalog $args -e $efi -J -R -V \"$name\" . 2>&1" # > /dev/null 2>&1"
#echo "running: $cmd"
echo "creating $dest_iso"
# don't ask me what eval does, i just know it doesn't work without it
output=$(eval "$cmd")

result=$?

if [ "$result" = 0 ]
then
	echo "finished building $dest_iso"
else
	echo "ERROR: failed to generate $dest_iso"
	echo -e "output from command \"$cmd\":\n\n$output"
fi


