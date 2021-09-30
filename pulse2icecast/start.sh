#!/usr/bin/env bash


sed -i "s/ICECAST_SOURCE_PASSWORD/${ICECAST_SOURCE_PASSWORD}/g" darkice.cfg

#while true; do
    echo "Starting darkice"
    darkice -c darkice.cfg
    sleep 1
#done
