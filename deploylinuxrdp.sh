#!/bin/bash

# deployrdplinux.sh
# this is a sample script to check Azure VM customscript extension
# this script install xubuntu and xrdp

# Installation of curl for logging
until apt-get -y update && apt-get -y install curl xubuntu-desktop xrdp
do
  log "Lock detected on VM init Try again..."
  sleep 2
done
