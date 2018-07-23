#!/bin/bash
#-------------------------------------------------------------------------------
#Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com
#Contribution: flexiondotorg
#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)

if [[ -f `pwd`/sharedfuncs.sh ]]; then
  source sharedfuncs.sh
else
  echo "missing file: sharedfuncs.sh"
  exit 1
fi
#ARCHLINUX U INSTALL {{{
#1 - WELCOME {{{
welcome(){
  clear
  echo -e "${Bold}Welcome to the Archlinux U Install script"
  print_line
  echo "Requirements:"
  echo "-> Archlinux installation"
  echo "-> Run script as root user"
  echo "-> Working internet connection"
  print_line
  echo "Script can be cancelled at any time with CTRL+C"
  print_line
  echo "http://www.github.com/helmuthdu/aui"
  print_line
  echo -e "\nBackups:"
  print_line
  # backup old configs
  [[ ! -f /etc/pacman.conf.aui ]] && cp -v /etc/pacman.conf /etc/pacman.conf.aui || echo "/etc/pacman.conf.aui";
  [[ -f /etc/ssh/sshd_config.aui ]] && echo "/etc/ssh/sshd_conf.aui";
  [[ -f /etc/sudoers.aui ]] && echo "/etc/sudoers.aui";
  pause_function
  echo ""
}
#}}}
use_all_cores(){
  numberofcores=$(grep -c ^processor /proc/cpuinfo)


  case $numberofcores in

      8)
          echo "You have " $numberofcores" cores."
          echo "Changing the makeflags for "$numberofcores" cores."
          sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j9"/g' /etc/makepkg.conf
          echo "Changing the compression settings for "$numberofcores" cores."
          sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
          ;;
      4)
          echo "You have " $numberofcores" cores."
          echo "Changing the makeflags for "$numberofcores" cores."
          sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
          echo "Changing the compression settings for "$numberofcores" cores."
          sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
          ;;
      2)
          echo "You have " $numberofcores" cores."
          echo "Changing the makeflags for "$numberofcores" cores."
          sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j3"/g' /etc/makepkg.conf
          echo "Changing the compression settings for "$numberofcores" cores."
          sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 2 -z -)/g' /etc/makepkg.conf
          ;;
      *)              
          echo "We do not know how many cores you have."
          echo "Do it manually."
          ;;

  esac

  echo "################################################################"
  echo "###  All cores will be used during building and compression ####"
  echo "################################################################"
}
#LOCALE SELECTOR {{{
language_selector(){
  #AUTOMATICALLY DETECTS THE SYSTEM LOCALE {{{
#automatically detects the system language based on your locale
  LOCALE=de_DE
  #`locale | grep LANG | sed 's/LANG=//' | cut -c1-5`
  #KDE #{{{
    LOCALE_KDE=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #FIREFOX #{{{
    LOCALE_FF=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #THUNDERBIRD #{{{
  LOCALE_TB=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #HUNSPELL #{{{
  LOCALE_HS=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #ASPELL #{{{
  LOCALE_AS=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #LIBREOFFICE #{{{
    LOCALE_LO=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #}}}
}
#}}}
#12 - SELECT/CREATE USER {{{
select_user(){
  #CREATE NEW USER {{{
  create_new_user(){
    read -p "Username: " username
    username=`echo $username | tr '[:upper:]' '[:lower:]'`
    useradd -m -g users -G wheel -s /bin/bash ${username}
    chfn ${username}
    passwd ${username}
    while [[ $? -ne 0 ]]; do
      passwd ${username}
    done
    pause_function
    configure_user_account
  }
  #}}}
  #CONFIGURE USER ACCOUNT {{{
  configure_user_account(){
    #BASHRC {{{
    print_title "BASHRC - https://wiki.archlinux.org/index.php/Bashrc"
          cp /etc/skel/.bashrc /home/${username}
    #}}}
    chown -R ${username}:users /home/${username}
  }
  #}}}
  print_title "SELECT/CREATE USER - https://wiki.archlinux.org/index.php/Users_and_Groups"
  users_list=(`cat /etc/passwd | grep "/home" | cut -d: -f1`);
  PS3="$prompt1"
  echo "Avaliable Users:"
  if [[ $(( ${#users_list[@]} )) -gt 0 ]]; then
    print_warning "WARNING: THE SELECTED USER MUST HAVE SUDO PRIVILEGES"
  else
    echo ""
  fi
  select OPT in "${users_list[@]}" "Create new user"; do
    if [[ $OPT == "Create new user" ]]; then
      create_new_user
    elif contains_element "$OPT" "${users_list[@]}"; then
      username=$OPT
    else
      invalid_option
    fi
    [[ -n $OPT ]] && break
  done
  [[ ! -f /home/${username}/.bashrc ]] && configure_user_account;
  if [[ -n "$http_proxy" ]]; then
      echo "proxy = $http_proxy" > /home/${username}/.curlrc
      chown ${username}:users /home/${username}/.curlrc
  fi
}
#}}}
#11 -CONFIGURE SUDO {{{
configure_sudo(){
  if ! is_package_installed "sudo" ; then
    print_title "SUDO - https://wiki.archlinux.org/index.php/Sudo"
    package_install "sudo"
  fi
  #CONFIGURE SUDOERS {{{
  if [[ ! -f  /etc/sudoers.aui ]]; then
    cp -v /etc/sudoers /etc/sudoers.aui
    ## Uncomment to allow members of group wheel to execute any command
    sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
    ## Same thing without a password (not secure)
    #sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers

    #This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
    echo "" >> /etc/sudoers
    echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
    echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
    echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
    echo 'Defaults passwd_tries=3, passwd_timeout=1' >> /etc/sudoers
    echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
    echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers
    echo 'Defaults timestamp_timeout=15' >> /etc/sudoers
    echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
    echo 'Defaults lecture=never' >> /etc/sudoers
  fi
  #}}}
}
#}}}
#AUR HELPER {{{
choose_aurhelper(){
  print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
  print_info "AUR Helpers are written to make using the Arch User Repository more comfortable."
  print_warning "\tNone of these tools are officially supported by Arch devs."
  git clone https://aur.archlinux.org/trizen.git && cd trizen && makepkg -si
  AUR_PKG_MANAGER="trizen"
}
#}}}
#CUSTOM REPOSITORIES {{{
add_custom_repositories(){
    print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
    local _repo="arcolinux_repo"
    local _check_repo=`grep -F "${_repo}" /etc/pacman.conf`
    if [[ -z $_check_repo ]]; then
      sudo pacman-key --keyserver hkps://hkps.pool.sks-keyservers.net:443 -r 74F5DE85A506BF64
      sudo pacman-key --lsign-key 74F5DE85A506BF64
      echo '#[arcolinux_repo_testing]
      #SigLevel = Required DatabaseOptional
      #Server = https://arcolinux.github.io/arcolinux_repo_testing/$arch
      [arcolinux_repo]
      SigLevel = Required DatabaseOptional
      Server = https://arcolinux.github.io/arcolinux_repo/$arch' | sudo tee --append /etc/pacman.conf
    fi
    system_update
}
#}}}
#BASIC SETUP {{{
install_basic_setup(){
  print_title "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
  package_install "bc rsync mlocate bash-completion pkgstats arch-wiki-lite"
 # pause_function
  print_title "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
  package_install "zip unzip unrar p7zip lzop cpio"
 # pause_function
  print_title "AVAHI - https://wiki.archlinux.org/index.php/Avahi"
  print_info "Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD discovery. It allows programs to publish and discovers services and hosts running on a local network with no specific configuration."
  package_install "avahi nss-mdns"
  is_package_installed "avahi" && system_ctl enable avahi-daemon
 # pause_function
  print_title "NTFS/FAT/exFAT/F2FS - https://wiki.archlinux.org/index.php/File_Systems"
  print_info "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
  package_install "ntfs-3g dosfstools exfat-utils f2fs-tools fuse fuse-exfat autofs mtpfs"
  #pause_function
}
#}}}
#SSH {{{
install_ssh(){
  print_title "SSH - https://wiki.archlinux.org/index.php/Ssh"
  print_info "Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers."
    package_install "openssh"
    system_ctl enable sshd
    [[ ! -f /etc/ssh/sshd_config.aui ]] && cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.aui;
    #CONFIGURE SSHD_CONF #{{{
      sed -i '/Port 22/s/^#//' /etc/ssh/sshd_config
      sed -i '/Protocol 2/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_rsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_dsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/KeyRegenerationInterval/s/^#//' /etc/ssh/sshd_config
      sed -i '/ServerKeyBits/s/^#//' /etc/ssh/sshd_config
      sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
      sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
      sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
      sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostbasedAuthentication no/s/^#//' /etc/ssh/sshd_config
      sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
      sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
      sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
      sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
      sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
      sed -i '/AllowTcpForwarding/s/^#//' /etc/ssh/sshd_config
      sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
      sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
      sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
      sed -i -e '/\tX11Forwarding yes/d' /etc/ssh/sshd_config
      sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
      sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
      sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
      sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
      sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
      sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
      sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
      sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
    #}}}
}
#}}}
#NFS {{{
install_nfs(){
  print_title "NFS - https://wiki.archlinux.org/index.php/Nfs"
  print_info "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
    package_install "nfs-utils"
    system_ctl enable rpcbind
    system_ctl enable nfs-client.target
    system_ctl enable remote-fs.target
}
#}}}
#ZSH {{{
install_zsh(){
  print_title "ZSH - https://wiki.archlinux.org/index.php/Zsh"
  print_info "Zsh is a powerful shell that operates as both an interactive shell and as a scripting language interpreter. "
    package_install "zsh"
      if [[ -f /home/${username}/.zshrc ]]; then
          run_as_user "mv /home/${username}/.zshrc /home/${username}/.zshrc.bkp"
          run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
          run_as_user "$EDITOR /home/${username}/.zshrc"
      else
        run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
        run_as_user "$EDITOR /home/${username}/.zshrc"
      fi
    package_install "zsh-autosuggestions"
    aur_package_install "antigen-git"
    aur_package_install "spaceship-prompt-git"
    aur_package_install "prezto-git"
    aur_package_install "fzf"

}
#}}}
#READAHEAD {{{
enable_readahead(){
  print_title "Readahead - https://wiki.archlinux.org/index.php/Improve_Boot_Performance"
  print_info "Systemd comes with its own readahead implementation, this should in principle improve boot time. However, depending on your kernel version and the type of your hard drive, your mileage may vary (i.e. it might be slower)."
    system_ctl enable systemd-readahead-collect
    system_ctl enable systemd-readahead-replay
}
#}}}
#ZRAM {{{
install_zram (){
  print_title "ZRAM - https://wiki.archlinux.org/index.php/Maximizing_Performance"
  print_info "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
    aur_package_install "zramswap"
    system_ctl enable zramswap
}
#}}}
#TLP {{{
install_tlp(){
  print_title "TLP - https://wiki.archlinux.org/index.php/Tlp"
  print_info "TLP is an advanced power management tool for Linux. It is a pure command line tool with automated background tasks and does not contain a GUI."
    package_install "tlp"
    system_ctl enable tlp
    system_ctl enable tlp-sleep
    system_ctl disable systemd-rfkill
    tlp start
}
#}}}
#XORG {{{
install_xorg(){
  print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
  print_info "Xorg is the public, open-source implementation of the X window system version 11."
  echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
  package_install "xorg-server xorg-apps xorg-server-xwayland xorg-xinit xorg-xkill xorg-xinput xf86-input-libinput"
  package_install "mesa"
  modprobe uinput
}
#}}}
#FONT CONFIGURATION {{{
font_config(){
  print_title "FONTS CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
  print_info "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
    pacman -S --asdeps --needed cairo fontconfig freetype2
}
#}}}
create_ramdisk_environment(){
  if [ "$(ls /boot | grep hardened -c)" -gt "0" ]; then
    mkinitcpio -p linux-hardened
  elif [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
    mkinitcpio -p linux-lts
  else
    mkinitcpio -p linux
  fi
}
#VIDEO CARDS {{{
install_video_cards(){
  package_install "dmidecode"
  print_title "VIDEO CARD"
  #check_vga
  #Virtualbox {{{
  #if [[ ${VIDEO_DRIVER} == virtualbox ]]; then
  #  if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
  #    package_install "virtualbox-guest-dkms virtualbox-guest-utils mesa-libgl"
  #  else
  #    package_install "virtualbox-guest-modules-arch virtualbox-guest-utils mesa-libgl"
  #  fi
  #  add_module "vboxguest vboxsf vboxvideo" "virtualbox-guest"
  #  add_user_to_group ${username} vboxsf
  #  system_ctl disable ntpd
  #  system_ctl enable vboxservice
  #  create_ramdisk_environment
  ##}}}
  ##VMware {{{
  #elif [[ ${VIDEO_DRIVER} == vmware ]]; then
  #  package_install "xf86-video-vmware xf86-input-vmmouse"
  #  if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
  #    aur_package_install "open-vm-tools-dkms"
  #  else
  #    package_install "open-vm-tools"
  #  fi
  #  cat /proc/version > /etc/arch-release
  #  system_ctl disable ntpd
  #  system_ctl enable vmtoolsd
  #  create_ramdisk_environment
  ##}}}
  #Bumblebee {{{
  #elif [[ ${VIDEO_DRIVER} == bumblebee ]]; then
    XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
    [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
    pacman -S --needed xf86-video-intel bumblebee nvidia nvidia-settings
    [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-virtualgl lib32-nvidia-utils
    replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
    create_ramdisk_environment
    add_user_to_group ${username} bumblebee
  #}}}
  #NVIDIA {{{
  #elif [[ ${VIDEO_DRIVER} == nvidia ]]; then
  #  XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
  #  [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
  #  if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
  #    package_install "nvidia-dkms nvidia-utils libglvnd"
  #    echo "Do not forget to make a mkinitcpio every time you updated the nvidia driver!"
  #  else
  #    package_install "nvidia nvidia-utils libglvnd"
  #  fi
  #  [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-nvidia-utils
  #  replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
  #  replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
  #  create_ramdisk_environment
  #  nvidia-xconfig --add-argb-glx-visuals --allow-glx-with-composite --composite --render-accel -o /etc/X11/xorg.conf.d/20-nvidia.conf;
  ##}}}
  ##Nouveau [NVIDIA] {{{
  #elif [[ ${VIDEO_DRIVER} == nouveau ]]; then
  #  is_package_installed "nvidia" && pacman -Rdds --noconfirm nvidia{,-utils}
  #  [[ ${ARCHI} == x86_64 ]] && is_package_installed "lib32-nvidia-utils" && pacman -Rdds --noconfirm lib32-nvidia-utils
  #  [[ -f /etc/X11/xorg.conf.d/20-nvidia.conf ]] && rm /etc/X11/xorg.conf.d/20-nvidia.conf
  #  package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
  #  replace_line '#*options nouveau modeset=1' 'options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
  #  replace_line '#*MODULES="nouveau"' 'MODULES="nouveau"' /etc/mkinitcpio.conf
  #  create_ramdisk_environment
  ##}}}
  ##ATI {{{
  #elif [[ ${VIDEO_DRIVER} == ati ]]; then
  #  is_package_installed "catalyst-total" && pacman -Rdds --noconfirm catalyst-total
  #  [[ -f /etc/X11/xorg.conf.d/20-radeon.conf ]] && rm /etc/X11/xorg.conf.d/20-radeon.conf
  #  [[ -f /etc/modules-load.d/catalyst.conf ]] && rm /etc/modules-load.d/catalyst.conf
  #  [[ -f /etc/X11/xorg.conf ]] && rm /etc/X11/xorg.conf
  #  if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
  #    aur_package_install "catalyst-total"
  #   else
  #     package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl mesa-vdpau libvdpau-va-gl"
  #    add_module "radeon" "ati"
  #  fi
  #  create_ramdisk_environment
  ##}}}
  ##Intel {{{
  #elif [[ ${VIDEO_DRIVER} == intel ]]; then
  #  package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
  ##}}}
  ##Vesa {{{
  #else
  #  package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
  #fi
  #}}}
  if [[ ${ARCHI} == x86_64 ]]; then
    is_package_installed "mesa-libgl" && package_install "lib32-mesa-libgl"
    is_package_installed "mesa-vdpau" && package_install "lib32-mesa-vdpau"
  fi
  if is_package_installed "libvdpau-va-gl"; then
    add_line "export VDPAU_DRIVER=va_gl" "/etc/profile"
  fi
  #pause_function
}
#}}}
#ADDITIONAL FIRMWARE {{{
install_additional_firmwares(){
  print_title "INSTALL ADDITIONAL FIRMWARES"
  read_input_text "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" $FIRMWARE
    while true
    do
      print_title "INSTALL ADDITIONAL FIRMWARES"
      echo " 1) $(menu_item "aic94xx-firmware") $AUR"
      echo " 2) $(menu_item "alsa-firmware")"
      echo " 3) $(menu_item "b43-firmware") $AUR"
      echo " 4) $(menu_item "b43-firmware-legacy") $AUR"
      echo " 5) $(menu_item "bfa-firmware") $AUR"
      echo " 6) $(menu_item "bluez-firmware") [Broadcom BCM203x/STLC2300 Bluetooth]"
      echo " 7) $(menu_item "broadcom-wl-dkms")"
      echo " 8) $(menu_item "ipw2100-fw")"
      echo " 9) $(menu_item "ipw2200-fw")"
      echo "10) $(menu_item "libffado") [Fireware Audio Devices]"
      echo "11) $(menu_item "libmtp") [Android Devices]"
      echo "12) $(menu_item "libraw1394") [IEEE1394 Driver]"
      echo ""
      echo " d) DONE"
      echo ""
      FIRMWARE_OPTIONS+=" d"
      read_input_options "$FIRMWARE_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "aic94xx-firmware"
            ;;
          2)
            package_install "alsa-firmware"
            ;;
          3)
            aur_package_install "b43-firmware"
            ;;
          4)
            aur_package_install "b43-firmware-legacy"
            ;;
          5)
            aur_package_install "bfa-firmware"
            ;;
          6)
            package_install "bluez-firmware"
            ;;
          7)
            package_install "broadcom-wl-dkms"
            ;;
          8)
            package_install "ipw2100-fw"
            ;;
          9)
            package_install "ipw2200-fw"
            ;;
          10)
            package_install "libffado"
            ;;
          11)
            package_install "libmtp"
            package_install "android-udev"
            ;;
          12)
            package_install "libraw1394"
            ;;
          "d")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
      create_ramdisk_environment
    done
}
#}}}
#CONNMAN/NETWORKMANAGER/WICD {{{
install_nm_wicd(){
  print_title "NETWORK MANAGER"
      print_title "NETWORKMANAGER - https://wiki.archlinux.org/index.php/Networkmanager"
      print_info "NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
      if [[ ${KDE} -eq 1 ]]; then
        package_install "networkmanager dnsmasq plasma-nm networkmanager-qt"
      else
        package_install "networkmanager dnsmasq network-manager-applet nm-connection-editor"                         #gnome-keyring"
      fi                        /
      # vpn support
      package_install "networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc"
      # auto update datetime from network
      if is_package_installed "ntp"; then
        package_install "networkmanager-dispatcher-ntpd"
        system_ctl enable NetworkManager-dispatcher.service
      fi
      # power manager support
      is_package_installed "tlp" && package_install "tlp-rdw"
      # network management daemon
      system_ctl enable NetworkManager.service
}
#}}}
  install_misc_apps() { #{{{
      print_title "$1 ESSENTIAL APPS"
            #install_display_manager
            package_install "arandr"
            #package_install "awesome-terminal-fonts"
            package_install "imagemagick"
            package_install "compton"
            #package_install "lxappearance"
            package_install "lxrandr"
            package_install "nitrogen"
            package_install "rofi"
            #package_install "slim"
            package_install "volumeicon"
            package_install "w3m"
            package_install "xorg-xrandr"
            #package_install "xfce4-appfinder"
            #package_install "xfce4-notifyd"
            #package_install "xfce4-power-manager"
            #package_install "xfce4-settings"
            #package_install "xfce4-screenshooter"
            #package_install "xfce4-taskmanager"
            #package_install "dmenu"
            package_install "feh"
            package_install "viewnior"
            #package_install "gmrun"
            package_install "rxvt-unicode"
            aur_package_install "squeeze-git"
            #package_install "thunar tumbler"
            #package_install "tint2"
            package_install "volwheel"
            package_install "xfburn"
            package_install "xcompmgr transset-df"
            package_install "zathura"
            package_install "speedtest-cli"
            aur_package_install "yad"
	   # aur_package_install "skippy-xd-git"
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
      package_install "i3-gaps"
      package_install "rofi"
      aur_package_install "i3status-rust-git"
      # config xinitrc
      config_xinitrc "i3"
      install_misc_apps "i3"
      # distro specific
      #aur_package_install "i3blocks"
      #}}}

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
  #COMMON CONFIG {{{
    # speed up application startup
    mkdir -p ~/.compose-cache
    # D-Bus interface for user account query and manipulation
    system_ctl enable accounts-daemon
    # Improvements
    add_line "fs.inotify.max_user_watches = 524288" "/etc/sysctl.d/99-sysctl.conf"
  #}}}
}

