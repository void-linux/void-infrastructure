FROM  ghcr.io/void-linux/void-glibc:latest

RUN xbps-install -Syu xbps && xbps-install -yu && \
    xbps-install -Sy tini sftpgo NetAuth-sftpgo-hook rsync

ENTRYPOINT ["/usr/bin/tini", "/usr/bin/sftpgo", "serve"]
