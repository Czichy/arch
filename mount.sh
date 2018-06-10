#!/bin/bash
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@ /dev/sdb2 /mnt

mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@home /dev/sdb2 /mnt/home
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sdb2 /mnt/.snapshots
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@log /dev/sdb2 /mnt/var/log
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvol=@pkg /dev/sdb2 /mnt/var/cache/pacman/pkg
mount -o noatime,ssd,compress=lzo,space_cache=v2,subvolid=5 /dev/sdb2 /mnt/btrfs
mount /dev/sdb128 /mnt/boot
swapon /dev/sdb1
df -Th
genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab
