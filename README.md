# MULXD

## What is it?
Multi User LXD (MULXD) is a program that when executed drops a user to a personal LXD container (or creates one).

For my use case, I needed to let multiple users connect to a single GNU/Linux server, but I wanted each of them to get a seperate LXD container (This is a shared server for my schools Computer Club).

MULXD is free software, GNU GPLv3 licensed.

## How do I use it?
If you want to have SSH users automatically use it, simply add a call to the "mulxd.sh" file in their "~/.bashrc" file. MULXD will be run when they connect, and create a container if the user doesn't have one already. Container names are the user's username.

The program accepts 3 arguments, the LXD image (default: "ubuntu:18.04"), the LXD Profile (default: "default"), and the shell to be used in the container (default: "/bin/bash"). 

There is also a supplied "install.sh" file which will copy the required files into a directory (default: "/opt/mulxd", can be changed with an argument). The installer can also add a call to MULXD in the default ".bashrc" for new users.

Make sure to have LXD setup on the server (lxc init). Users should have be in the LXD group.

The "motd.txt" file contains text that will be displayed to the user, and the exempt.txt is a list of users that will skip connecting to a container.

## Admin Commands
Pass the argument "admin" to "mulxd.sh" along with a subcommand:
* adduser [USERNAME]: Adds a new user to the system, and adds them to the "lxd" group.
* deluser [USERNAME]: Deletes a user and home folder, and removes their container.

For example, to add a user: 
```./mulxd.sh admin adduser testuser1```

## Note on Security
Use MULXD at your own risk. I designed it without much regard for security, since the users for my use case are trusted.

If you know how to make MULXD more secure, or found a security vulnerability, feel free to create a pull request or open an issue.
