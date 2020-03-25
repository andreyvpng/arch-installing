#!/bin/bash

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk "/dev/sda"
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

mkfs.ext4 /dev/sda2
mkfs.fat -F32 /dev/sda1

# Mount the partitions
mount /dev/sda2 /mnt
mkdir -pv /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# install system
pacstrap /mnt base linux linux-firmware vim nano

# confiure system
genfstab -U /mnt >> /mnt/etc/fstab

# initial ramdisk
arch-chroot /mnt mkinitcpio -P

# time
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
arch-chroot /mnt hwclock --systohc

# locale
arch-chroot /mnt sed -ie 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -ie 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen

# host
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 machine.localdomain machine" >> /mnt/etc/hosts

# grub
arch-chroot /mnt pacman -S grub efibootmgr
arch-chroot /mnt mkdir /boot/efi
arch-chroot /mnt mount /dev/sda1 /boot/efi
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
