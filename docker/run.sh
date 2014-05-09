#! /bin/bash

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

echo "Initiating OpenVPN connection"
openvpn --writepid /var/run/openvpn.pid --daemon --status /var/run/openvpn.status 10 --cd /config/vpn --config /config/vpn/server.ovpn

echo "Waiting for VPN connection..."
sleep 10s
# TODO loop and wait, not just random seconds

if [[ ! $(ifconfig | grep tun0) ]]; then
	echo "ERROR: VPN not connected!!!"
	exit 1
fi

echo "Starting Transmission download"

transmission-cli --config-dir /config/transmission --finish /shutdown.sh --download-dir /download $@

sleep 5s

while [ $(pgrep transmission) ]; do
	sleep 5s
done

echo "Transmission died, cleaning up!"