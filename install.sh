#!/bin/sh

if [ "$(id -u)" = 0 ]; then
	echo "This script MUST NOT be run as root as it makes changes to the users home directory."
	exit 1
fi

echo ###############################
echo #    UPDATING REPOSITORIES    #
echo ###############################
sudo pacman -Sy

echo #################################
echo #    INSTALLING DEPENDENCIES    #
echo #################################
sudo pacman -S --noconfirm --needed git base-devel xorg xorg-xinit vim ttf-font-awesome noto-fonts picom lxsession feh xautolock

#create cdos install directory 
[[ -f ~/.cdos_install ]] || mkdir ~/.cdos_install

#moving dwm config files into their appropriate directories
[[ -f ~/.dwm ]] || mkdir ~/.dwm
chmod +x autostart.sh ; cp autostart.sh ~/.dwm
chmod +x dwmbar.sh ; cp dwmbar.sh ~/.dwm
cp wallpaper.png ~/.dwm

cdosdir="$(pwd)"

#install pfetch (simpler neofetch)
echo ###########################
echo #    INSTALLING PFETCH    #
echo ###########################
cd ~/.cdos_install
git clone https://aur.archlinux.org/pfetch.git
cd pfetch
makepkg -si

#install dwm
echo ########################
echo #    INSTALLING DWM    #
echo ########################
cd ~/.cdos_install
git clone https://github.com/checcdev/dwm
cd dwm
sudo make clean install

#install st
echo #######################
echo #    INSTALLING ST    #
echo #######################
cd ~/.cdos_install
git clone https://github.com/checcdev/st
cd st
sudo make clean install

#install dmenu
echo ##########################
echo #    INSTALLING DMENU    #
echo ##########################
cd ~/.cdos_install
git clone https://github.com/checcdev/dmenu
cd dmenu 
sudo make clean install

#install slock (simple x locker)
echo ##########################
echo #    INSTALLING SLOCK    #
echo ##########################
cd ~/.cdos_install
git clone https://github.com/checcdev/slock
cd slock
sudo make clean install

#will exec startx automatically if in tty1
echo ############################
echo #    CONFIGURING BASHRC    #
echo ############################
cd $cdosdir
cat .bashrc > ~/.bashrc

#configuring xinitrc to start dwm
echo #############################
echo #    CONFIGURING XINITRC    #
echo #############################
echo -e "~/.dwm/autostart.sh &\nexec dwm" > ~/.xinitrc

echo ###################
echo #    REBOOTING    #
echo ###################
sudo reboot
