#!/bin/bash

# Install Arch Linux
pacstrap /mnt base linux-zen linux-firmware grub

# Mount filesystem and chroot into /mnt
timedatectl set-ntp true
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Initial configuration
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "titan" >> /etc/hostname
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo root:4815 | chpasswd

# GRUB install
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Install display manager, network manager, etc.
pacman -Syu xorg xf86-video-intel plasma sddm networkmanager network-manager-applet inetutils qt5 cmake make man-db man-pages gcc inkscape firefox latte-dock


# Downloads everything needed
cd /home/$USER/Downloads
git clone https://github.com/tsujan/Kvantum.git
git clone https://github.com/vinceliuice/Layan-kde.git
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git
git clone https://github.com/varlesh/volantes-cursors.git

# Install Kvantum
cd /home/$USER/Downloads/Kvantum/Kvantum
mkdir build && cd build
cmake ..
make install

# Install icons
cd /home/$USER/Downloads/Reversal-icon-theme
./install.sh -a

# Install cursor
cd /home/$USER/Downloads/volantes-cursors
make build
make install

# Configure theme
cp /home/$USER/Downloads/Layan-kde/Kvantum/Layan/* /home/$USER/.config/Kvantum
cp /home/$USER/kvantum.kvconfig /home/$USER/.config/Kvantum
cd /home/$USER/Downloads/Layan-kde
./install.sh
lookandfeeltool -a com.github.vanceliuice.Layan
sed 's/Tela/Reversal-red-dark/' /home/$USER/.config/kdedefaults/kdeglobals
sed 's/Layan-white-cursors/volantes_light_cursors/' /home/$USER/.config/kdedefaults/kcminputrc

# GTK4
sed 's/breeze_cursors/volantes_light_cursors/' /home/$USER/.config/gtk-4.0/settings.ini
sed 's/24/32/' /home/$USER/.config/gtk-4.0/settings.ini
sed 's/Tela/Reversal-red-dark/' /home/$USER/.config/gtk-4.0/settings.ini
# GTK3
sed 's/breeze_cursors/volantes_light_cursors/' /home/$USER/.config/gtk-3.0/settings.ini
sed 's/24/32/' /home/$USER/.config/gtk-3.0/settings.ini
sed 's/Tela/Reversal-red-dark/' /home/$USER/.config/gtk-3.0/settings.ini

# Sets kvantum as application style
sed 's/Breeze/kvantum/' /home/$USER/.kde4/share/config/kdeglobals
sed 's/Breeze/kvantum/' /home/$USER/.config/kdeglobals

# Install zsh
pacman -S neofetch zsh
