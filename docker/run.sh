#! /bin/bash

function webAddress() {
	echo "http://$(ifconfig | grep 'inet addr' | grep 172.17 | cut -c21- | cut -f1 -d ' '):9091"
}

function addTorrents() {
	local torrent_file="$1"

	echo "Adding torrents"
	for torrent in $(cat $torrent_file); do
		transmission-remote -a $torrent
	done

	if [[ -e /config/transmission/trackers.conf ]]; then
		# TODO This adds to all torrents again, so should probably find a way to only add to the new ones
		for torrent_id in $(transmission-remote -l | tr -s ' ' | grep -o '^[ ]*[0-9]\{1,3\}'); do
			for tracker in $(cat /config/transmission/trackers.conf | grep -v \#); do
				transmission-remote -t $torrent_id -td $tracker
				echo "Added $tracker as tracker to torrent $ctr"
			done
		done
	fi	
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

addTorrents "/download/torrent_download.list"

sleep 5s

# Enter a bash session if you need to debug
# bash

while [[ $(pgrep transmission) ]]; do
	clear
	echo "Transmission web is available at $(webAddress)"
	echo ""
	transmission-remote -l
	sleep 1s

	new_torrents_file="/download/new_torrents.list"
	if [[ -e $new_torrents_file ]]; then
		addTorrents $new_torrents_file
		rm $new_torrents_file
	fi
done

echo "Transmission died, cleaning up!"

exit 0