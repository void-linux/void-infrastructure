FROM  ghcr.io/void-linux/void-linux:latest-thin-x86_64

RUN xbps-install -Sy rsync tini

WORKDIR /srv/rsync
COPY rsyncd.conf /etc/rsyncd.conf
ENTRYPOINT ["/usr/bin/tini", "rsync", "--", "--daemon", "--no-detach", "--config", "/etc/rsyncd.conf"]
