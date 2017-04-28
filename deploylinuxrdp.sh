#!/bin/bash

# deployrdplinux.sh
# this is a sample script to check Azure VM customscript extension
# this script install xubuntu and xrdp

#!/bin/bash

# deployrdplinux.sh
# this is a sample script to check Azure VM customscript extension
# this script install xubuntu and xrdp

# Installation of curl for logging, ubuntu-desktop, xubuntu-desktop and xrdp
until apt-get -y update && apt-get -y install curl ubuntu-desktop xubuntu-desktop xrdp
do
  log "Lock detected on VM init Try again..."
  sleep 2
done

echo xfce4-session >~/.xsession

# sudo vi /etc/xrdp/startwm.sh
# Add line xfce4-session before the line /etc/X11/Xsession.
