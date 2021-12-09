#!/bin/bash

# Initial configuration
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "titan" >> /etc/hostname
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo root:4815 | chpasswd

# GRUB install
cd /boot/
mkdir efi/
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Install display manager, network manager, etc.
pacman -Syu xorg xf86-video-intel plasma sddm networkmanager network-manager-applet inetutils qt5 cmake make man-db man-pages gcc inkscape firefox latte-dock


# Downloads everything needed
cd /tmp
git clone https://github.com/tsujan/Kvantum.git
git clone https://github.com/vinceliuice/Layan-kde.git
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git
git clone https://github.com/varlesh/volantes-cursors.git

# Install Kvantum
cd /tmp/Kvantum/Kvantum
mkdir build && cd build
cmake ..
make install

# Install icons
cd /tmp/Reversal-icon-theme
./install.sh -a

# Install cursor
cd /tmp/volantes-cursors
make build
make install

# Configure theme
cd /tmp/Layan-kde
./install.sh
lookandfeeltool -a com.github.vanceliuice.Layan

# Install zsh
pacman -S neofetch zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh $USER

# Starting services
systemctl enable sddm
systemctl enable NetworkManager

# Now exit the chrooted enviorment and reboot
cd /
exit
reboot now
