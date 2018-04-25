#!/bin/bash
set -e
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
