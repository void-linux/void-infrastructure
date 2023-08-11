FROM ghcr.io/peaceiris/mdbook:v0.3.7 as build

COPY . .
RUN mdbook build

FROM busybox:stable
WORKDIR /web
COPY --from=build /book/book .
ENTRYPOINT ["/bin/busybox", "httpd", "-f", "-p", "8080"]
