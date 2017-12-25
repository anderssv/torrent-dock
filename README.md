**WARNING:** Just rewrote everything, so it's quite different than it used to be.

This setup uses [https://github.com/haugene/docker-transmission-openvpn](this Docker image) to launch
a Transmission web server to download torrents over VPN. The Docker image runs continuously, and can
be accessed through a browser at http://<your_ip>:9190 .

New torrents are added through transmission-remote commands when found.

# Config

Copy env.sh.template to env.sh and modify for your settings. See the launch-transmission.sh script and 
the docs for the haugane/docker-transmission-openvpn to figure out the options.

Add the RSS to scan for new links to a file called rss.url. I use https://showrss.info to generate mine.

# Running

Run scan_loop.sh to start scanning (remember to start the Docker container before), and adding the 
torrents from the Transmission server.

Already downloaded torrents will be added to download.txt, so erase it to reset state.
