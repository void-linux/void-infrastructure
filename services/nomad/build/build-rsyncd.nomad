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

    volume "glibc_hostdir" {
      type = "host"
      source = "glibc_hostdir"
      read_only = false
    }

    service {
      provider = "nomad"
      name = "build-rsyncd"
      port = "rsync"
    }

    task "rsyncd" {
      driver = "docker"

      vault {
        policies = ["void-secrets-buildsync"]
      }

      config {
        image = "ghcr.io/void-linux/infra-rsync:20230815"
        volumes = [ "local/buildsync.conf:/etc/rsyncd.conf.d/buildsync.conf" ]
      }

      volume_mount {
        volume = "glibc_hostdir"
        destination = "/hostdir"
      }

      template {
        data = file("xbps-clean-sigs")
        destination = "local/xbps-clean-sigs"
        perms = "0755"
      }

      template {
        data = <<EOF
{{- with secret "secret/buildsync/aarch64" -}}
buildsync-aarch64:{{.Data.password}}
{{- end -}}

{{- with secret "secret/buildsync/musl" -}}
buildsync-musl:{{.Data.password}}
{{- end -}}
EOF
        destination = "secrets/buildsync.secrets"
        perms = "0400"
      }

      template {
        data = <<EOF
[global]
uid = 992
gid = 991
secrets file = /secrets/buildsync.secrets
read only = yes
list = yes
transfer logging = true
timeout = 600
incoming chmod = D0755,F0644

[shadow]
path = /hostdir
exclude = - *-repodata.* - *-stagedata.* - .*

[sources]
path = /hostdir/sources
auth users = buildsync-*:rw

[aarch64]
path = /hostdir/binpkgs/aarch64
auth users = buildsync-aarch64:rw
filter = + */ + *-repodata + otime + *.xbps - *.sig - *.sig2 - *-repodata.* - *-stagedata.* - .*
post-xfer exec = /local/xbps-clean-sigs

[musl]
path = /hostdir/binpkgs/musl
auth users = buildsync-musl:rw
filter = + */ + *-repodata + otime + *.xbps - *.sig - *.sig2 - *-repodata.* - *-stagedata.* - .*
post-xfer exec = /local/xbps-clean-sigs
EOF
        destination = "local/buildsync.conf"
      }
    }
  }
}
