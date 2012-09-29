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

swapon /dev/sda
mount /dev/sda3 /mnt
mkdir /mnt/home /mnt/boot
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home

# network
dhclient

# install
graphics="xorg-server xorg-xinit xorg-server-utils mesa gnome gdm"
development="git python vim"
utils="chromium terminator"
core="grub-bios reflector sudo zsh"
virtual="virtualbox-guest-utils"
pacstrap /mnt base  ${core} ${development} ${graphics}

# mounts
genfstab -p /mnt >> /mnt/etc/fstab
sed 's/,data=ordered//' /mnt/etc/fstab
arch-chroot /mnt

#core config
sed 's/#fr_FR UTF-8 UTF8/fr_FR UTF-8 UTF8' /etc/locale.gen
locale-gen
echo LANG=fr_FR.UTF-8 > /etc/locale.conf
export LANG=fr_FR.UTF-8
loadkeys fr-latin1
echo << EOF > /etc/vconsole.conf
KEYMAP="fr-latin1"
FONT="Lat2-Terminus16"
FONT_MAP=
EOF

ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc --utc

# network
read name
echo ${name} > /etc/hostname
sed 's/localhost.localdomain/${name}/g' /etc/hosts
sed 's/# interface=/interface=eth0/;s/# address=/address=/;s/# netmask=/netmask=/;s/# gateway=/gateway=/' /etc/rc.conf

# grub
grub-install --recheck /dev/sda
cp /usr/share/locale/fr/LC_MESSAGES/grub.mo /boot/grub/locale/fr.mo
grub-mkconfig -o /boot/grub/grub.cfg

# pacman
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyu

# users
passwd
sed 's/# %wheel/%wheel/' /etc/sudoers

read user
useradd -m -g users -G wheel -s /bin/zsh ${user}
passwd ${user}

# virtualbox
modprobe -a vboxguest vboxsf vboxvideo
echo <<  EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF

# desktop environment
sed 's/DAEMONS=(/DAEMONS=(dbus /' /etc/rc.conf
sed 's/id:3:initdefault:/#id:3:initdefault:/;s/#id:5:initdefault:/id:5:initdefault:/;s/x:5:respawn:/usr/bin/xdm -nodaemon/#x:5:respawn:/usr/bin/xdm -nodaemon/;s/#x:5:respawn:/usr/sbin/gdm -nodaemon/x:5:respawn:/usr/sbin/gdm -nodaemon/' /etc/inittab

# finish
exit
umount /mnt/{boot,home,}
reboot