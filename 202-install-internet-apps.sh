#!/bin/bash
#INTERNET {{{
install_internet_apps(){
    print_title "INTERNET APPS"
            print_title "BROWSER"
            	  aur_package_install "google-chrome"
                  package_install "chromium"
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
}
#}}}
