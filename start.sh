#!/bin/bash

if [[ -z "$1" ]]; then
	echo "No torrent provided!"
	exit 1
fi

docker run -t -i --privileged -v /home/anderssv/source/docker-torrenter:/config torrenter $@