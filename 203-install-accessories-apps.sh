#!/bin/bash
#ACCESSORIES {{{
install_accessories_apps(){
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
}
#}}}
