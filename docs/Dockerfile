FROM ghcr.io/peaceiris/mdbook:v0.3.7 as build

COPY . .
RUN mdbook build

FROM busybox:stable
LABEL org.opencontainers.image.source https://github.com/void-linux/void-infrastructure
WORKDIR /web
COPY --from=build /book/book .
ENTRYPOINT ["/bin/busybox", "httpd", "-f", "-p", "8080"]
