FROM  ghcr.io/void-linux/void-glibc:latest

RUN xbps-install -Sy && xbps-install -y lego vault binutils upx findutils diffutils && \
        strip /usr/bin/vault /usr/bin/lego && \
        upx /usr/bin/vault /usr/bin/lego && \
        xbps-remove -Roy binutils upx && \
        rm -rf /var/cache/xbps
WORKDIR /lego
ENV ACTION=renew
COPY lego.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
