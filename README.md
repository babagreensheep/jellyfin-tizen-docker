# Maintainers
Looking for maintainers to take over!! 

# Jellyfin installer for Tizen OS through Docker
Made this single container to build and deploy jellyfin to Samsung TVs.

## Credits
Credits go to the following:
- https://github.com/jellyfin/jellyfin-tizen
- https://www.reddit.com/r/jellyfin/comments/s0438d/build_and_deploy_jellyfin_app_to_samsung_tizen/

## Prequisites
- Docker
- Internet connection for the Docker images

## How to use

### TV preparation
1. Enable developer mode on the TV (adapted from [official tizen guide](https://developer.samsung.com/tv/develop/getting-started/using-sdk/tv-device)):
  - Turn on the TV
  - Go to the apps page
  - Press `12345` on the remote
  - Enable `Developer mode` in the dialog that pops up, and write the IP of the host running docker
  - Shut down and restart the TV as instructed by the information screen, re-enter the apps page
  - There should be (or could be, depending on the model) a big red text in the top bar saying `Developer mode`
  - Keep the TV on

### Jellyfin - the easy way
Simply run:
```
TV_IP=<IP of your TV> ./install-jellyfin.sh
```

Example:
```
TV_IP=192.168.0.10 ./install-jellyfin.sh
```

### Jellyfin - the custom way

1. (Optional) Create your custom tizen certificate (see details below).

2. Build the image providing required build arguments.
   ```
    docker build \
        --build-arg CERT_PASSWORD="$CERT_PASSWORD" \
        --build-arg CERT_NAME="$CERT_NAME" \
        --build-arg CERT_FILENAME="$CERT_FILENAME" \
        --build-arg JELLYFIN_BRANCH="$JELLYFIN_BRANCH" \
        -t jellyfin-tizen-installer .
   ```
3. Deploy the application to the TV:
  - Run the container passing IP of the TV as an environment variable
    ```
    docker run --rm --env TV_IP=<your.tv.ip> jellyfin-tizen-installer
    ```
  - OR run the container overwriting the entrypoint for more control over the installation
    ```
    docker run -it --rm --entrypoint "/bin/bash" jellyfin-tizen-installer
    ``` 

### Cert

Repository includes dummy certificate to allow reinstalling the app without removing it first.
You may use the provided one or generate your own. Here's how:

```
./extract-cert.sh
```

*Note:* you may overwrite default certificate data by amending values in `.env.default`.

