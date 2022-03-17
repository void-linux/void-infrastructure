FROM  ghcr.io/void-linux/void-linux:latest-thin-x86_64

RUN xbps-install -Sy rsync tini snooze && \
        mkdir -p /etc/rsyncd.conf.d/ && \
        rm -rf /var/cache/xbps

WORKDIR /srv/rsync
COPY rsyncd.conf /etc/rsyncd.conf
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/rsync", "--daemon", "--no-detach", "--config", "/etc/rsyncd.conf"]
