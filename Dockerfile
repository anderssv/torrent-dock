FROM ubuntu:saucy

MAINTAINER Anders Sveen <anders@f12.no>

RUN apt-get -q update && apt-get install -qy --force-yes unzip openvpn software-properties-common && apt-get -qy --force-yes upgrade

#RUN add-apt-repository ppa:transmissionbt/ppa
#RUN apt-get -q update && apt-get install -qy --force-yes transmission-daemon

RUN apt-get install -qy --force-yes transmission-cli

ADD run.sh /run.sh
ADD shutdown.sh /shutdown.sh

VOLUME [ "/config" ]

CMD ["/run.sh"]