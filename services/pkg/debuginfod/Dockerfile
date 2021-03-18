FROM ghcr.io/void-linux/void-linux:20210312rc01-mini-bb-x86_64-musl
RUN xbps-install -Sy debuginfod && \
        rm -rf /var/cache/xbps
WORKDIR /debuginfod
ENTRYPOINT ["/usr/bin/debuginfod"]
CMD ["-d", "/debuginfod/db.sqlite", "-I", ".*-dbg-.*", "-X", "^linux.*", "-Z", ".xbps", "/binpkgs"]
