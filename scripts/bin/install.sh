config() {
	cat install-choices.yml | yq eval $1 -
}


layout=$(config '.layout')
variant=$(config '.layout-variant')

#setup-keymap $layout $variant

hostname=$(config .'hostname')
#setup-hostname $hostname

#setup-interfaces -i < install-configs/interfaces

exit 0


# network:
setup-interfaces -i < install-configs/interfaces
# reloads network config and allows accessing internet
rc-service networking restart
# TODO: test this:
rc-update add networking

# TODO: set new root password

setup-timezone Europe/Paris
# (default: setup-timezone UTC)

# -c: community, -1: first repo in the list
setup-apkrepos -c -1


# TODO: how to configure completely ? adduser ? useradd ?
# TODO: difference: shutdown button works


# setup-devd: not done by the main setup script ? not sure
# seems to be mdev by default
# used for wayland setup -> see later

# -a: admin
# doing this installs doas automatically
# -g: groups (using this parameters creates /home/{user} for some reason)
# -f: full name
setup-user -a {user} -g 'audio video netdev'
# TODO: CREATE HOME
# set the password without prompting
echo {user}:{pass} | chpasswd

# TODO: problème: le home est créé dans le live system, mais perdu une fois installé
# fix: doas mkdir /home/{user}; doas chown {user}:{user} /home/{user}


# TODO: optional
setup-sshd openssh


# setup-ntp (not used in a VM setup because the kvm clock is used instead, but should be used in a physical setup)

# TODO: setup-disk
# -k virt: virtualized kernel
# -s 0: disable swap (-s <size>: use <size> MB of swap size)
# autres choix: bootloader (syslinux-extlinux par défaut), kernelopts (kernel boot parameters), disklabel
# TODO: au lieu de /dev/vda, on peut utiliser un mountpoint (à voir, peut servir)
# TODO: lire le code pour voir comment il détecte les drives (sda/vda)

# https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts
# TODO: setup-disk: variables d'environnement pour efi size, swap size, rootfs (btrfs), bootloader (grub/syslinux/...), disklabel (dos, gpt,...)

# TODO: read this:
#Partitioning

#If you have complex partitioning needs, that go beyond above alpine-disk options, you can partition, format, and mount your volumes manually, and then just supply the root mountpoint to setup-disk. Doing so implicitly behaves as though -m sys had also been specified.

#See Setting up disks manually for more information.

# TODO: lvm is trivial, allow this option later
yes | setup-disk -m sys /dev/vda





#===========================
# TODO: /home/{user} is lost after reboot
# TODO: shutdown button
# TODO: service networking à restart après reboot
setup-devd udev

solution: lire setup-alpine
-> lbu add $ROOT/home/{user}
#===========================




# TODO: wifi
# setup: add iw truc (optionnel ou dans l'installateur), et plus tard ajouter l'interface graphique (xfce) et firefox pour les captive portals

# WIP
# setup-alpine can also automate most of the setup, but there is no need to use it anymore since everything is already fine-tuned
#setup-alpine
