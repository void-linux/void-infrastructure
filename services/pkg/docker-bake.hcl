target "docker-metadata-action" {}

target "_common" {
  inherits = ["docker-metadata-action"]
  dockerfile = "Dockerfile"
  no-cache-filter = ["bootstrap"]
  cache-to = ["type=local,dest=/tmp/buildx-cache"]
  cache-from = ["type=local,src=/tmp/buildx-cache"]
}

target "_common-glibc" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/386", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
  args = { "LIBC" = "glibc" }
}

target "_common-musl" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
  args = { "LIBC" = "musl" }
}

target "infra-alps" {
  inherits = ["_common-musl"]
  context = "services/pkg/alps/"
}

target "infra-buildbot" {
  inherits = ["_common"]
  platforms = ["linux/amd64"]
  args = { "LIBC" = "glibc" }
  context = "services/pkg/buildbot/"
}

target "infra-buildbot-builder" {
  inherits = ["_common"]
  platforms = ["linux/amd64"]
  args = { "LIBC" = "glibc" }
  context = "services/pkg/buildbot-builder/"
}

target "infra-debuginfod" {
  inherits = ["_common-musl"]
  context = "services/pkg/debuginfod/"
}

target "infra-lsyncd" {
  inherits = ["_common-musl"]
  context = "services/pkg/lsyncd/"
}

target "infra-man-cgi" {
  inherits = ["infra-nginx"]
  context = "services/pkg/man-cgi/"
}

target "infra-mdbook" {
  inherits = ["_common-glibc"]
  context = "services/pkg/mdbook/"
}

target "infra-nginx" {
  inherits = ["_common-glibc"]
  context = "services/pkg/nginx/"
}

target "infra-popcorn" {
  inherits = ["_common-glibc"]
  context = "services/pkg/popcorn/"
}

target "infra-rspamd" {
  inherits = ["_common-musl"]
  context = "services/pkg/rspamd/"
}

target "infra-rsync" {
  inherits = ["_common-glibc"]
  context = "services/pkg/rsync/"
}

target "infra-sftpgo" {
  inherits = ["_common-glibc"]
  context = "services/pkg/sftpgo/"
}

target "infra-xlocate" {
  inherits = ["_common-glibc"]
  context = "services/pkg/xlocate/"
}

target "infra-xmandump" {
  inherits = ["_common-glibc"]
  context = "services/pkg/xmandump/"
}

target "infra-xq-api" {
  inherits = ["_common-glibc"]
  context = "services/pkg/xq-api/"
}
