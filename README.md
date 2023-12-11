# Jellyfin for Tizen through Docker
Made this single container to build and deploy jellyfin to Samsung TVs.

## Credits
Credits go to the following:
- https://github.com/jellyfin/jellyfin-tizen
- https://www.reddit.com/r/jellyfin/comments/s0438d/build_and_deploy_jellyfin_app_to_samsung_tizen/

## Prequisites
- Docker
- Internet connection for the Docker containers

## How to use
1. Enable developer mode on the TV (adapted from [official tizen guide](https://developer.samsung.com/tv/develop/getting-started/using-sdk/tv-device)):
   - Turn on the TV
   - Go to the apps page
   - Press `12345` on the remote
   - Enable `Developer mode` in the dialog that pops up, and write the IP of the host running docker
   - Shut down and restart the TV as instructed by the information screen, re-enter the apps page
   - There should be (or could be, depending on the model) a big red text in the top bar saying `Developer mode`
   - Keep the TV on
2. Build the application
   ```
   docker build -t jellyfin .
   ```
3. Deploy the application to the TV:
   - Run the container passing IP of the TV as an environment variable
     ```
     docker run --rm --env TV_IP=<your.tv.ip> jellyfin
     ```
