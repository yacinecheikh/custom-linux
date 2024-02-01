#!/bin/sh

src="$1"

# $dst needs to be absolute because of the `cd` command
dst_dir="$(dirname "$2")"
dst_file="$(basename "$2")"
dst_dir_abs="$(cd "$dst_dir" && pwd)"
dst="$dst_dir_abs/$dst_file"


# package as an iso
cd "$src"
mkisofs -o "$dst" -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -J -R -V "Custom Linux" .

