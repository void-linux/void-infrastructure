FROM  ghcr.io/void-linux/void-linux:latest-thin-x86_64

RUN xbps-install -Sy tini sftpgo NetAuth-sftpgo-hook

ENV SFTPGO_HTTPD__TEMPLATES_PATH=/usr/share/sftpgo/templates \
        SFTPGO_HTTPD__STATIC_FILES_PATH=/usr/share/sftpgo/static \
        SFTPGO_DATA_PROVIDER__DRIVER=sqlite \
        SFTPGO_DATA_PROVIDER__NAME=/data/sftpgo.db \
        SFTPGO_SFTPD__HOST_KEYS=/secrets/id_rsa,/secrets/id_ecdsa,/secrets/id_ed25519 \
        SFTPGO_DATA_PROVIDER__EXTERNAL_AUTH_HOOK=/usr/libexec/sftpgo/netauth-hook \
        SFTPGO_NETAUTH_HOMEDIR=/data/home \
        SFTPGO_NETAUTH_REQUIREGROUP=sftpgo

ENTRYPOINT ["/usr/bin/tini", "/usr/bin/sftpgo", "serve"]
