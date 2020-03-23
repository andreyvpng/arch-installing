#! /bin/bash

# terminal apps
#pacman -S \
      # editor
          #neovim \
      # file manager
          #ranger \
          #tmux \
          #openssh

# Xorg
#pacman -S xorg \
          #xorg-server \
          #xf86-video-intel \
          #xorg-xrdb

# i3wm
#pacman -S i3-gaps\
      # wallpaper
          #nitrogen \
      # power manager
          #xfce4-power-manager \
      # visual
          #compton \
          #redshift \
      # auto-lock when suspend
          #xss-lock \
      # i3lock improved
          #i3lock-color \
      # terminal
          #rxvt-unicode \
      # runner
          #rofi \
      # browser
          #qutebrowser \
      # screenschots
          #maim \

# messanger
#pacman -S telegram-desktop


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
