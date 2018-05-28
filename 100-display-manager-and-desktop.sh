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
#exit 1
#fi


  install_misc_apps() { #{{{
      print_title "$1 ESSENTIAL APPS"
            install_display_manager
            package_install "arandr"
            package_install "awesome-terminal-fonts"
            package_install "imagemagick"
            package_install "compton"
            package_install "lxappearance"
            package_install "lxrandr"
            package_install "nitrogen"
            package_install "rofi"
            package_install "slim"
            package_install "volumeicon"
            package_install "w3m"
            package_install "xorg-xrandr"
            package_install "xfce4-appfinder"
            package_install "xfce4-notifyd"
            package_install "xfce4-power-manager"
            package_install "xfce4-settings"
            package_install "xfce4-screenshooter"
            package_install "xfce4-taskmanager"
            package_install "dmenu"
            package_install "feh"
            package_install "viewnior"
            package_install "gmrun"
            package_install "rxvt-unicode"
            aur_package_install "squeeze-git"
            package_install "thunar tumbler"
            package_install "tint2"
            package_install "volwheel"
            package_install "xfburn"
            package_install "xcompmgr transset-df"
            package_install "zathura"
            package_install "speedtest-cli"
            aur_package_install "yad"
	    aur_package_install "skippy-xd-git"
  } #}}}

install_display_manager() { #{{{
      print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
      print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."

      #package_install "lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
      #system_ctl enable lightdm
      #sudo systemctl enable lightdm.service -f
      #sudo systemctl set-default graphical.target



  print_title "DESKTOP ENVIRONMENT|WINDOW MANAGER"
  print_info "A DE provide a complete GUI for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries.\n\nA window manager is one component of a system's graphical user interface."

   #I3 {{{
      print_title "i3 - https://wiki.archlinux.org/index.php/I3"
      print_info "i3 is a dynamic tiling window manager inspired by wmii that is primarily targeted at developers and advanced users. The stated goals for i3 include clear documentation, proper multi-monitor support, a tree structure for windows, and different modes like in vim."
      #sudo pacman -S --noconfirm --needed i3status
      aur_package_install "i3-gaps-next-git"
      package_install "rofi"
      aur_package_install "i3status-rust-git"
      # config xinitrc
      config_xinitrc "i3"
      # distro specific
      #aur_package_install "i3blocks"
      #}}}
   # 13)
      #OPENBOX {{{
      # print_title "OPENBOX - http://wiki.archlinux.org/index.php/Openbox"
      # print_info "Openbox is a lightweight and highly configurable window manager with extensive standards support."
      # package_install "obconf obmenu menumaker"
      # package_install "lxappearance"
      # package_install "leafpad epdfview nitrogen"
      # aur_package_install "openbox-patched"
      # mkdir -p /home/${username}/.config/openbox/
      # cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} /home/${username}/.config/openbox/
      # chown -R ${username}:users /home/${username}/.config
      # # config xinitrc
      # config_xinitrc "openbox-session"
      # # distro specific
      # package_install "gsimplecal"
      # package_install "oblogout"
      # aur_package_install "gtk2-perl"
      # aur_package_install "obkey"
      # aur_package_install "obmenu3"
      # aur_package_install "obmenu-generator"
      # aur_package_install "openbox-arc-git"
      # aur_package_install "perl-linux-desktopfiles"
      install_misc_apps "OPENBOX"

      #}}}
  #COMMON PKGS {{{
    #MTP SUPPORT {{{
    if is_package_installed "libmtp" ; then
      package_install "gvfs-mtp"
    fi
    #}}}
    if [[ ${KDE} -eq 0 ]]; then
      package_install "gvfs gvfs-goa gvfs-afc gvfs-mtp gvfs-google"
      package_install "xdg-user-dirs-gtk"
      package_install "pavucontrol"
      package_install "ttf-bitstream-vera ttf-dejavu"
      aur_package_install "gnome-defaults-list"
      is_package_installed "cups" && package_install "system-config-printer gtk3-print-backends"
      is_package_installed "samba" && package_install "gvfs-smb"
    fi
  #}}}
  #COMMON CONFIG {{{
    # speed up application startup
    mkdir -p ~/.compose-cache
    # D-Bus interface for user account query and manipulation
    system_ctl enable accounts-daemon
    # Improvements
    add_line "fs.inotify.max_user_watches = 524288" "/etc/sysctl.d/99-sysctl.conf"
  #}}}
}
