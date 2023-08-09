FROM ghcr.io/void-linux/void-musl-full:latest as build
ARG ALPS_REV=master
WORKDIR /alps
RUN xbps-install -Suy xbps && xbps-install -y git go ca-certificates curl tar file && \
    curl https://git.sr.ht/~migadu/alps/archive/${ALPS_REV}.tar.gz | tar --strip-components 1 -xvz -C . && \
    CGO_ENABLED=0 go build -o /tmp/alps ./cmd/alps/main.go && file /tmp/alps

FROM scratch
COPY --from=build /tmp/alps /alps
COPY --from=build /alps/themes /themes
COPY --from=build /etc/ssl /etc/ssl
ENTRYPOINT ["/alps", "-theme", "alps"]
