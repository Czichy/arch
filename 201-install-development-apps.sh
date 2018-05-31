#!/bin/bash

#DEVELOPEMENT {{{
install_development_apps(){
         aur_package_install "qtwebkit-bin"
         #package_install "atom"
         #package_install "emacs"
         package_remove "vim"
	       # package_install "geany"
         package_install "gvim ctags"
         package_install "meld"
         # aur_package_install "sublime-text2"
         # aur_package_install "sublime-text-dev"
         aur_package_install "android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform"
         package_install "android-tools android-udev libmtp"
         #  add_user_to_group ${username} sdkusers
         #  chown -R :sdkusers /opt/android-sdk/
         #  chmod -R g+w /opt/android-sdk/
         #  add_line "export ANDROID_HOME=/opt/android-sdk" "/home/${username}/.bashrc"
         #  aur_package_install "android-studio"
         package_install "intellij-idea-community-edition"
         #package_install "qtcreator"
         #aur_package_install "mysql-workbench"
         #package_remove "jdk"
         #package_install "jdk8-openjdk"
         #package_remove "jdk"
         #package_install "jdk9-openjdk"
         #package_remove "jdk"
         #package_install "jdk10-openjdk"
         #package_remove "jre{7,8,9,10}-openjdk"
         #package_remove "jdk{7,8,9,10}-openjdk"
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
}
#}}}
