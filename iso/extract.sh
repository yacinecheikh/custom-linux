#!/bin/sh

# clean temp files
rm -r extracted


##### connect the iso and mount it

loopdevice=$(udisksctl loop-setup -f base.iso | cut -d " " -f 5 | cut -d "." -f 1)

# wait for device partitions to be detected
while [ -z "$(udisksctl info --block-device $loopdevice | grep PartitionTable)" ]
do
	:
	#sleep 0
done

mountpath=$(udisksctl mount --block-device "$loopdevice"p1 | cut -c 25-)

# does this partition have any use ?
#udisksctl mount --block-device "$loopdevice"p2 | cut -c 25-



##### extract files

cp -r "$mountpath" extracted/
#echo -"$mountpath"- # debug

# need to add files and then delete the folder
chmod -R u+rwx extracted



##### disconnect

# unmounting does not require the mount path
udisksctl unmount --block-device "$loopdevice"p1

udisksctl loop-delete --block-device $loopdevice
