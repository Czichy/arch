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
