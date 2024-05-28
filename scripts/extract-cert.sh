#!/bin/bash

set -e

source .env.default

if [ -f "cert/${CERT_FILENAME}.p12" ]; then
    read -rp "Certificate file will be overwritten. Do you want to proceed? (y/n) " yn  
    case $yn in 
	y ) echo Continuing...;;
	n ) echo Exiting...;
		exit;;
	* ) echo Invalid choice;
		exit 1;;
    esac
fi

echo "Building docker image for certificate"
docker build \
    --build-arg CERT_ALIAS="$CERT_ALIAS" \
    --build-arg CERT_PASSWORD="$CERT_PASSWORD" \
    --build-arg CERT_COUNTRY="$CERT_COUNTRY" \
    --build-arg CERT_NAME="$CERT_NAME" \
    --build-arg CERT_FILENAME="$CERT_FILENAME" \
    -t tizen-cert cert

echo "Starting docker container"
docker run -dit --rm --name tizen-cert tizen-cert

echo "Copying certificate file to cert/${CERT_FILENAME}.p12"
docker cp tizen-cert:/home/jellyfin/tizen-studio-data/keystore/author/"$CERT_FILENAME".p12 cert/"$CERT_FILENAME".p12

echo "Discarding container"
docker stop tizen-cert
