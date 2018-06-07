#!/bin/bash
mount -o remount,size=2G /run/archiso/cowspace
pacman -Syuu
pacman -S git
git clone https://github.com/czichy/arch
cd arch

lsblk
mkfs.btrfs -m single -f -L arch /dev/sdb2
mount -o compress=lzo /dev/sdb2 /mnt
cd /mnt

btrfs su cr @
btrfs su cr @pkg
btrfs su cr @log
btrfs su cr @snapshots
btrfs su cr @home

cd /
umount /mnt
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@ /dev/sdb2 /mnt
cd /mnt
mkdir -p {boot,home,.snapshot,btrfs,var/{log,cache/pacman/pkg}

mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@home /dev/sdb2 /mnt/home
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sdb2 /mnt/.snapshots
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@log /dev/sdb2 /mnt/var/log
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@pkg /dev/sdb2 /mnt/var/cache/pacman/pkg
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvolid=5 /dev/sdb2 /mnt/btrfs
mount /dev/sdb128 /mtn/boot
swapon /dev/sdb1
df -Th

#pacstrap /mnt base base-devel btrfs-progs bash-completion snapper vim

#genfstab -U /mnt >> /mnt/etc/fstab
cd ~/arch
bash 001-install-arch
