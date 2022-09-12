FROM ubuntu:22.04

RUN apt-get update; apt-get -y upgrade; apt-get clean
RUN DEBIAN_FRONTEND=noninteractive TZ=Singapore apt-get -y install tzdata
RUN apt-get -qq install -y git openssh-server
RUN apt-get install -y sudo
RUN apt-get install -y curl
RUN apt-get -y install expect

# install node JS & update
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm update

# Create user to install tizen-studio
RUN useradd -m jellyfin -s /bin/bash

# Copy tizen-studio executable
USER jellyfin
RUN wget https://download.tizen.org/sdk/Installer/tizen-studio_4.6/web-cli_Tizen_Studio_4.6_ubuntu-64.bin -P /home/jellyfin

# Execute tizen-studio executable
RUN chmod a+x /home/jellyfin/web-cli_Tizen_Studio_4.6_ubuntu-64.bin
RUN ./home/jellyfin/web-cli_Tizen_Studio_4.6_ubuntu-64.bin --accept-license /home/jellyfin/tizen-studio

# Add export path
ENV PATH=${PATH}:/home/jellyfin/tizen-studio/tools/ide/bin:/home/jellyfin/tizen-studio/tools

# Create certificates
RUN tizen \
    certificate \
        -a Jellyfin \
        -p 1234 \
        -c SG \
        -ct SG \
        -n Jellyfin \  
        -f Jellyfin

# Load profile
RUN tizen \
    security-profiles add \
        -n Jellyfin \
        -a /home/jellyfin/tizen-studio-data/keystore/author/Jellyfin.p12 \
        -p 1234

# Switch passwords
RUN sed -i 's/\/home\/jellyfin\/tizen-studio-data\/keystore\/author\/Jellyfin.pwd//' /home/jellyfin/tizen-studio-data/profile/profiles.xml
RUN sed -i 's/\/home\/jellyfin\/tizen-studio-data\/tools\/certificate-generator\/certificates\/distributor\/tizen-distributor-signer.pwd/tizenpkcs12passfordsigner/' /home/jellyfin/tizen-studio-data/profile/profiles.xml

# Git clone apps
RUN git clone https://github.com/jellyfin/jellyfin-web.git /home/jellyfin/jellyfin-web
RUN git clone https://github.com/jellyfin/jellyfin-tizen.git /home/jellyfin/jellyfin-tizen

# Build apps

# patch as per https://github.com/jellyfin/jellyfin-tizen/issues/103
RUN sed -i 's/var t="subtitles-octopus-worker.data/var t="file:\/\/\/opt\/usr\/apps\/AprZAARz4r\/res\/wgt\/www\/libraries\/subtitles-octopus-worker.data/g' /home/jellyfin/jellyfin-web/dist/libraries/subtitles-octopus-worker.js 
RUN sed -i 's/var t="subtitles-octopus-worker-legacy.data/var t="file:\/\/\/opt\/usr\/apps\/AprZAARz4r\/res\/wgt\/www\/libraries\/subtitles-octopus-worker-legacy.data/g' /home/jellyfin/jellyfin-web/dist/libraries/subtitles-octopus-worker-legacy.js 

WORKDIR /home/jellyfin/jellyfin-web
RUN npm ci --no-audit
WORKDIR /home/jellyfin/jellyfin-tizen
ENV JELLYFIN_WEB_DIR=/home/jellyfin/jellyfin-web/dist
RUN npm ci --no-audit

RUN tizen build-web -e ".*" -e gulpfile.js -e README.md -e "node_modules/*" -e "package*.json" -e "yarn.lock"

COPY --chown=jellyfin ./expect.sh /home/jellyfin/jellyfin-tizen/expect.sh
RUN chmod a+x /home/jellyfin/jellyfin-tizen/expect.sh

RUN ./expect.sh

ENV TV_IP=127.0.0.1

# ENTRYPOINT ["tail", "-f", "/dev/null"]
