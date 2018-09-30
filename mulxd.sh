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

# -- Settings --
image=${1:-"ubuntu:18.04"} # LXD Image
profile=${1:-"default"} # LXD Profile
shell=${1:-"/bin/bash"} # Shell to use in the container

# Get the username (which is also container name)
user=$(whoami)
# Get the install directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"



# Check if user is using the admin command or not
if [[ $1 == "admin" ]]
then
    echo "-- MULXD Admin Commands --" # make sure the user is root
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 
        exit 1
    fi
    case "$2" in
        "adduser")  echo "Adding user $3"
            adduser $3
            usermod -aG lxd $3 # add user to the LXD Group
            echo "Done adding user!"
            ;;
        "deluser")  echo  "Deleting user $3"
            lxc stop $3
            lxc delete $3
            deluser --remove-home $3
            echo "Done deleting user!"
            ;;
        *) echo "Unknown command: $2"
            ;;
    esac
else
    # check if user is exempt from connecting to a container
    if grep -Fxq "$user" $DIR/exempt.txt
    then
        echo "MULXD: Connecting to host instead, $user is exempt"
        bash
    else
        # Print the MOTD
        cat $DIR/motd.txt

        # Check if the user has a container already
        if lxc list -c n --format csv | grep -Fxq "$user"
        then
            # Connect user to their container.
            lxc exec $user -- $shell
        else
            # Create a container for the user (name is the unix username)
            echo "This is your first time connecting, please wait..."
            lxc launch $image -p $profile $user
            echo "Done!"
            # Connect user to new container.
            lxc exec $user -- $shell
        fi
    fi
fi

echo "Exited... Goodbye!"

