FROM ghcr.io/void-linux/void-musl-busybox:latest
RUN xbps-install -Sy debuginfod && \
        rm -rf /var/cache/xbps
WORKDIR /debuginfod
ENTRYPOINT ["/usr/bin/debuginfod"]
CMD ["-d", "/debuginfod/db.sqlite", "-I", ".*-dbg-.*", "-X", "^linux.*", "-Z", ".xbps", "/binpkgs"]
