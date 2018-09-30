#!/bin/bash

# Installs MULXD into a directory (set with argument or defaults to /opt/mulxd)
echo "Installing Multi User LXD..."
install_dir=${1:-"/opt/mulxd"}

mkdir -p $install_dir
mv ./mulxd.sh $install_dir/mulxd.sh
mv ./motd.txt $install_dir/motd.txt
mv ./exempt.txt $install_dir/exempt.txt