#SOUND SETUP {{{
install_sound(){
    print_title "PULSEAUDIO - https://wiki.archlinux.org/index.php/Pulseaudio"
    print_info "PulseAudio is the default sound server that serves as a proxy to sound applications using existing kernel sound components like ALSA or OSS"
    sudo pacman -S pulseaudio --noconfirm --needed
    sudo pacman -S pulseaudio-alsa --noconfirm --needed
    sudo pacman -S pavucontrol  --noconfirm --needed

    print_title "ALSA - https://wiki.archlinux.org/index.php/Alsa"
    print_info "The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."

    sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed
    sudo pacman -S gstreamer --noconfirm --needed
    sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly --noconfirm --needed
    sudo pacman -S volumeicon --noconfirm --needed
    sudo pacman -S playerctl --noconfirm --needed

    echo "################################################################"
    echo "#########   sound software software installed   ################"
    echo "################################################################"
}
#}}}

#CUPS {{{
install_cups(){
    print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
    print_info "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS X and other UNIX-like operating systems."

    sudo pacman -S --noconfirm --needed cups cups-pdf

    #first try if you can print without footmatic
    #sudo pacman -S foomatic-db-engine --noconfirm --needed
    #sudo pacman -S foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds --noconfirm --needed
    sudo pacman -S ghostscript gsfonts gutenprint --noconfirm --needed
    sudo pacman -S gtk3-print-backends --noconfirm --needed
    sudo pacman -S libcups --noconfirm --needed
    sudo pacman -S hplip --noconfirm --needed
    sudo pacman -S system-config-printer --noconfirm --needed

    sudo systemctl enable org.cups.cupsd.service

    echo "After rebooting it will work"

    echo "################################################################"
    echo "#########   printer management software installed     ##########"
    echo "################################################################"
 }
