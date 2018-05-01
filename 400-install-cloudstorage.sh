#!/bin/bash
# if [[ -f `pwd`/sharedfuncs.sh ]]; then
#   source sharedfuncs.sh
# else
#   echo "missing file: sharedfuncs"
#   exit 1
# fi

#CLOUD STORAGE {{{
install_cloud_storage(){
  package_install "curl sqlite dmd"
  aur_package_install "onedrive-git"
  systemctl --user enable onedrive
  systemctl --user start onedrive
  package_install "java-openjfx"
  aur_package_install "cryptomator"
}
#}}}
