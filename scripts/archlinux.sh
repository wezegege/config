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
mount -t tmpfs size=2G tmpfs /mnt/tmp

# network
dhclient

# install
graphics="xorg-server xorg-xinit xorg-server-utils mesa gnome gdm gnome-tweak-tool"
development="git python vim"
admin="pkgfile net-tools tree rsync ntp"
utils="chromium terminator flashplugin"
core="syslinux reflector sudo zsh openssh lsof htop ntop mlocate"
virtual="virtualbox-guest-utils"
build="fakeroot binutils wget make gcc colorgcc"
pacstrap /mnt base  ${core} ${development} ${graphics} ${admin} ${utils} ${core} ${virtual} ${build}

# mounts
genfstab -p /mnt >> /mnt/etc/fstab
cat <<EOF >> /mnt/etc/fstab
tmpfs	/tmp	tmpfs	size=2G	0 0
EOF

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
localectl set-x11-keymap fr pc105

ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc --utc
ntpd -q
hwclock -w

# network
read name
echo ${name} > /etc/hostname
sed 's/localhost.localdomain/${name}/g' /etc/hosts
sed 's/# interface=/interface=eth0/;s/# address=/address=/;s/# netmask=/netmask=/;s/# gateway=/gateway=/' /etc/rc.conf

# syslinux
syslinux-install_update -i -a -m

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
sed -i '/# %wheel ALL=(ALL) NOPASSWD: ALL/s/#//' /etc/sudoers

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

# misc
pkgfile --update

# install video driver
systemctl enable gdm dhcpd.service sshd.service ntpd.service

# finish
exit
umount /mnt/{boot,home,}
reboot