#}}}

#SAMBA {{{
install_samba(){
    sudo pacman -S --noconfirm --needed samba
    sudo wget "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -O /etc/samba/smb.conf.original
    sudo wget "https://raw.githubusercontent.com/arcolinux/arcolinux-iso/master/archiso/airootfs/etc/samba/smb.conf" -O /etc/samba/smb.conf
    sudo systemctl enable smbd.service
    sudo systemctl start smbd.service
    sudo systemctl enable nmbd.service
    sudo systemctl start nmbd.service

    ##Change your username here
    read -p "What is your login? It will be used to add this user to smb : " choice
    sudo smbpasswd -a $choice

    #access samba share windows
    sudo pacman -S --noconfirm --needed gvfs-smb


    # sudo systemctl restart ... if you run into trouble
    # testparm will check the conf file for errors

    # red hat samba sharing config

    # echo "################################################################"
    # echo "system-config-samba"
    # echo "################################################################"
    #
    #
    # package="system-config-samba"
    #
    # #----------------------------------------------------------------------------------
    #
    # #checking if application is already installed or else install with aur helpers
    # if pacman -Qi $package &> /dev/null; then
    #
    # 	echo "################################################################"
    # 	echo "################## "$package" is already installed"
    # 	echo "################################################################"
    #
    # else
    #
    # 	#checking which helper is installed
    # 	if pacman -Qi packer &> /dev/null; then
    #
    # 		echo "Installing with packer"
    # 		packer -S --noconfirm --noedit  $package
    #
    # 	elif pacman -Qi pacaur &> /dev/null; then
    #
    # 		echo "Installing with pacaur"
    # 		pacaur -S --noconfirm --noedit  $package
    #
    # 	elif pacman -Qi yaourt &> /dev/null; then
    #
    # 		echo "Installing with yaourt"
    # 		yaourt -S --noconfirm $package
    #
    # 	fi
    #
    # 	# Just checking if installation was successful
    # 	if pacman -Qi $package &> /dev/null; then
    #
    # 	echo "################################################################"
    # 	echo "#########  "$package" has been installed"
    # 	echo "################################################################"
    #
    # 	else
    #
    # 	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    # 	echo "!!!!!!!!!  "$package" has NOT been installed"
    # 	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    #
    #
    # 	fi
    #
    # fi
    #
    #
    #
    #
    #
    # echo "Run system-config-samba to set up shares"
    # echo "You will be able to connect to this computer with the login and password you created"
    # echo "You will need to edit /etc/samba/smb.conf"
    # echo "Scroll down to bottom"
    # echo "Example code is in there"
    # echo "Create a folder with name 'SHARED' in your homefolder."
    # echo "Make sure you delete all the ; in those lines."
    # echo "Reboot and enjoy"

    echo "################################################################"
    echo "#########   samba  software installed           ################"
    echo "################################################################"
    }
