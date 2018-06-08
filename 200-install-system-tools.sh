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
        aur_package_install "discord"
        aur_package_install "mintstick-git"
        aur_package_install "temps"
	package_install "cmake freetype2 fontconfig pkg-config make xclip"
	aur_package_install "alacritty-scrollback-git"
	#install powerline
	#package_install "powerline powerline-fonts"
	#echo
	#"powerline-daemon -q
	#POWERLINE_BASH_CONTINUATION=1
	#POWERLINE_BASH_SELECT=1
	#. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh" > ~/.bashrc

	rmmod pcspkr

#ACCESSORIES {{{
         package_install "catfish"
         aur_package_install "conky-lua"
         package_install "lm_sensors"
         sensors-detect --auto
         package_install "docky"
         aur_package_install "dockmanager"
         package_install "galculator"
         #aur_package_install "pamac-aur"
         aur_package_install "pyrenamer"
         aur_package_install "enpass-bin"
         if [[ ${KDE} -eq 1 ]]; then
            aur_package_install "hotshots"
          else
            aur_package_install "shutter"
          fi
         package_install "synapse"
         aur_package_install "tilix-bin"
         package_install "terminator"
         aur_package_install "unified-remote-server"
         system_ctl enable urserver
#}}}

#DEVELOPEMENT {{{
         package_remove "vim"
         package_install "gvim ctags"
         package_install "meld"
         aur_package_install "android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform"
         package_install "android-tools android-udev libmtp"
           add_user_to_group ${username} sdkusers
           chown -R :sdkusers /opt/android-sdk/
           chmod -R g+w /opt/android-sdk/
           add_line "export ANDROID_HOME=/opt/android-sdk" "/home/${username}/.bashrc"
           aur_package_install "android-studio"
         package_install "intellij-idea-community-edition"
         aur_package_install "jdk"
         package_install "nodejs"
         aur_package_install "visual-studio-code-bin"
         aur_package_install "gitg"
         aur_package_install "qgit"     
         aur_package_install "kdiff3"
         aur_package_install "regexxer"
	 package_install "rustup"
	 rustup install stable
	 rustup install nightly && rustup default nightly
#}}}
#INTERNET {{{
    print_title "INTERNET APPS"
            print_title "BROWSER"
            	  aur_package_install "google-chrome"
                  package_install "firefox firefox-i18n-$LOCALE_FF"
                  aur_package_install "vivaldi"
            print_title "DOWNLOAD|FILESHARE"
            	  aur_package_install "aerofs"
                  aur_package_install "rslsync"
                  package_install "deluge"
                  aur_package_install "dropbox"
                  aur_package_install "flareget"
                  aur_package_install "jdownloader"
                  package_install "qbittorrent"
                  package_install "sparkleshare"
                  aur_package_install "spideroak"
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "transmission-qt"
                  else
                    package_install "transmission-gtk"
                  fi
                  if [[ -f /home/${username}/.config/transmission/settings.json ]]; then
                    replace_line '"blocklist-enabled": false' '"blocklist-enabled": true' /home/${username}/.config/transmission/settings.json
                    replace_line "www\.example\.com\/blocklist" "list\.iblocklist\.com\/\?list=bt_level1&fileformat=p2p&archiveformat=gz" /home/${username}/.config/transmission/settings.json
                  fi
                  package_install "uget"
                  package_install "youtube-dl"
                  aur_package_install "tixati"
                  aur_package_install "google-drive-ocamlfuse"
            print_title "MAPPING TOOLS"
                  aur_package_install "google-earth"
            print_title "DESKTOP SHARE"
                  aur_package_install "teamviewer"

#}}}
#THEMES {{{
  aur_package_install "neofetch"
  aur_package_install "screenkey"
  aur_package_install "vim-gruvbox-git vim-airline-gruvbox-git"

  #fonts
  aur_package_install "ttf-fantasque-sans-git"
  
  aur_package_install "ttf-font-awesome"
  aur_package_install "ttf-mac-fonts"
  aur_package_install "otf-fira-code"
  aur_package_install "virtualbox-for-linux-kernel"
  aur_package_install "xcursor-breeze"

  aur_package_install "vim-apprentice"
# these come last always
  aur_package_install "hardcode-fixer-git"
  sudo hardcode-fixer
#}}}
    echo "################################################################"
    echo "####    System tools installed                            ######"
    echo "################################################################"
    }
 #}}}
