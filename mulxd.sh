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
image="ubuntu:18.04" # LXD Image
profile="default" # LXD Profile
shell="/bin/bash" # Shell to use in the container

# Get the username (which is also container name)
user=$(whoami)

# Print the MOTD
cat motd.txt

# Check if user is using the admin command or not
if [[ $1 == "admin" ]]
then
    echo "Admin Commands coming soon"
else
    # check if user is exempt from connecting to a container
    if grep -Fxq "$user" exempt.txt
    then
        echo "Connecting to host instead, $user is exempt"
        sh
    else
        # Check if the user has a container already
        if lxc list -c n --format csv | grep -Fxq "$user"
        then
            # Connect user to their container.
            lxc exec $user -- $shell
        else
            # Create a container for the user (name is the unix username)
            echo "This is your first time connecting, please wait..."
            lxc launch $image -p $profile $user # Change this line to customize the user's container
            echo "Done!"
            # Connect user to new container.
            lxc exec $user -- $shell
        fi
    fi
fi



echo "Exited Container... Goodbye!"

