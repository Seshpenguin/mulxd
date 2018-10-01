#!/bin/bash

# Copyright (C) 2018 Seshan Ravikumar
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Installs MULXD into a directory (set with argument or defaults to /opt/mulxd)
echo "Installing Multi User LXD..."

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Load the config file
source mulxd.cfg

read -p "Do you want to enable support for X11 (y/N)? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ "$use_x11" = true ] ; then
        echo 'Enabling X11 Support...'
        # Commands from: https://blog.simos.info/how-to-easily-run-graphics-accelerated-gui-apps-in-lxd-containers-on-your-ubuntu-desktop/
        echo "root:$UID:1" | sudo tee -a /etc/subuid /etc/subgid
        lxc profile create gui # create a profile to enable X11
        cat lxdguiprofile.txt | lxc profile edit gui
        lxc profile list # verify profile is there
        lxc profile show gui
    else
        echo "Error: Please enable use_x11 in mulxd.cfg first."
    fi
fi

install_dir=${1:-"/opt/mulxd"}
echo "Copying files..."
# Copy the files
mkdir -p $install_dir
cp ./mulxd.sh $install_dir/mulxd.sh
cp ./motd.txt $install_dir/motd.txt
cp ./exempt.txt $install_dir/exempt.txt
cp ./mulxd.cfg $install_dir/mulxd.cfg

echo "Done copying files."
read -p "Do you want to add MULXD to the default bashrc for new users (y/N)? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "# MULXD (https://github.com/Seshpenguin/mulxd)" >> /etc/skel/.bashrc
    echo "$install_dir/mulxd.sh" >> /etc/skel/.bashrc
    echo "exit" >> /etc/skel/.bashrc
    echo "Added autostart to /etc/skel/.bashrc"
fi

echo "Done!"
