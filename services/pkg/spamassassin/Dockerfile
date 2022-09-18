FROM  ghcr.io/void-linux/void-linux:latest-full-x86_64-musl

RUN xbps-install -Suy xbps && xbps-install -y spamassassin tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/etc/sv/spamd/run"]
