#!/bin/bash

if [[ -z "$1" ]]; then
	echo "No torrent provided!"
	exit 1
fi

DOWNLOAD_FOLDER=${2:-"$HOME/Downloads"}

if [[ ! -e $DOWNLOAD_FOLDER ]]; then
	mkdir -p $DOWNLOAD_FOLDER
fi

# Make sure new files will be assigned users group. Docker containers run as root, so 
# any files created will be owned by root. 
chmod g+s $DOWNLOAD_FOLDER

download_list=$DOWNLOAD_FOLDER/torrent_download.list

if [[ ! -e $1 ]]; then
	echo "$1" > $download_list
else
	cp $1 $download_list
fi

docker run -t -i --privileged -v $(pwd):/config -v $DOWNLOAD_FOLDER:/download torrenter

rm $download_list