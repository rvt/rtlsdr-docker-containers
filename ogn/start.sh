#!/usr/bin/env bash


screen -d -m ./ogn-rf Station.conf
screen -d -m ./ogn-decode Station.conf

sleep 15

while true
do
    /wait-for-it.sh localhost:50010
    retVal=$?
    if [ $retVal -ne 0 ]; then
	echo "50010 dropped"
	exit 1
    fi
    sleep 5
done

