# Jellyfin for Tizen through Docker
Made this single container to build and deploy jellyfin to Samsung TVs.
## Credits
Credits go to the following:
- https://github.com/jellyfin/jellyfin-tizen
- https://www.reddit.com/r/jellyfin/comments/s0438d/build_and_deploy_jellyfin_app_to_samsung_tizen/
## Prequisites
- Docker
- ...Internet?
## How to use
1. Build the docker image
```
docker build -t jellyfin .
```
2. Run the container with attached terminal
```
docker run -it --rm jellyfin
```
3. Deploy to TV ()
    1. Run TV.
    2. Activate Developer Mode on TV (<a href="https://developer.samsung.com/tv/develop/getting-started/using-sdk/tv-device">https://developer.samsung.com/tv/develop/getting-started/using-sdk/tv-device</a>).
    3. Connect to TV with Device Manager from Tizen Studio. Or with sdb.
    ```sh
    sdb connect YOUR_TV_IP
    ```
    4. `Permit to install applications` on your TV
    5. Install package.
    ```sh
    tizen install -n Jellyfin.wgt -t UE65NU7400
    ```
    > Specify target with `-t` option. Use `sdb devices` to list them.