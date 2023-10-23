job "sync" {
  type = "sysbatch"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  periodic {
    crons = ["* * * * *"]
    prohibit_overlap = true
  }

  group "rsync" {
    count = 1

    network { mode = "bridge" }

    volume "dist-mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = false
    }

    task "rsync" {
      leader = true
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:v20220316RC02"
        command = "/usr/bin/rsync"
        args = [
          "-vurk",
          "--delete-after",
          "--links",
          "rsync://${env["RSYNC_ADDR"]}/shadow/",
          "/mirror/",
        ]
      }

      template {
        data=<<EOF
{{ $allocID := env "NOMAD_ALLOC_ID" -}}
{{ range nomadService 1 $allocID "shadow-rsyncd" }}
RSYNC_ADDR="{{ .Address }}:{{ .Port }}"
{{ end }}
EOF
        destination = "local/env"
        env = true
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "dist-mirror"
        destination = "/mirror"
      }
    }
  }
}
