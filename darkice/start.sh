#!/usr/bin/env bash

./wait-for-it.sh ${ICECAST_HOST}:${ICECAST_PORT}
./wait-for-it.sh ${PULSEAUDIO_HOST}:4713

if [ -w "darkice.cfg" ]
then
sed -i "s/ICECAST_SOURCE_PASSWORD/${ICECAST_SOURCE_PASSWORD}/g" darkice.cfg
sed -i "s/ICECAST_HOST/${ICECAST_HOST}/g" darkice.cfg
sed -i "s/ICECAST_PORT/${ICECAST_PORT}/g" darkice.cfg
#cat darkice.cfg | sed "s/ICECAST_SOURCE_PASSWORD/${ICECAST_SOURCE_PASSWORD}/g" | sed "s/ICECAST_HOST/${ICECAST_HOST}/g" | sed "s/ICECAST_PORT/${ICECAST_PORT}/g" | stdbuf -o 128KB cat > darkice.cfg
fi 

if [ -w "/etc/pulse/client.conf" ]
then
sed -i "s/PULSEAUDIO_HOST/${PULSEAUDIO_HOST}/g" /etc/pulse/client.conf
#cat /etc/pulse/client.conf | sed "s/PULSEAUDIO_HOST/${PULSEAUDIO_HOST}/g" | stdbuf -o 128KB cat > /etc/pulse/client.conf
fi 

echo "Starting darkice"
./darkice -v 10 -c darkice.cfg
echo "Ended darkice"
sleep 1
