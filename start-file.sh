#! /bin/bash -eu

links="$(cat $1)"
downloaded_file="$1-downloaded.txt"

echo "Downloading links found in $1"

if [[ ! -e $downloaded_file ]]; then
	touch $downloaded_file 
fi

for link in $links; do
  echo " "
  echo " "
  echo " === Downloading $link ==="
  echo " "
  if [[ ! $(grep "$link" $downloaded_file) ]]; then
  	./start.sh "$link" "$HOME/Downloads/torrents"
  	echo $link >> $downloaded_file
  fi
done