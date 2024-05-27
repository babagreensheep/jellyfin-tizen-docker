FROM ubuntu:22.04 as build

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Poland

RUN apt-get update && apt-get upgrade -y && apt-get install -y tzdata && apt-get install -y wget git expect 

# Create user 
RUN useradd -m jellyfin -s /bin/bash
USER jellyfin

# Install tizen-studio
RUN wget https://download.tizen.org/sdk/Installer/tizen-studio_5.5/web-cli_Tizen_Studio_5.5_ubuntu-64.bin -P /home/jellyfin
RUN chmod a+x /home/jellyfin/web-cli_Tizen_Studio_5.5_ubuntu-64.bin
RUN ./home/jellyfin/web-cli_Tizen_Studio_5.5_ubuntu-64.bin --accept-license /home/jellyfin/tizen-studio
ENV PATH=${PATH}:/home/jellyfin/tizen-studio/tools/ide/bin:/home/jellyfin/tizen-studio/tools

ENV CERT_ALIAS="Jellyfin"
ENV CERT_PASSWORD="1234"
ENV CERT_COUNTRY="PL"
ENV CERT_NAME="Jellyfin"
ENV CERT_FILENAME="Jellyfin"

# Create certificates
RUN tizen certificate \
    -a ${CERT_ALIAS} \ 
    -p ${CERT_PASSWORD} \
    -c ${CERT_COUNTRY} \
    -ct ${CERT_COUNTRY} \
    -n ${CERT_NAME} \
    -f ${CERT_FILENAME}

CMD [ "/bin/bash" ]
