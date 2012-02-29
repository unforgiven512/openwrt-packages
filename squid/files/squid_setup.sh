#!/bin/sh
# squid setup script for OpenWRT
# (c) 2012 Gerad Munsch <gmunsch@unforgivendevelopment.com>

## import common functions from OpenWRT's functions.sh ##
source /etc/functions.sh

## add squid user and group ##
# check for a free UID in the system user range (500-1000)
for UID in $(seq 300 1000)
do
    grep -q -e "^[^:]*:[^:]:$UID:" /etc/passwd || break
done
[ $UID -eq 1000 ] && { echo "ERROR: Could not find a suitable UID"; exit 1; }

# check for a free GID in the system group range (500-1000)
for GID in $(seq 300 1000)
do
    grep -q -e "^[^:]*:[^:]:$GID:" /etc/group || break
done
[ $GID -eq 1000 ] && { echo "ERROR: Could not find a suitable GID"; exit 1; }

# add new group entry
group_exists squid || group_add squid $GID

# add new user entry
user_exists squid || user_add squid $UID $GID squid /srv/squid-cache

## create cache directory ##
if [ ! -d /srv/squid-cache ]; then
    mkdir -p /srv/squid-cache
    chown squid:squid /srv/squid-cache
    chmod 0755 /srv/squid-cache
fi
