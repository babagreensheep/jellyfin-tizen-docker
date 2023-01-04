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
   docker build --network host -t jellyfin .
   ```
   If it fails to execute `expect.sh` in the last step, you might need to [download it again from here](https://github.com/babagreensheep/jellyfin-tizen-docker/blob/master/expect.sh) and overwrite the one in the directory from which you're building.
3. Deploy the application to the TV:
   - Run the container with the attached terminal
     ```
     docker run -it --rm jellyfin
     ```
   - Connect to TV with Device Manager from Tizen Studio. Or with sdb.
     ```sh
     sdb connect YOUR_TV_IP
     ```
   - Find your device ID using:
     ```
     sdb devices
     ```
     The device ID will be the last column, something like `UE65NU7400`.
   - Install package
     ```sh
     tizen install -n Jellyfin.wgt -t DEVICE_ID
     ```
