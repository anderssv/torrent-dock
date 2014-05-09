#! /bin/bash -eu

links="$(curl $(cat rss.url) | grep -o '<link>[^<]*' | cut -c 7-)"

for link in $links; do
  if [[ ! $(grep "$link" downloaded.txt) ]]; then
  	./start.sh "$link" "$HOME/Downloads/torrent_auto"
  	echo $link >> downloaded.txt
  fi
done