#!/bin/bash -eu

source env.sh

docker run -d \
      -e "RSS_URL=$RSS_URL" \
      -e "TRANSMISSION_DOWNLOAD_DIR=/data/$RSS_DOWNLOAD_FOLDER" \
      --link transmission-vpn:transmission \
      --name transmission-rss \
      --restart unless-stopped \
      haugene/transmission-rss
