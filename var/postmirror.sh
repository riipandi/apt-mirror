#!/bin/sh -e

DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)

APTDIR="/mnt/d/apt-mirror/mirror/kartolo.sby.datautama.net.id"

## Anything in this file gets run AFTER the mirror has been run.
## Put your custom post mirror operations in here (like rsyncing the installer
## files and running clean.sh automatically)!

## Example of grabbing the extra installer files from Ubuntu (Note: rsync needs
## to be installed and in the path for this example to work correctly)

#rsync --recursive --times --links --hard-links --delete --delete-after rsync://mirror.anl.gov/ubuntu/dists/trusty/main/debian-installer /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu/dists/trusty/main/
#rsync --recursive --times --links --hard-links --delete --delete-after rsync://mirror.anl.gov/ubuntu/dists/trusty/main/dist-upgrader-all/ /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu/dists/trusty/main/
#rsync --recursive --times --links --hard-links --delete --delete-after rsync://mirror.anl.gov/ubuntu/dists/trusty/main/installer-amd64/ /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu/dists/trusty/main/
#rsync --recursive --times --links --hard-links --delete --delete-after rsync://mirror.anl.gov/ubuntu/dists/trusty/main/installer-i386/ /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu/dists/trusty/main/

# Change sources.list to local apt sources list
if [ "$DISTRO" = "Ubuntu" ] ; then
  {
    echo "deb file://$APTDIR/ubuntu bionic main restricted universe multiverse"
    echo "deb file://$APTDIR/ubuntu bionic-updates main restricted universe multiverse"
    echo "deb file://$APTDIR/ubuntu bionic-security main restricted universe multiverse"
    echo "deb file://$APTDIR/ubuntu bionic-proposed main restricted universe multiverse"
  } > /etc/apt/sources.list
else
  {
    echo "deb file://$APTDIR/debian stretch main contrib non-free"
    echo "deb file://$APTDIR/debian stretch-updates main contrib non-free"
    echo "deb file://$APTDIR/debian-security stretch/updates main contrib non-free"
  } > /etc/apt/sources.list
fi

echo "Sources list changed to local, you can run apt-update..."
