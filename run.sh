#! /bin/sh

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

echo "Initiating OpenVPN connection"
openvpn --writepid /var/run/openvpn.pid --daemon --status /var/run/openvpn.status 10 --cd /config --config /config/server.ovpn

echo "Starting Transmission download"

transmission-cli -f /shutdown.sh magnet:?xt=urn:btih:9bc21e6a74f20f9fedd55419417753838d4036cd&dn=Elementary+S02E22+HDTV+x264-LOL+%5Beztv%5D&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.istole.it%3A6969&tr=udp%3A%2F%2Ftracker-ccc.de%3A6969&tr=udp%3A%2F%2Fopen.demonii.com%3A1337

sleep 5s

while [ $(pgrep transmission) ]; do
	sleep 5s
done

echo "Transmission died, cleaning up!"