FROM ghcr.io/void-linux/void-glibc-full:latest AS build

RUN xbps-install -Suy xbps && xbps-install -uy git go

ARG GO_XBPS_SRC_VERSION=aed3b4682c7b2d1e31447cdb1de60e817e4dada1

RUN env GOBIN=/usr/local/bin GOMODCACHE=/tmp/go \
    go install -v github.com/Duncaen/go-xbps-src/cmd/xbps-src-make@$GO_XBPS_SRC_VERSION

FROM build AS buildbot-builder
RUN xbps-install -Suy xbps && xbps-install -uy python3 tini git curl bash make rsync
COPY --from=build /usr/local/bin/xbps-src-make /usr/local/bin/xbps-src-make
RUN rm -rf /var/cache/xbps /tmp/* && \
    groupadd --gid 418 void-builder && \
    useradd --uid 418 --gid 418 -G xbuilder -M -d /buildbot void-builder && \
    mkdir /venv /buildbot && \
    chown void-builder:void-builder /venv /buildbot
USER void-builder

# version must be synced with ../buildbot
ARG BUILDBOT_VERSION=4.2.1

RUN python3 -m venv /venv && \
	/venv/bin/pip3 install wheel && \
	/venv/bin/pip3 install 'buildbot-worker~='$BUILDBOT_VERSION
WORKDIR /buildbot
RUN mkdir -p /buildbot && \
    ln -sf /local/info /buildbot/info && \
    ln -sf /local/xbps-src.conf /buildbot/.xbps-src.conf
COPY buildbot.tac /buildbot/
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/venv/bin/buildbot-worker", "start", "--nodaemon", "/buildbot"]
