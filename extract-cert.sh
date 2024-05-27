#!/bin/bash

set -ex

source .env.default

docker build \
    --build-arg CERT_ALIAS="$CERT_ALIAS" \
    --build-arg CERT_PASSWORD="$CERT_PASSWORD" \
    --build-arg CERT_COUNTRY="$CERT_COUNTRY" \
    --build-arg CERT_NAME="$CERT_NAME" \
    --build-arg CERT_FILENAME="$CERT_FILENAME" \
    -t tizen-cert cert

docker run -dit --rm --name tizen-cert tizen-cert
docker cp tizen-cert:/home/jellyfin/tizen-studio-data/keystore/author/"$CERT_FILENAME".p12 cert/"$CERT_FILENAME".p12
docker stop tizen-cert
