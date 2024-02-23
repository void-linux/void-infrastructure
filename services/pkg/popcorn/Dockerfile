FROM ghcr.io/void-linux/void-glibc:20231230R1

RUN xbps-install -Suy xbps && xbps-install -y PopCorn-Server && \
    rm -rf /var/cache/xbps

CMD ["/bin/sh"]
