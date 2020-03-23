#! /bin/bash
echo "okay"

pacman -S grub

pacman -S \
       editor
          neovim \
       file manager
          ranger \
          tmux \
          openssh

pacman -S xorg \
          xorg-server \
          xf86-video-intel \
          xorg-xrdb

pacman -S i3-gaps\
          nitrogen \
          xfce4-power-manager \
          compton \
          redshift \
          xss-lock \
          i3lock-color \
          rxvt-unicode \
          rofi \
          qutebrowser \
          maim \
          arc-gtk-theme\

pacman -S telegram-desktop

pacman -S ntfs-3g

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname
echo "andrey" >> /etc/hostname
echo "127.0.1.1 andrey.localdomain  andrey" >> /etc/hosts

# Generate initramfs
mkinitcpio -P

# Set root password
passwd

# Install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
useradd -m -G wheel,power,iput,storage,uucp,network -s /usr/bin/zsh andrey
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
echo "Set password for new user andrey"
passwd andrey

# Enable services
#systemctl enable NetworkManager.service

echo "Configuration done. You can now exit chroot."
