#!/bin/sh


# package as an iso
cd extracted
mkisofs -o ../alpine-virt-remake.iso -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -J -R -V "Alpine remake" .
cd ..

