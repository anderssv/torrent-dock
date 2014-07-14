# Description

Creates a Docker container for a torrent with a OpenVPN tunnel.

Based on files at [https://github.com/firecat53/dockerfiles](https://github.com/firecat53/dockerfiles).

Pretty basic, so little error checking and stupid sleeps to enable VPN connections to be made.

# Prepare

If you're on a Ubuntu system, the nameserver will probably be set to ```127.0.0.1```. Check your ```/etc/resolv.conf``` to see if this applies.

Details and a solution can be [found here](http://docs.docker.com/installation/ubuntulinux/#docker-and-local-dns-server-warnings).

# Build

First you need to build the Docker image that will be used. Do this with the ```./build.sh``` command.

# Set up

* create an ```./vpn/auth.cfg``` containing VPN username on first line, password on second
* edit/replace server.ovpn

The server.ovpn that is checked in with this source is for Hide My Ass, Sweden.

# Run

```./run.sh <url/magnet>```

# Feed fetching

The ```scan.sh``` file can take an atom feed and download all links. Create a file called ```rss.url``` only containing the feed URL. It uses a simple text file to remember which links are already downloaded.