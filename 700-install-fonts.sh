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
 # exit 1
#fi

#FONTS {{{
install_fonts(){

    package_install "adobe-source-sans-pro-fonts"
    package_install "cantarell-fonts"
    package_install "noto-fonts"
    package_install "terminus-font"
    package_install "ttf-bitstream-vera"
    package_install "ttf-dejavu"
    package_install "ttf-droid"
    package_install "ttf-inconsolata"
    package_install "ttf-liberation"
    package_install "ttf-roboto"
    package_install "ttf-ubuntu-font-family"
    package_install "tamsyn-font"

    [ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
    echo "Copy fonts to .fonts"
    cp Personal/settings/fonts/* ~/.fonts/
    echo "Building new fonts into the cache files";
    echo "Depending on the number of fonts, this may take a while..."
    fc-cache -fv ~/.fonts

    echo "################################################################"
    echo "####             Fonts have been installed                  ####"
    echo "################################################################"
}
#}}}
