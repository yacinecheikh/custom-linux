#!/bin/sh

src=$1
dest=$2

# clean temp files
rm -r "$dest"


##### connect the iso and mount it

loopdevice=$(udisksctl loop-setup -f "$src" | cut -d " " -f 5 | cut -d "." -f 1)

# wait for device partitions to be detected by "while true {check()}"-ing them
while [ -z "$(udisksctl info --block-device $loopdevice | grep PartitionTable)" ]
do
	:
done

mountpath=$(udisksctl mount --block-device "$loopdevice"p1 | cut -c 25-)

# does this partition have any use ?
#udisksctl mount --block-device "$loopdevice"p2 | cut -c 25-



##### extract files

cp -r "$mountpath" "$dest"
#echo -"$mountpath"- # debug

# need to add files and then delete the folder
chmod -R u+rwx "$dest"



##### disconnect

# unmounting does not require the mount path
udisksctl unmount --block-device "$loopdevice"p1

udisksctl loop-delete --block-device $loopdevice
