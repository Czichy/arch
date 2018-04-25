#!/bin/bash
#set -e
if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi
#THEMES {{{
install_system_apps(){
  aur_package_install "arc-gtk-theme-git"
  aur_package_install "conky-aureola"
  aur_package_install "downgrade"
  aur_package_install "inxi"
  aur_package_install "neofetch"
  aur_package_install "numix-circle-icon-theme-git"
  aur_package_install "pamac-aur"
  aur_package_install "paper-icon-theme-git"
  aur_package_install "papirus-icon-theme-git"
  aur_package_install "screenkey"
  aur_package_install "surfn-icons-git"

  #git clone https://github.com/addy-dclxvi/gtk-theme-collections ~/.themes

  aur_package_install "ttf-font-awesome"
  aur_package_install "ttf-mac-fonts"
  aur_package_install "virtualbox-for-linux-kernel"
  aur_package_install "xcursor-breeze"

# these come last always
  aur_package_install "hardcode-fixer-git"
  sudo hardcode-fixer

echo "################################################################"
echo "####    Software from Arch Linux Repository installed     ######"
echo "################################################################"
}
#}}}
