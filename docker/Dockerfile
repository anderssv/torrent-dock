FROM ubuntu:saucy

MAINTAINER Anders Sveen <anders@f12.no>

RUN apt-get -q update && apt-get install -qy --force-yes unzip software-properties-common && apt-get -qy --force-yes upgrade

RUN apt-get install -qy --force-yes openvpn
RUN apt-get install -qy --force-yes transmission-cli

ADD run.sh /run.sh
ADD shutdown.sh /shutdown.sh

VOLUME [ "/config" ]

ENTRYPOINT ["/run.sh"]