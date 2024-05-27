#!/bin/bash

set -ex

if [ -z "$TV_IP" ]; then
    echo "TV_IP variable is required!"
    exit 1
fi

source .env.default

docker build \
    --build-arg CERT_PASSWORD="$CERT_PASSWORD" \
    --build-arg CERT_NAME="$CERT_NAME" \
    --build-arg CERT_FILENAME="$CERT_FILENAME" \
    --build-arg JELLYFIN_BRANCH="$JELLYFIN_BRANCH" \
    -t jellyfin-tizen-installer .

docker run --rm --env TV_IP="$TV_IP" jellyfin-tizen-installer
