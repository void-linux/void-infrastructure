FROM ghcr.io/void-linux/void-glibc:latest

RUN xbps-install -Suy xbps && xbps-install -y xq-api tini && \
	rm -rf /var/cache/xbps

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/xq-api", "-listen", "0.0.0.0:8197", "-reload-every", "5m", "/mirror"]
