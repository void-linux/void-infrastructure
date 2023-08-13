job "buildsync-aarch64" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "lsyncd" {
    count = 1
    network { mode = "bridge" }

    volume "hostdir" {
      type = "host"
      source = "aarch64_hostdir"
      read_only = true
    }

    task "rsync" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-lsyncd:20230814"
      }

      volume_mount {
        volume = "hostdir"
        destination = "/hostdir"
      }

      template {
        data = <<EOF
settings {
    statusFile = "/tmp/lsyncd.status",
    nodaemon = true,
}

sync {
    default.rsync,
    source = "/hostdir/binpkgs",
    {{- range nomadService "build-rsyncd" -}}
    target = "rsync://a-fsn-de.node.consul:{{ .Port }}/pkgs/aarch64",
    {{- end -}}
    delay = 15,
    filter = {
        "+ */",
        "+ *-repodata",
        "+ *.xbps",
        "+ otime",
        "- .*",
        "- *",
    },
    rsync = {
        verbose = true,
        update = true,
        copy_dirlinks = true,
        _extra = { "--delete-after" },
    }
}
EOF
        destination = "local/lsyncd.conf"
        perms = "0644"
      }
    }
  }
}