#}}}
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
        package_install "cronie"
        system_ctl enable cronie
        package_install "xf86-input-synaptics"
        aur_package_install "grub-btrfs snap-pac-grub snap-pac"
        #package_install "gparted"
        #package_install "grsync"
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
        #package_install "polkit-gnome"
        package_install "journalctl"
        package_install "pacmanlogviewer"
        #package_install "seahorse"
        #package_install "termite"
	    package_install "ranger"
	    package_install "pacman-contrib"
        package_install "cdrtools"
        #sh AUR/install-caffeine-ng-v*.sh
        aur_package_install "conky-lua-archers"
        #aur_package_install "discord"
        aur_package_install "mintstick-git"
        aur_package_install "temps"
	package_install "cmake freetype2 fontconfig pkg-config make xclip"
	aur_package_install "alacritty-scrollback-git"
	rmmod pcspkr


    echo "################################################################"
    echo "####    System tools installed                            ######"
    echo "################################################################"
    }
 #}}}
#DEVELOPEMENT {{{
install_development_apps(){
         package_remove "vim"
         package_install "neovim"
         curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim
         package_install "meld"
         package_install "python3"
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
   rustup component add rls-preview rust-analysis rust-src
}
#}}}
#OFFICE {{{
install_office_apps(){
          print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
          package_install "libreoffice-fresh"
          [[ $LOCALE != en_US ]] && package_install "libreoffice-fresh-$LOCALE_LO"
          package_install "hunspell hunspell-$LOCALE_HS"
          package_install "aspell aspell-$LOCALE_AS"
          package_install "ocrfeeder tesseract gocr"
          package_install "aspell aspell-$LOCALE_AS"
          package_install "xmind"
          package_install "goldendict"
}
#}}}

