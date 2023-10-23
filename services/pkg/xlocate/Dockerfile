FROM ghcr.io/void-linux/void-glibc-full:latest

RUN xbps-install -Suy xbps && xbps-install -y xtools tini && \
	rm -rf /var/cache/xbps

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/xlocate", "-g"]
