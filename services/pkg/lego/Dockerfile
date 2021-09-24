FROM  ghcr.io/void-linux/void-linux:latest-thin-x86_64

RUN xbps-install -Sy && xbps-install -y lego vault binutils upx findutils diffutils && \
        strip /usr/bin/vault && upx /usr/bin/vault && \
        xbps-remove -Roy binutils upx && \
        rm -rf /var/cache/xbps
WORKDIR /lego
ENV ACTION=renew
COPY lego.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
