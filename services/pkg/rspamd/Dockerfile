FROM  ghcr.io/void-linux/void-musl-full:latest

RUN xbps-install -Suy xbps && xbps-install -y rspamd tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/etc/sv/rspamd/run"]
