FROM ubuntu:saucy

MAINTAINER Anders Sveen <anders@f12.no>

RUN apt-get -q update && apt-get install -qy --force-yes unzip openvpn software-properties-common && apt-get -qy --force-yes upgrade

RUN add-apt-repository ppa:transmissionbt/ppa
RUN apt-get -q update && apt-get install -qy --force-yes transmission-daemon

ADD run.sh /run.sh

VOLUME [ "/config" ]

CMD ["/run.sh"]