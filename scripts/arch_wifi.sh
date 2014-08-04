#!/bin/sh

# disks
loadkeys fr-latin1
fdisk /dev/sda << EOF
n
p
1

+100M
a
1
n
p
2

+256M
t
2
82
n
p
3

+8G
n
p


w
EOF

mkfs /dev/sda1
mkswap /dev/sda2
mkfs -t ext4 /dev/sda3
mkfs -t ext4 /dev/sda4

swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/home /mnt/boot
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home
mount -t tmpfs -o size=2G tmpfs /mnt/tmp

# network
wifi-menu

# install
pacstrap /mnt base syslinux openssh wpa_supplicant python python2

# mounts
genfstab -p /mnt >> /mnt/etc/fstab
cat <<EOF >> /mnt/etc/fstab
tmpfs	/tmp	tmpfs	size=2G	0 0
EOF

sed -i.ori 's/,data=ordered//' /mnt/etc/fstab
arch-chroot /mnt

# syslinux
syslinux-install_update -i -a -m

systemctl enable sshd.service

# finish
exit
umount /mnt/{boot,home,}
reboot
