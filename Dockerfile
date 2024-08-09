FROM ubuntu:22.04

ARG LIQUIDSOAP_VERSION=2.1.4
ARG LIQUIDSOAP_DEB_URL=https://github.com/savonet/liquidsoap/releases/download/v2.1.4/liquidsoap_2.1.4-ubuntu-jammy-1_amd64.deb

LABEL maintainer="Raitis Rolis <raitis.rolis@gmail.com>"

ENV DEBIAN_FRONTEND "noninteractive"

# RUN apt -qq -y update && apt -qq -y install --no-install-recommends software-properties-common
# RUN apt-add-repository multiverse

RUN apt -qq -y update && apt -qq -y install --no-install-recommends \
    sudo rsync unzip wget curl git ffmpeg pulseaudio python3 python-is-python3 ca-certificates \
    python3-brotli yt-dlp \
    && update-ca-certificates -f

RUN useradd -s /usr/bin/bash -m liquidsoap;

RUN curl -L ${LIQUIDSOAP_DEB_URL} -o ./liquidsoap.deb && apt -y install ./liquidsoap.deb

RUN rm -rf /var/lib/apt/lists/* \
    && apt clean \
    && apt autoremove

USER liquidsoap

RUN liquidsoap --version

WORKDIR /home/liquidsoap

EXPOSE 1234 8000
ENTRYPOINT ["liquidsoap"]
CMD ["/home/liquidsoap/config/radio.liq"]
