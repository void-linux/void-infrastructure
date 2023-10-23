FROM ghcr.io/void-linux/void-glibc-full:latest

RUN xbps-install -Suy xbps && xbps-install -y tini mdBook rsync git && \
	rm -rf /var/cache/xbps

WORKDIR /mdbook
COPY build.sh build

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/mdbook/build"]
