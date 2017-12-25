#!/bin/bash -eu

source env.sh

mkdir -p ${DOWNLOAD_FOLDER}/transmission-home
cp remove_torrent.sh ${DOWNLOAD_FOLDER}/transmission-home/

docker run --cap-add=NET_ADMIN --device=/dev/net/tun -d \
              -v ${DOWNLOAD_FOLDER}:/data \
              -v /etc/localtime:/etc/localtime:ro \
              --dns 8.8.8.8 \
              --dns 8.8.8.4 \
              -e "TRANSMISSION_SCRIPT_TORRENT_DONE_ENABLED=true" \
              -e "TRANSMISSION_SCRIPT_TORRENT_DONE_FILENAME=/data/transmission-home/remove_torrent.sh" \
              -e "PUID=${VPN_UID}" \
              -e "PGID=${VPN_GID}" \
              -e "OPENVPN_PROVIDER=${VPN_PROVIDER}" \
              -e "OPENVPN_CONFIG=${VPN_CONFIG}" \
              -e "OPENVPN_USERNAME=${VPN_USERNAME}" \
              -e "OPENVPN_PASSWORD=${VPN_PASSWORD}" \
              -e "LOCAL_NETWORK=${LOCAL_NETWORK}" \
              -p 9091:9091 \
              haugene/transmission-openvpn
