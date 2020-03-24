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
            i3blocks \
            rxvt-unicode \
            rofi \
            qutebrowser \
            maim \
            arc-gtk-theme\
            keepassxc \
            networkmanager \
            tor

  pacman -S usbutils usb_modeswitch

  pacman -S telegram-desktop

  pacman -S ntfs-3g
}

install_vm_packages() {
  pacman -S virtualbox-guest-utils xf86-video-vmware
}

install_yay() {
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  yay -S ttf-iosevka
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
  # https://gist.github.com/magnetikonline/b6255da90606fe9c5c25d3333c98c90d
  touch /etc/systemd/user/ssh-agent.service
  echo "
[Unit]
Description=SSH authentication agent

[Service]
ExecStart=/usr/bin/ssh-agent -a %t/ssh-agent.socket -D
Type=simple

[Install]
WantedBy=default.target
}" >> /etc/systemd/user/ssh-agent.service

  systemctl enable ssh-agent.service
  systemctl enable networkmanager.service
}
enable_configuration() {
  git clone https://github.com/andreyvpng/dotmanager
  mv dotmanager/dotmanager /usr/bin/
}

install_and_setup_grub
install_xorg
install_additional_packages
install_yay
install_and_setup_sudo
set_date_time
set_locale
set_hostname

# Generate initramfs
mkinitcpio -P

setup_users
enable_services
enable_configuration
