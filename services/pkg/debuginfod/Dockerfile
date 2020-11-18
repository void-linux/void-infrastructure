FROM voidlinux/voidlinux-musl:20201117RC01
RUN xbps-install -Sy debuginfod && \
        rm -rf /var/cache/xbps
WORKDIR /debuginfod
ENTRYPOINT ["/usr/bin/debuginfod"]
CMD ["-d", "/debuginfod/db.sqlite", "-I", ".*-dbg-.*", "-Z", ".xbps", "/binpkgs"]
