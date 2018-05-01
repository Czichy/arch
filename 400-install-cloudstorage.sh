#!/bin/bash
# if [[ -f `pwd`/sharedfuncs.sh ]]; then
#   source sharedfuncs.sh
# else
#   echo "missing file: sharedfuncs"
#   exit 1
# fi

#CLOUD STORAGE {{{
install_cloud_storage(){
  sudo pacman -Sy --noconfirm dmd
  yaourt -S onedrive-git
  systemctl --user enable onedrive
  systemctl --user start onedrive
  onedrive
  sudo pacman -Sy ..noconfirm java-openjfx
  yaourt -S cryptomator
}
#}}}

install_clod_storage
