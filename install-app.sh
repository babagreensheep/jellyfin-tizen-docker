#!/bin/bash

if [ -z "$TV_IP" ]
then
  echo "\$TV_IP is empty!"
  exit 1
fi


sdb connect ${TV_IP}

DEVICE_ID=$(sdb devices | grep ${TV_IP} | tr -s ' ' | cut -d ' ' -f 3)

tizen install -n Jellyfin.wgt -t ${DEVICE_ID}
