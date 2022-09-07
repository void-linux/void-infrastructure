FROM ghcr.io/void-linux/void-linux:latest-full-x86_64

RUN xbps-install -Suy xbps && xbps-install -y xmandump mdocml tini && \
	rm -rf /var/cache/xbps

WORKDIR /xmandump
COPY update update

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/xmandump/update"]
