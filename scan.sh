#! /bin/bash -eu

links="$(curl $(cat rss.url) | grep -o '<link>[^<]*' | cut -c 7-)"

tempfile=$(mktemp --tmpdir torrent_scan.XXXXXX)

for link in $links; do
  if [[ ! $(grep "$link" downloaded.txt) ]]; then
  	echo $link >> $tempfile
  fi
done

if [[ $(cat $tempfile | wc -l) -gt 0 ]]; then
	./start.sh $tempfile "$HOME/Downloads/torrent_auto"
fi

cat $tempfile >> downloaded.txt
rm $tempfile