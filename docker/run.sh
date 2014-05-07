#! /bin/bash

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

echo "Initiating OpenVPN connection"
openvpn --writepid /var/run/openvpn.pid --daemon --status /var/run/openvpn.status 10 --cd /config --config /config/server.ovpn

sleep 5s
if [[ ! $(ifconfig | grep tun0) ]]; then
	echo "ERROR: VPN not connected!!!"
	exit 1
fi

echo "Starting Transmission download"

transmission-cli -f /shutdown.sh $@

sleep 5s

while [ $(pgrep transmission) ]; do
	sleep 5s
done

echo "Transmission died, cleaning up!"