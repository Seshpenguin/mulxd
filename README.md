# MULXD

## What is it?
Multi User LXD (MULXD) is a program that when executed drops a user to a personal LXD container (or creates one).

For my use case, I needed to let multiple users connect to a single GNU/Linux server, but I wanted each of them to get a seperate LXD container.

MULXD is free software, GNU GPLv3 licensed.

## How do I use it?
If you want to have SSH users automatically use it, simply add a call to the "mulxd.sh" file in their ~/.bashrc file. MULXD will be run when they connect, and create a container if the user doesn't have one already. Container names are the user's username.

Make sure to have LXD setup on the server (lxc init). Users should have be in the LXD group.

## Admin Commands
Coming Soon.

## Note on Security
Use MULXD at your own risk. I designed it without much regard for security, since the users for my use case are trusted.

If you know how to make MULXD more secure, or found a security vulnerability, feel free to create a pull request or open an issue.
