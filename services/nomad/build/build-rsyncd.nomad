job "build-rsyncd" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "rsync" {
    count = 1
    network {
      mode = "bridge"
      port "rsync" {
        to = 873
        host_network = "internal"
      }
    }

    volume "root_mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    service {
      provider = "nomad"
      name = "build-rsyncd"
      port = "rsync"
    }

    task "rsyncd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:20240709R1"
        volumes = [ "local/buildsync.conf:/etc/rsyncd.conf.d/buildsync.conf" ]
      }

      resources {
        memory = 1500
        memory_max = 3000
      }

      volume_mount {
        volume = "root_mirror"
        destination = "/mirror"
      }

      template {
        data = file("rsync-post-xfer")
        destination = "local/rsync-post-xfer"
        perms = "0755"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/buildsync" }}
buildsync:{{ .password }}
{{- end }}
EOF
        destination = "secrets/buildsync.secrets"
        perms = "0400"
      }

      template {
        data = <<EOF
[global]
uid = 418
gid = 418
secrets file = /secrets/buildsync.secrets
read only = yes
list = yes
transfer logging = true
timeout = 600
incoming chmod = D0755,F0644

[sources]
path = /hostdir/sources
filter = - by_sha256/ - .* - *.part
auth users = buildsync-*:rw

&merge /local/rsyncd.d
EOF
        destination = "local/buildsync.conf"
      }

      dynamic "template" {
        for_each = [
          "x86_64", "i686", "armv7l", "armv6l",
          "x86_64-musl", "armv7l-musl", "armv6l-musl",
          "aarch64", "aarch64-musl",
        ]

        content {
          data = <<EOF
[incoming-${template.value}]
path = /incoming/${template.value}
auth users = buildsync:rw
filter = + */ + *.xbps - *.sig - *.sig2 - *-repodata* - .*
post-xfer exec = /local/rsync-post-xfer
EOF
          destination = "local/rsyncd.d/${template.value}.conf.inc"
        }
      }
    }
  }
}
