FROM ghcr.io/void-linux/void-glibc:latest

RUN xbps-install -Sy rsync tini snooze findutils && \
        mkdir -p /etc/rsyncd.conf.d/ /local/rsync.conf.d/ && \
        rm -rf /var/cache/xbps

WORKDIR /srv/rsync
COPY rsyncd.conf /etc/rsyncd.conf
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/rsync", "--daemon", "--no-detach", "--config", "/etc/rsyncd.conf"]
