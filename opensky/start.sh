#!/bin/bash


file="/var/lib/openskyd/conf.d/10-debconf.conf"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    if [[ $key =~ ^[a-zA-Z].* ]];
    then
        key=$(echo $key | tr '-' '_')
	eval ${key}=\${value//\\\"}
    fi
  done < "$file"

else
  echo "$file not found."
  sleep 10
  exit 1
fi

echo "Waiting for beasthost on ${Host}:${Port}"
./wait-for-it.sh ${Host}:${Port}

/usr/bin/openskyd-dump1090
sleep 10