#INTERNET {{{
install_internet_apps(){
    print_title "INTERNET APPS"
            print_title "BROWSER"
                  package_install "firefox firefox-i18n-$LOCALE_FF"
                  #aur_package_install "vivaldi"
            print_title "DOWNLOAD|FILESHARE"
            	  aur_package_install "aerofs"
                  aur_package_install "rslsync"
                  package_install "deluge"
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
                  #aur_package_install "google-drive-ocamlfuse"
            #print_title "MAPPING TOOLS"
                  #aur_package_install "google-earth"
            print_title "DESKTOP SHARE"
                  aur_package_install "teamviewer"
}
#}}}
#GRAPHICS {{{
install_graphics_apps(){
    print_title "GRAPHICS APPS"
    	package_install "gimp"
        package_install "inkscape python2-numpy python-lxml"
        package_install "simple-scan"
}
#}}}
#AUDIO {{{
install_audio_apps(){
    print_title "AUDIO APPS"
            print_title "AUDIO PLAYERS"
                  package_install "audacious audacious-plugins"
                  package_install "ncmpcpp"
		          #aur_package_install "banshee"
                  aur_package_install "spotify"

}
#}}}
#VIDEO {{{
install_video_apps(){
    print_title "VIDEO APPS"
          #PLAYERS {{{
            print_title "VIDEO PLAYERS"
                  package_install "vlc"
                  package_install "kodi"
                  add_user_to_group ${username} kodi
                  package_install "obs-studio-git"

}
#}}}
#THEMES {{{
install_themes(){
  aur_package_install "neofetch"
  aur_package_install "screenkey"

  #fonts
  aur_package_install "ttf-fantasque-sans-git"

  aur_package_install "ttf-font-awesome"
  aur_package_install "ttf-mac-fonts"
  aur_package_install "otf-fira-code"
  aur_package_install "virtualbox-for-linux-kernel"
  aur_package_install "xcursor-breeze"

# these come last always
  aur_package_install "hardcode-fixer-git"
  sudo hardcode-fixer
}
#}}}
#WEBSERVER {{{
install_web_server(){
  install_adminer(){ #{{{
    aur_package_install "adminer"
    local ADMINER=`cat /etc/httpd/conf/httpd.conf | grep Adminer`
    [[ -z $ADMINER ]] && echo -e '\n# Adminer Configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
  } #}}}
  install_mariadb(){ #{{{
    package_install "mariadb"
    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    system_ctl enable mysqld.service
    systemctl start mysqld.service
    /usr/bin/mysql_secure_installation
  } #}}}
  install_postgresql(){ #{{{
    package_install "postgresql"
    mkdir -p /var/lib/postgres
    chown -R postgres:postgres /var/lib/postgres
    systemd-tmpfiles --create postgresql.conf
    echo "Enter your new postgres account password:"
    passwd postgres
    while [[ $? -ne 0 ]]; do
      passwd postgres
    done
    su - postgres -c "initdb --locale ${LOCALE}.UTF-8 -D /var/lib/postgres/data"
    system_ctl enable postgresql.service
    system_ctl start postgresql.service
    read_input_text "Install Postgis + Pgrouting" $POSTGIS
    [[ $OPTION == y ]] && install_gis_extension
  } #}}}
  install_gis_extension(){ #{{{
    package_install "postgis"
    aur_package_install "pgrouting"
  } #}}}
  configure_php(){ #{{{
    if [[ -f /etc/php/php.ini.pacnew ]]; then
      mv -v /etc/php/php.ini /etc/php/php.ini.pacold
      mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
      rm -v /etc/php/php.ini.aui
    fi
    [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui" || cp -v /etc/php/php.ini /etc/php/php.ini.aui
    if [[ $1 == mariadb ]]; then
      sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
      sed -i '/mysql.so/s/^;//' /etc/php/php.ini
      sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
    else
      sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
    fi
    sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
    sed -i '/gd.so/s/^;//' /etc/php/php.ini
    sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
  } #}}}
  configure_php_apache(){ #{{{
    if [[ -f /etc/httpd/conf/httpd.conf.pacnew ]]; then
      mv -v /etc/httpd/conf/httpd.conf.pacnew /etc/httpd/conf/httpd.conf
      rm -v /etc/httpd/conf/httpd.conf.aui
    fi
    [[ -f /etc/httpd/conf/httpd.conf.aui ]] && echo "/etc/httpd/conf/httpd.conf.aui" || cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
    local IS_DISABLED=`cat /etc/httpd/conf/httpd.conf | grep php5_module.conf`
    if [[ -z $IS_DISABLED ]]; then
      echo -e 'application/x-httpd-php5                php php5' >> /etc/httpd/conf/mime.types
      sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
      echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
      #  libphp5.so included with php-apache does not work with mod_mpm_event (FS#39218). You'll have to use mod_mpm_prefork instead
      replace_line 'LoadModule mpm_event_module modules/mod_mpm_event.so' 'LoadModule mpm_prefork_module modules/mod_mpm_prefork.so' /etc/httpd/conf/httpd.conf
      replace_line 'DirectoryIndex\ index.html' 'DirectoryIndex\ index.html\ index.php' /etc/httpd/conf/httpd.conf
    fi
  } #}}}
  configure_php_nginx(){ #{{{
    if [[ -f /etc/nginx/nginx.conf.pacnew ]]; then
      mv -v /etc/nginx/nginx.conf.pacnew /etc/nginx/nginx.conf
      rm -v /etc/nginx/nginx.conf.aui
    fi
    [[ -f /etc/nginx/nginx.conf.aui ]] && cp -v /etc/nginx/nginx.conf.aui /etc/nginx/nginx.conf || cp -v /etc/nginx/nginx.conf /etc/nginx/nginx.conf.aui
    sed -i -e '/location ~ \.php$ {/,/}/d' /etc/nginx/nginx.conf
    sed -i -e '/pass the PHP/a\        #\n        location ~ \.php$ {\n            fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;\n            fastcgi_index  index.php;\n            root           /srv/http;\n            include        fastcgi.conf;\n        }' /etc/nginx/nginx.conf
  } #}}}
  create_sites_folder(){ #{{{
    [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
    replace_line 'public_html' 'Sites' /etc/httpd/conf/extra/httpd-userdir.conf
    su - ${username} -c "mkdir -p ~/Sites"
    su - ${username} -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
    print_line
    echo "The folder \"Sites\" has been created in your home"
    echo "You can access your projects at \"http://localhost/~username\""
    pause_function
  } #}}}
  print_title "WEB SERVER - https://wiki.archlinux.org/index.php/LAMP|LAPP"
  print_info "*Adminer is installed by default in all options"
  echo " 1) LAMP - APACHE, MariaDB & PHP"
  echo " 2) LAPP - APACHE, POSTGRESQL & PHP"
  echo " 3) LEMP - NGINX, MariaDB & PHP"
  echo " 4) LEPP - NGINX, POSTGRESQL & PHP"
  echo ""
  echo " b) BACK"
  echo ""
  read_input $WEBSERVER
  case "$OPTION" in
    1)
      package_install "apache php php-apache php-mcrypt php-gd"
      install_mariadb
      install_adminer
      system_ctl enable httpd.service
      configure_php_apache
      configure_php "mariadb"
      create_sites_folder
      ;;
    2)
      package_install "apache php php-apache php-pgsql php-gd"
      install_postgresql
      install_adminer
      system_ctl enable httpd.service
      configure_php_apache
      configure_php "postgresql"
      create_sites_folder
      ;;
    3)
      package_install "nginx php php-mcrypt php-fpm"
      install_mariadb
      system_ctl enable nginx.service
      system_ctl enable php-fpm.service
      configure_php_nginx
      configure_php "mariadb"
      ;;
    4)
      package_install "nginx php php-fpm php-pgsql"
      install_postgresql
      system_ctl enable nginx.service
      system_ctl enable php-fpm.service
      configure_php_nginx
      configure_php "postgresql"
      ;;
  esac
}
#}}}
#CLEAN ORPHAN PACKAGES {{{
clean_orphan_packages(){
  print_title "CLEAN ORPHAN PACKAGES"
  pacman -Rsc --noconfirm $(pacman -Qqdt)
  #pacman -Sc --noconfirm
  #pacman-optimize
}
#}}}
#EXTRA {{{
install_extra(){
    print_title "EXTRA"
          #aur_package_install "gtk2-appmenu gtk3-appmenu"
          #if [[ ${KDE} -eq 1 ]]; then
          #  aur_package_install "appmenu-qt appmenu-gtk"
          #  aur_package_install "kdeplasma-applets-menubar"
          #fi
          #if [[ ! -f /home/${username}/.config/gtk-3.0/settings.ini ]]; then
          #  run_as_user "echo -e \"[Settings]\ngtk-shell-shows-menubar = 1\" > /home/${username}/.config/gtk-3.0/settings.ini"
          #else
          #  add_line "gtk-shell-shows-menubar = 1" "/home/${username}/.config/gtk-3.0/settings.ini"
          #fi
          #aur_package_install "profile-sync-daemon"
          #run_as_user "psd"
          #run_as_user "$EDITOR /home/${username}/.config/psd/psd.conf"
          #run_as_user "systemctl --user enable psd.service"
}
#}}}
#FINISH {{{
finish(){
  print_title "WARNING: PACKAGES INSTALLED FROM AUR"
  print_danger "List of packages not officially supported that may kill your cat:"
  pause_function
  AUR_PKG_LIST="${AUI_DIR}/aur_pkg_list.log"
  pacman -Qm | awk '{print $1}' > $AUR_PKG_LIST
  less $AUR_PKG_LIST
  print_title "INSTALL COMPLETED"
  echo -e "Thanks for using the Archlinux Ultimate Install script by helmuthdu\n"
  #REBOOT
  read -p "Reboot your system [y/N]: " OPTION
  [[ $OPTION == y ]] && reboot
  exit 0
}
#}}}

