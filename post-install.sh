#! /bin/bash

install_and_setup_grub() {
  pacman -S grub efibootmgr

  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
  grub-mkconfig -o /boot/grub/grub.cfg
}

install_xorg() {
  pacman -S xorg \
            xorg-server \
            xorg-xinit \
            xf86-video-intel \
            xorg-xrdb
}

install_additional_packages() {
  pacman -S neovim \
            ranger \
            tmux \
            openssh

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
            keepassxc \
            networkmanager \
            tor

  pacman -S telegram-desktop

  pacman -S ntfs-3g
}

install_and_setup_sudo() {
  pacman -S sudo
  echo "%wheel ALL=(ALL) ALL" > /etc/sudoers
}

set_date_time() {
  # Set date time
  ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
  hwclock --systohc
}

set_locale() {
  sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" >> /etc/locale.conf
}

set_hostname() {
  # Set hostname
  echo "hostname" >> /etc/hostname
  echo "127.0.1.1 hostname.localdomain  hostname" >> /etc/hosts
}


setup_users() {
  echo "set root password"
  passwd

  # Create new user
  useradd -m -G wheel,power,iput,storage,uucp,network andrey
  sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
  echo "Set password for new user andrey"
  passwd andrey
}

enable_services() {
  systemctl enable networkmanager.service
}

enable_configuration() {
  echo "TODO"
}

install_and_setup_grub
install_xorg
install_additional_packages
install_and_setup_sudo
set_date_time
set_locale
set_hostname

# Generate initramfs
mkinitcpio -P

setup_users
enable_configuration
