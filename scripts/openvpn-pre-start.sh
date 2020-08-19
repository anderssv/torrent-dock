#!/bin/bash -eu

curl -o /etc/openvpn/nordvpn/se446.nordvpn.com.tcp443.ovpn https://downloads.nordcdn.com/configs/files/ovpn_legacy/servers/se446.nordvpn.com.tcp443.ovpn

cd /etc/openvpn/nordvpn

sed -i 's/^M$//' *.ovpn
sed -i 's=auth-user-pass=auth-user-pass /config/openvpn-credentials.txt=g' *.ovpn
sed -i 's/ping 15/inactive 3600\
ping 10/g' *.ovpn
sed -i 's/ping-restart 0/ping-exit 60/g' *.ovpn
sed -i 's/ping-timer-rem//g' *.ovpn

echo "Done with pre-script"
