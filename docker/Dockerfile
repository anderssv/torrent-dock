FROM ubuntu:yakkety

MAINTAINER Anders Sveen <anders@f12.no>

RUN apt -q update && apt -qy upgrade && apt install -qy unzip software-properties-common 

RUN apt install -qy openvpn
RUN apt install -qy transmission-daemon transmission-remote-cli

ADD run.sh /run.sh
ADD shutdown.sh /shutdown.sh

VOLUME [ "/config", "/download" ]
EXPOSE 9091


ENTRYPOINT ["/run.sh"]