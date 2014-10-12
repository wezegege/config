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
dhclient

# install
graphics="xorg-server xorg-xinit xorg-server-utils mesa gnome gdm gnome-tweak-tool alsa-utils evince eog"
development="git python vim ctags"
admin="pkgfile net-tools tree rsync ntp"
utils="chromium terminator"
core="syslinux reflector sudo zsh openssh lsof htop iftop mlocate"
virtual="virtualbox-guest-utils"
build="fakeroot binutils wget make gcc patch"
raid="gptfdisk"
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
sed -i 's/localhost.localdomain/${name}/g' /etc/hosts

# syslinux
syslinux-install_update -i -a -m
# raid specifics
sed -i '/APPEND/ s/.*/APPEND root=/dev/md3 rw md=1,/dev/sda1,/dev/sdb1 md=2,/dev/sda2,/dev/sdb2 md=3,/dev/sda3,/dev/sdb3' /boot/syslinux/syslinux.cfg
mdadm --specific --scan  >> /etc/mdadm.conf
sed -i '/FILES/ s#""#"/etc/mdadm.conf"#;
        /MODULES/ s#"$#dm_mod"#;
        /HOOKS/ s#udev#udev mdadm_udev#' /etc/mkinitcpio.conf
mkinitcpio -p linux

# pacman
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist
cat << EOF >> /etc/pacman.conf
[archlinuxfr]
Server = http://repo.archlinux.fr/\$arch
SigLevel = Never
EOF
pacman -Syyu yaourt python-pip
yaourt chromium-stable-libpdf chromium-pepper-flash << EOF
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
updatedb

# install video driver
systemctl enable gdm dhcpd.service sshd.service ntpd.service

# finish
exit
umount /mnt/{boot,home,}
reboot

############################################################################

# samba share server
pacman -S samba
cp /etc/samba/smb.conf{.default,}
useradd -r -p share share
cat <<EOF >> /etc/samba/smb.conf

[share]
path = /srv/share
read only = no
public = yes
writable = yes
inherit permissions = yes
EOF
gpasswd -a wezegege share
pdbedit -a -u share
pdbedit -a -u wezegege
systemctl enable smbd nmbd

# samba share client
pacman -S smbclient
mkdir /mnt/share /etc/samba
gpasswd -a wezegege share
cat <<EOF >> /etc/fstab
//wez-server/share /mnt/share cifs credentials=/etc/samba/share.shared,workgroup=MYGROUP,comment=systemd.automount 0 0
EOF
cat <<EOF > /etc/samba/share.shared
username=share
password=share
EOF

# deluge
pacman -S deluge python2-mako
systemctl enable deluged deluge-web

# mpd
pacman -S mpd
chown mpd: /var/lib/mpd
sed '/music_directory/ s#".*"#"/srv/share/music#' /etc/mpd.conf
systemctl enable mpd

# client175 

yaourt client175-svn
# systemctl files

# postgresql
pacman -S postgresql
systemd-tmpfiles --create postgresql.conf
mkdir /var/lib/postgres/data
chown -c -R postgres:postgres /var/lib/postgres
sudo su - postgres -c "initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
systemctl enable postgresql

# gitlab
pacman -S libpqxx
yaourt gitlab
sudo -u postgres psql -d template1 <<EOF
CREATE USER git WITH PASSWORD 'git';
CREATE DATABASE gitlabhq_production OWNER git;
\q
EOF
cp /usr/share/doc/gitlab/database.yml.postgresql /etc/gitlab/database.yml
sed -i '/username/ s#:#: git#;
        /password/ s#:#: git#' /etc/gitlab/database.yml
sed -i '/host/ s#localhost#0.0.0.0#;
        /port/ s#80#8888#;
        s#home/git#srv/git#g' /etc/gitlab/gitlab.yml
# change paths
systemctl enable redis gitlab-sidekiq gitlab

# ldap
pacman -S openldap
cat <<EOF >/etc/openldap/slapd.conf
database config
rootdn "cn=admin,cn=config"
rootpw config
EOF
slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d
chown -R ldap: /etc/openldap/slapd.d
systemctl enable slapd

