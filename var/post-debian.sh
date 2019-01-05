#!/bin/sh -e

## Anything in this file gets run AFTER the mirror has been run.
## Put your custom post mirror operations in here (like rsyncing the installer
## files and running clean.sh automatically)!

SRC_BASE="rsync://deb.debian.org/debian/dists"
DEST_BASE="/var/spool/apt-mirror/mirror/deb.debian.org/debian/dists"

repo="stretch stretch-proposed-updates"
arch="amd64 i386"

for _repo in ${repo}; do
  for _arch in ${arch}; do
    /usr/bin/rsync --archive --verbose --compress --delete ${SRC_BASE}/${_repo}/main/installer-${_arch}/ ${DEST_BASE}/${_repo}/main/installer-${_arch}
  done
done

repo="stretch stretch-backports stretch-proposed-updates stretch-updates"
section="contrib main non-free"

for _repo in ${repo}; do
  for _section in ${section}; do
    if [ -d ${DEST_BASE}/${_repo}/${_section} ]; then
      cd ${DEST_BASE}/${_repo}/${_section}
      if [ ! -d i18n ]; then
        mkdir i18n
      fi
      cd i18n
      rm -rf Translation-en*
      wget -q http://deb.debian.org/debian/dists/${_repo}/${_section}/i18n/Translation-en.bz2
      cd ../../
    fi
  done
done
