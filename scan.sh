#!/bin/bash -eu

links="$(curl $(cat rss.url) | grep -o '<link>[^<]*' | cut -c 7-)"
tempfile=$(mktemp --tmpdir torrent_scan.XXXXXX)
downloaded_file="downloaded.txt"

if [[ ! -e $downloaded_file ]]; then
	touch $downloaded_file
fi

for link in $links; do
  if [[ ! $(grep "$link" $downloaded_file) ]]; then
  	echo $link >> $tempfile
  fi
done

if [[ $(cat $tempfile | wc -l) -gt 0 ]]; then
	./start.sh $tempfile "$HOME/Downloads/torrent_auto"
elif [[ -e "torrents.list" ]]; then
	./start.sh torrents.list
fi

cat $tempfile >> $downloaded_file
rm $tempfile