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

docker run -t -i --privileged --dns 8.8.8.8 -v $(pwd):/config -v $DOWNLOAD_FOLDER:/download torrenter $@