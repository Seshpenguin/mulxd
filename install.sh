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
install_dir=${1:-"/opt/mulxd"}

mkdir -p $install_dir
cp ./mulxd.sh $install_dir/mulxd.sh
cp ./motd.txt $install_dir/motd.txt
cp ./exempt.txt $install_dir/exempt.txt

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