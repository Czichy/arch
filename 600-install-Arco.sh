#!/bin/bash
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


#if [[ -f `pwd`/sharedfuncs ]]; then
#  source sharedfuncs
#else
#  echo "missing file: sharedfuncs"
#  exit 1
#fi
#INSTALL ARCOLINUX {{{
install_arcolinux(){
    echo "################################################################"
    echo "####     Software from ArcoLinux Repository installed       ####"
    echo "################################################################"
    echo

    sudo pacman -S arcolinux-arc-themes-git --noconfirm --needed
    #sudo pacman -S arcolinux-awesome-git --noconfirm --needed
    sudo pacman -S arcolinux-common-git --noconfirm --needed
    sudo pacman -S arcolinux-config-git --noconfirm --needed
    sudo pacman -S arcolinux-conky-collection-git --noconfirm --needed
    sudo pacman -S arcolinux-docs-git --noconfirm --needed
    sudo pacman -S arcolinux-geany-git --noconfirm --needed
    sudo pacman -S arcolinux-i3wm-git --noconfirm --needed
    sudo pacman -S arcolinux-local-git --noconfirm --needed
    sudo pacman -S arcolinux-neofetch-git --noconfirm --needed
    sudo pacman -S arcolinux-nitrogen-git --noconfirm --needed
    sudo pacman -S arcolinux-oblogout-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-obmenu-generator-git --noconfirm --needed
    sudo pacman -S arcolinux-openbox-configs-git --noconfirm --needed
    sudo pacman -S arcolinux-openbox-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-pipemenus-git --noconfirm --needed
    sudo pacman -S arcolinux-plank-git --noconfirm --needed
    sudo pacman -S arcolinux-plank-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-polybar-git --noconfirm --needed
    sudo pacman -S arcolinux-rofi-git --noconfirm --needed
    #sudo pacman -S arcolinux-rofi-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-root-git --noconfirm --needed
    sudo pacman -S arcolinux-slimlock-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-termite-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-tint2-git --noconfirm --needed
    sudo pacman -S arcolinux-tint2-themes-git --noconfirm --needed
    sudo pacman -S arcolinux-variety-git --noconfirm --needed
    sudo pacman -S arcolinux-wallpapers-git --noconfirm --needed
    sudo pacman -S arcolinux-xfce-thunar-git --noconfirm --needed


    echo "################################################################"
    echo "####     Software from ArcoLinux Repository installed       ####"
    echo "################################################################"
    echo

    echo "################################################################"
    echo "Copying all files and folders from /etc/skel to ~"
    echo "################################################################"
    echo
    cp -rT /etc/skel ~

    echo "################################################################"
    echo "removing all folders and files unnecessary for this dekstop from .config"
    echo "################################################################"
    echo
    rm ~/.config/autostart/calamares.desktop

    echo "################################################################"
    echo "removing all folders and files unnecessary for this desktop from .local"
    echo "################################################################"
    echo
    echo "Making sure termite is standard terminal in thunar - deleting rest"
    rm -rf ~/.local/share/xfpanel-switch
    rm -rf ~/.local/share/applications
    }
#}}}
