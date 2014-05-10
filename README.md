# Description

Creates a Docker container for a torrent with a OpenVPN tunnel.

Based on files at [https://github.com/firecat53/dockerfiles](https://github.com/firecat53/dockerfiles).

Pretty basic, so little error checking and stupid sleeps to enable VPN connections to be made.

# Build

Firs you need to build the Docker image that will be used. Do this with the ```./build.sh``` command.

# Set up

* create an auth.cfg containing VPN username on first line, password on second
* edit/replace server.ovpn

The server.ovpn that is checked in with this source is for Hide My Ass, Sweden.

# Run

```./run.sh <url/magnet>```

# Feed fetching

The ```scan.sh``` file can take an atom feed and download all links. Create a file called ```rss.url``` only containing the feed URL. It uses a simple text file to remember which links are already downloaded.