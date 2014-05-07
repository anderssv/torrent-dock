# Requirements

* Pipeworks
* sudo apt-get install bridge-utils

# Run

sudo pipework br0 high_franklin 192.168.0.123/24

docker run -t -i --privileged -v /home/anderssv/source/docker-torrenter:/config torrenter /bin/bash