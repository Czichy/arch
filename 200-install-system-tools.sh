#!/bin/bash
# if [[ -f `pwd`/sharedfuncs ]]; then
#   source sharedfuncs
# else
#   echo "missing file: sharedfuncs"
#   exit 1
# fi

#SYSTEM TOOLS {{{
install_system_apps(){
    print_title "SYSTEM TOOLS APPS"
    package_install "clamav"
          cp /etc/clamav/clamd.conf.sample /etc/clamav/clamd.conf
          cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf
          sed -i '/Example/d' /etc/clamav/freshclam.conf
          sed -i '/Example/d' /etc/clamav/clamd.conf
          system_ctl enable clamd
          freshclam
    	aur_package_install "cockpit storaged linux-user-chroot ostree"
        aur_package_install "webmin"
        package_install "docker"
        add_user_to_group ${username} docker
        is_package_installed "ufw" && package_remove "ufw"
        is_package_installed "firewalld" && package_remove "firewalld"
        package_install "firewalld"
        system_ctl enable firewalld
        package_install "gparted"
        package_install "grsync"
        aur_package_install "hosts-update"
        hosts-update
        package_install "htop"
        aur_package_install "plex-media-server"
        system_ctl enable plexmediaserver.service
        print_title "UFW - https://wiki.archlinux.org/index.php/Ufw"
        print_info "Ufw stands for Uncomplicated Firewall, and is a program for managing a netfilter firewall. It provides a command line interface and aims to be uncomplicated and easy to use."
        is_package_installed "firewalld" && package_remove "firewalld"
        aur_package_install "ufw gufw"
        system_ctl enable ufw.service
        aur_package_install "unified-remote-server"
        system_ctl enable urserver.service
          #Make sure we are not a VirtualBox Guest
          VIRTUALBOX_GUEST=`dmidecode --type 1 | grep VirtualBox`
          if [[ -z ${VIRTUALBOX_GUEST} ]]; then
            package_install "virtualbox virtualbox-host-dkms virtualbox-guest-iso linux-headers"
            aur_package_install "virtualbox-ext-oracle"
            add_user_to_group ${username} vboxusers
            modprobe vboxdrv vboxnetflt
          else
            cecho "${BBlue}[${Reset}${Bold}!${BBlue}]${Reset} VirtualBox was not installed as we are a VirtualBox guest."
          fi
        package_install "icoutils wine wine_gecko wine-mono winetricks"
        package_install "netdata"
        system_ctl enable netdata.service
        package_install "nload"
        package_install "gnome-logs"
        package_install "gnome-disk-utility"
        package_install "polkit-gnome"
        package_install "qjournalctl"
        package_install "pacmanlogviewer"
        package_install "seahorse"
        package_install "thunar"
        package_install "termite"
        package_install "thunar-archive-plugin"
        package_install "thunar-volman"
	      package_install "mc"

        #sh AUR/install-caffeine-ng-v*.sh
        aur_package_install "conky-lua-archers"
        aur_package_install "cool-retro-term"
        aur_package_install "discord"
        aur_package_install "mintstick-git"
        aur_package_install "temps"

	#install powerline
	package_install "powerline powerline-fonts"
	echo
	"powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh" > ~/.bashrc
  source ~/.bashrc



    echo "################################################################"
    echo "####    Software from Arch Linux Repository installed     ######"
    echo "################################################################"
    }
 #}}}
