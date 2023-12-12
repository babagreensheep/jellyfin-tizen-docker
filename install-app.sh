#!/bin/bash

set -ex

if [ -z "$TV_IP" ]
then
  echo "TV_IP environment varaible is empty. Add it or overwrite the container entrypoint."
  exit 1
fi

sdb connect ${TV_IP}

DEVICE_ID=$(sdb devices | grep ${TV_IP} | tr -s ' ' | cut -d ' ' -f 3)

if [ -z "$DEVICE_ID" ]
then
  echo "Device ID not found. Perhaps TV_IP is invalid."
  exit 1
fi

tizen install -n Jellyfin.wgt -t ${DEVICE_ID}
