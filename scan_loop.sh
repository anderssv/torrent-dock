#!/bin/bash -eu

tempfile=$(mktemp --tmpdir torrent_scan.XXXXXX)
downloaded_file="downloaded.txt"
download_target="$HOME/Downloads/torrent_auto/completed-series"
move_target="/mnt/nas/public/media/video/downloaded/series/"


if [[ ! -e $downloaded_file ]]; then
	touch $downloaded_file
fi

echo "Scanning for new torrents..."
while true; do
        links="$(curl -s $(cat rss.url) | grep -o '<link>[^<]*' | cut -c 7-)"
	for link in $links; do
	  if [[ ! $(grep "$link" $downloaded_file) ]]; then
		transmission-remote localhost:9091 --download-dir "/data/completed-series"
	  	transmission-remote localhost:9091 --add "$link"
		transmission-remote localhost:9091 --download-dir "/data/completed"
	  	echo $link >> $downloaded_file
	  	echo " - Added: $link"
	  	echo ""
	  fi
	done
        if [ "$(ls -A $download_target)" ]; then
		echo "Found completed files, moving..."
                mv $download_target/* $move_target
		echo "Moved!"
        fi
	echo -n "."
	sleep 60
done
