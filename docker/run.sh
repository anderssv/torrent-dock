#! /bin/bash

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

if [[ ! -e /config/vpn ]]; then
	echo "ERROR: Could not find vpn config directory at '/config/vpn' . Something might be wrong with the Docker mount of paths?"
	exit 1
fi

echo "Initiating OpenVPN connection"
openvpn --writepid /var/run/openvpn.pid --daemon --status /var/run/openvpn.status 10 --cd /config/vpn --config /config/vpn/server.ovpn

echo "Waiting for VPN connection..."
sleep 10s
# TODO loop and wait, not just random seconds

if [[ ! $(ifconfig | grep tun0) ]]; then
	echo "ERROR: VPN not connected!!!"
	exit 1
fi

echo "Starting Transmission daemon"

# Set up settings and user
cp /config/transmission/settings.json /etc/transmission-daemon/settings.json
cp /config/transmission/transmission-daemon.conf /etc/init/transmission-daemon.conf
cp /config/transmission/transmission-daemon.init /etc/init.d/transmission-daemon

# Start
service transmission-daemon start
sleep 5s
transmission-remote --torrent-done-script /shutdown.sh

echo "Transmission started should addresses:"
echo "$(ifconfig | grep inet)"

echo "Adding torrent"
transmission-remote -a $@

if [[ -e /config/transmission/trackers.conf ]]; then
	for tracker in $(cat /config/transmission/trackers.conf | grep -v \#); do
		transmission-remote -t 1 -td $tracker
		echo "Added $tracker as tracker"
	done
fi

sleep 5s

# Enter a bash session if you need to debug
# bash

while [[ $(pgrep transmission) ]]; do
	sleep 5s
done

echo "Transmission died, cleaning up!"