#! /bin/bash

function webAddress() {
	echo "http://$(ifconfig | grep 'inet addr' | grep 172.17 | cut -c21- | cut -f1 -d ' '):9091"
}

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
echo "Transmission started. Web available at: $(webAddress)"

sleep 5s

torrent_file="/download/torrent_download.list"
num_torrents=$(cat $torrent_file | wc -l)

echo "Adding $num_torrents torrents"
for torrent in $(cat /download/torrent_download.list); do
	transmission-remote -a $torrent
done

if [[ -e /config/transmission/trackers.conf ]]; then
	for ((ctr=1; ctr <= $num_torrents; ctr++ )); do
		for tracker in $(cat /config/transmission/trackers.conf | grep -v \#); do
			transmission-remote -t $ctr -td $tracker
			echo "Added $tracker as tracker"
		done
	done
fi

sleep 5s

# Enter a bash session if you need to debug
# bash

while [[ $(pgrep transmission) ]]; do
	clear
	echo "Transmission web is available at $(webAddress)"
	echo ""
	transmission-remote -l
	sleep 1s
done

echo "Transmission died, cleaning up!"

exit 0