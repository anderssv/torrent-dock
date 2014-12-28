#!/bin/bash -eu

transmission-remote -t $TR_TORRENT_ID -r

if [[ ! $(transmission-remote -l | wc -l) -gt 2 ]]; then
	pgrep transmission | xargs kill
fi
