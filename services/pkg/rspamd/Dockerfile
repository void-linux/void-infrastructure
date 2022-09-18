FROM  ghcr.io/void-linux/void-linux:latest-full-x86_64-musl

RUN xbps-install -Suy xbps && xbps-install -y rspamd tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/etc/sv/rspamd/run"]
