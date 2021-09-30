#!/bin/bash

file="/etc/fr24feed/fr24feed.ini"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '-' '_')
    eval ${key}=\${value//\\\"}
  done < "$file"

else
  echo "$file not found."
  sleep 10
  exit 1
fi

echo "Waiting for beasthost on ${host}"
./wait-for-it.sh ${host}

/usr/bin/fr24feed --config-file=/etc/fr24feed/fr24feed.ini
sleep 10
