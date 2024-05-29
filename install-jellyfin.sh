#!/bin/bash

set -e

if [ -z "$TV_IP" ]; then
    echo "TV_IP variable is required!"
    exit 1
fi

source .env.default

if [ ! -f "cert/${CERT_FILENAME}.p12" ]; then
    echo "Creating new Tizen certificate"
    ./scripts/extract-cert.sh
else 
    echo "Using cert/${CERT_FILENAME}.p12 as Tizen certificate"
fi

echo "Building docker image"
docker build \
    --build-arg CERT_PASSWORD="$CERT_PASSWORD" \
    --build-arg CERT_NAME="$CERT_NAME" \
    --build-arg CERT_FILENAME="$CERT_FILENAME" \
    --build-arg JELLYFIN_BRANCH="$JELLYFIN_BRANCH" \
    -t jellyfin-tizen-installer .

echo "Installing Jellyfin"
docker run --rm --env TV_IP="$TV_IP" jellyfin-tizen-installer

