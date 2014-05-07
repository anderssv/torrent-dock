#! /bin/sh

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

echo "Initiating OpenVPN connection"
openvpn --writepid /var/run/openvpn.pid --daemon --status /var/run/openvpn.status 10 --cd /config --config /config/server.ovpn
