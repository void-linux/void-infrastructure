FROM ghcr.io/void-linux/infra-nginx:20230812

RUN xbps-install -Suy xbps && xbps-install -y void-man-cgi fcgiwrap spawn-fcgi && \
    rm -rf /var/cache/xbps && \
    mkdir -p /etc/runit/runsvdir/container/fcgi && \
    mkdir -p /run/runit/supervise.fcgi && \
    mkdir -p /run/runit/supervise.nginx && \
    mkdir -p /var/lib/man-cgi && \
    ln -s /run/runit/supervise.fcgi /etc/runit/runsvdir/container/fcgi/supervise && \
    ln -s /etc/sv/nginx /etc/runit/runsvdir/container/ && \
    for arch in x86_64 x86_64-musl armv7l armv7l-musl; do ln -s "/mirror/man/$arch" "/var/lib/man-cgi/$arch"; done

COPY run.fcgi /etc/runit/runsvdir/container/fcgi/run
COPY nginx.conf /etc/nginx/sites.d/00-default.conf
COPY manpath.conf /var/lib/man-cgi/manpath.conf
COPY head.html /var/lib/man-cgi/head.html
COPY header.html /var/lib/man-cgi/header.html
COPY footer.html /var/lib/man-cgi/footer.html
COPY void.css /var/lib/man-cgi/void.css

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/runsvdir", "/etc/runit/runsvdir/container"]
