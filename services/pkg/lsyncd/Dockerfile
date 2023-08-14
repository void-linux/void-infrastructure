FROM  ghcr.io/void-linux/void-musl:latest

RUN xbps-install -Sy lsyncd tini && rm -rf /var/cache/xbps

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/lsyncd", "-nodaemon", "/local/lsyncd.conf"]
