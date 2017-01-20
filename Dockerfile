FROM rethinkdb:2.3.5

MAINTAINER Norsk Nettarkiv

RUN apt-get update && \
    apt-get install -yq curl && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && \
    curl -L http://stedolan.github.io/jq/download/linux64/jq > /usr/bin/jq && \
    chmod u+x /usr/bin/jq && \
    curl -L https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb > dumb-init.deb && \
    dpkg -i dumb-init.deb && rm dumb-init.deb

ADD test.sh run.sh ready-probe.sh /usr/bin/

#CMD ["/usr/bin/dumb-init"]
#CMD ["/bin/bash /usr/bin/test.sh"]
#CMD ["/bin/bash /usr/bin/run.sh"]

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/bin/run.sh"]
