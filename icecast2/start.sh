#!/bin/sh

xmlstarlet ed --inplace -u "/icecast/authentication/source-password" -v $ICECAST_SOURCE_PASSWORD /etc/icecast2/icecast.xml
xmlstarlet ed --inplace -u "/icecast/authentication/relay-password" -v $ICECAST_RELAY_PASSWORD /etc/icecast2/icecast.xml
xmlstarlet ed --inplace -u "/icecast/authentication/admin-user" -v $ICECAST_ADMIN_USER /etc/icecast2/icecast.xml
xmlstarlet ed --inplace -u "/icecast/authentication/admin-password" -v $ICECAST_ADMIN_PASSWORD /etc/icecast2/icecast.xml

icecast2 -n -c /etc/icecast2/icecast.xml
sleep 1
