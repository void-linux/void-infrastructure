FROM ghcr.io/void-linux/infra-nginx:20220909RC01

RUN xbps-install -Suy xbps && xbps-install -y void-man-cgi fcgiwrap spawn-fcgi && \
    rm -rf /var/cache/xbps && \
    mkdir -p /etc/runit/runsvdir/container/fcgi && \
    mkdir -p /run/runit/supervise.fcgi && \
    mkdir -p /run/runit/supervise.nginx && \
    mkdir -p /var/lib/man-cgi && \
    ln -s /run/runit/supervise.fcgi /etc/runit/runsvdir/container/fcgi/supervise && \
    ln -s /etc/sv/nginx /etc/runit/runsvdir/container/ && \
    for arch in x86_64 x86_64-musl armv7l armv7l-musl; do ln -s "/pages/$arch" "/var/lib/man-cgi/$arch"; done

COPY run.fcgi /etc/runit/runsvdir/container/fcgi/run
COPY root.conf /etc/nginx/locations.d/root.conf
COPY manpath.conf /var/lib/man-cgi/manpath.conf
COPY header.html /var/lib/man-cgi/header.html
COPY footer.html /var/lib/man-cgi/footer.html

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/runsvdir", "/etc/runit/runsvdir/container"]
