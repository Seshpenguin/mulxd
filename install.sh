#!/bin/bash

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