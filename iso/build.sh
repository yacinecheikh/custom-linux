

# apply the patch
cp -r iso-updates/* extracted




# clean temp files
rm -r extracted


########################################################

# not used anymore

# useless, since an iso can be mounted directly and the iso9660 partition is read-only
# write iso to disk image and use qemu-nbd to connect the disk as an nbd device
#qemu-img create -f qcow2 alpine-iso-decompressed 1G
#sudo qemu-nbd -c /dev/nbd0 alpine-iso-decompressed
#sudo dd bs=4M if=alpine-virt-3.19.0-x86_64.iso of=/dev/nbd0

# sudo mount /dev/nbd0p1 p1
# sudo mount /dev/nbd0p2 p2

#sudo qemu-nbd -d /dev/nbd0

# extraire et copier les fichiers de l'iso (monté) vers un dossier externe
# conserve les permissions, mais tout est en read-only
#tar cf - . | (cd /vm/standalone/extracted/; tar xfp -)

# rebuild l'iso avec mkisofs:
# boot en BIOS mais pas en UEFI
#sudo mkisofs -o ../alpine-virt-remake.iso -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V "Alpine remake" .


# -b -> boot file
# -c -> ? (boot catalogue)
# -e -> efi boot file (à tester)

# amélioré:
# boot en BIOS et en UEFI
#sudo mkisofs -o ../alpine-virt-remake.iso -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -J -R -V "Alpine remake" .


# amélioré ?
# pas testé et pas compris la différence, et probablement pas important puisque "ça marche"
#sudo mkisofs -o ../alpine-virt-remake.iso -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -J -R -V "Alpine remake" .