welcome
check_root
check_archlinux
check_hostname
check_connection
check_pacman_blocked
check_multilib
pacman_key
system_update
language_selector
configure_sudo
select_user
choose_aurhelper

  print_title "ARCHLINUX INSTALL - https://github.com/helmuthdu/aui"
  print_warning "USERNAME: ${username}"
  echo " 1) $(mainmenu_item "${checklist[1]}" "Basic Setup")"
  echo " 2) $(mainmenu_item "${checklist[2]}" "Desktop Environment|Window Manager")"
  echo " 3) $(mainmenu_item "${checklist[3]}" "Accessories Apps")"
  echo " 4) $(mainmenu_item "${checklist[4]}" "Development Apps")"
  echo " 5) $(mainmenu_item "${checklist[5]}" "Office Apps")"
  echo " 6) $(mainmenu_item "${checklist[6]}" "System Apps")"
  echo " 7) $(mainmenu_item "${checklist[7]}" "Graphics Apps")"
  echo " 8) $(mainmenu_item "${checklist[8]}" "Internet Apps")"
  echo " 9) $(mainmenu_item "${checklist[9]}" "Audio Apps")"
  echo "10) $(mainmenu_item "${checklist[10]}" "Video Apps")"
  echo "11) $(mainmenu_item "${checklist[13]}" "Fonts")"
  echo "12) $(mainmenu_item "${checklist[14]}" "International script input: M17n based IME")"
  echo "13) $(mainmenu_item "${checklist[15]}" "Extra")"
  echo "14) $(mainmenu_item "${checklist[16]}" "Clean Orphan Packages")"
  #Basic Setup
        add_custom_repositories
        install_basic_setup
        install_sound
        install_zsh
        install_ssh
        install_nfs
        install_samba
        install_tlp
        enable_readahead
        install_zram
        install_video_cards
        install_xorg
        font_config
        install_cups
        install_additional_firmwares
        checklist[1]=1
  #Desktop Environment|Window Manager
        install_display_manager
        install_nm_wicd
        install_usb_modem
        checklist[2]=1
  #Accessories Apps
        install_accessories_apps
        checklist[3]=1
  #Development Apps
        install_development_apps
        checklist[4]=1
  #Office Apps
        install_office_apps
        checklist[5]=1
  #System Apps
        install_system_apps
        checklist[6]=1

        install_graphics_apps
        checklist[7]=1

        install_internet_apps
        checklist[8]=1

        install_audio_apps
        checklist[9]=1

        install_video_apps
        checklist[10]=1

        install_themes
        #install_arcolinux
        checklist[11]=1

        checklist[12]=1

        #install_extra
        checklist[13]=1

        clean_orphan_packages
        checklist[14]=1
#}}}
