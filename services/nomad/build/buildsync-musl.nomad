job "buildsync-musl" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "lsyncd" {
    count = 1
    network { mode = "bridge" }

    volume "musl_hostdir" {
      type = "host"
      source = "musl_hostdir"
      read_only = true
    }

    task "rsync" {
      driver = "docker"

      vault {
        policies = ["void-secrets-buildsync"]
      }

      config {
        image = "ghcr.io/void-linux/infra-lsyncd:20230814"
      }

      volume_mount {
        volume = "musl_hostdir"
        destination = "/hostdir"
      }

      template {
        data = <<EOF
{{- with secret "secret/buildsync/musl" -}}
{{.Data.password}}
{{- end -}}
EOF
        destination = "secrets/rsync_passwd"
        perms = "0400"
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
    target = "rsync://buildsync-musl@a-fsn-de.node.consul:{{ .Port }}/musl",
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
        password_file = "/secrets/rsync_passwd",
        _extra = { "--delete-after" },
    }
}

sync {
    default.rsync,
    source = "/hostdir/sources",
    {{- range nomadService "build-rsyncd" -}}
    target = "rsync://buildsync-musl@a-fsn-de.node.consul:{{ .Port }}/sources",
    {{- end -}}
    delay = 15,
    rsync = {
        verbose = true,
        update = true,
        copy_dirlinks = true,
        password_file = "/secrets/rsync_passwd",
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
