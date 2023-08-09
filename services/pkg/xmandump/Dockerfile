FROM ghcr.io/void-linux/void-glibc-full:latest

RUN xbps-install -Suy xbps && xbps-install -y xmandump mdocml tini && \
	rm -rf /var/cache/xbps

WORKDIR /xmandump
COPY update update

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/xmandump/update"]
