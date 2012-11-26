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

# network
dhclient

# install
graphics="xorg-server xorg-xinit xorg-server-utils mesa gnome gdm"
development="git python vim"
admin="pkgfile"
utils="chromium terminator flashplugin"
core="grub-bios reflector sudo zsh openssh"
virtual="virtualbox-guest-utils"
build="fakeroot binutils wget"
pacstrap /mnt base  ${core} ${development} ${graphics} ${admin} ${utils} ${core} ${virtual} ${build}

# mounts
genfstab -p /mnt >> /mnt/etc/fstab
sed -i.ori 's/,data=ordered//' /mnt/etc/fstab
arch-chroot /mnt

#core config
sed -i.ori '/#fr_FR.UTF-8 UTF-8/s/#//' /etc/locale.gen
locale-gen
echo LANG=fr_FR.UTF-8 > /etc/locale.conf
export LANG=fr_FR.UTF-8
loadkeys fr-latin1
cat << EOF > /etc/vconsole.conf
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
cat << EOF >> /etc/pacman.conf
[archlinuxfr]
Server = http://repo.archlinux.fr/\$arch
EOF
pacman -Syyu yaourt pacman-color python-pip
yaourt chromium-stable-libpdf << EOF
1
n
y
EOF

pip install virtualenv virtualenvwrapper
# pip install fabric

# users
passwd
sed -i.ori '/# %wheel ALL=(ALL) NOPASSWD: ALL/s/#//' /etc/sudoers

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
systemctl enable gdm
systemctl enable dhcpd@eth0.service

# finish
exit
umount /mnt/{boot,home,}
reboot
