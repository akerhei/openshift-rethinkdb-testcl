FROM rethinkdb:2.3.5

MAINTAINER Norsk Nettarkiv

RUN apt-get update && \
    apt-get install -yq curl && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && \
    curl -L https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb > dumb-init.deb && \
    dpkg -i dumb-init.deb && rm dumb-init.deb

ADD ./jq /usr/bin/
ADD ./run.sh ./ready-probe.sh /
VOLUME /data

ENTRYPOINT ["/usr/bin/dumb-init", "/run.sh"]
