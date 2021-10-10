#!/usr/bin/env bash

file="/rtl_ais.conf"

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

/usr/local/bin/rtl_ais -n -p $ppm
