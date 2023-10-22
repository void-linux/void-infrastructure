job "buildsync" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [ "aarch64", "musl", ]
    labels = [ "buildsync-${group.value}" ]

    content {
      count = 1
      network { mode = "bridge" }

      dynamic "volume" {
        for_each = [ "${group.value}" ]
        labels = [ "${volume.value}_hostdir" ]

        content {
          type = "host"
          source = "${volume.value}_hostdir"
          read_only = true
        }
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
          volume = "${group.value}_hostdir"
          destination = "/hostdir"
        }

        template {
          data = <<EOF
{{- with secret "secret/buildsync/${group.value}" -}}
{{.Data.password}}
{{- end -}}
EOF
          destination = "secrets/rsync_passwd"
          perms = "0400"
        }

        template {
          data = <<EOF
{{ $allocID := env "NOMAD_ALLOC_ID" -}}
settings {
    statusFile = "/tmp/lsyncd.status",
    nodaemon = true,
}

sync {
    default.rsync,
    source = "/hostdir/binpkgs",
    {{- range nomadService 1 $allocID "build-rsyncd" -}}
    target = "rsync://buildsync-${group.value}@{{ .Address }}:{{ .Port }}/${group.value}",
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
    {{- range nomadService 1 $allocID "build-rsyncd" -}}
    target = "rsync://buildsync-${group.value}@{{ .Address }}:{{ .Port }}/sources",
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
}
