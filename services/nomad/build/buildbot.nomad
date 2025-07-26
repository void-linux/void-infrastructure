job "buildbot" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "buildbot" {
    network {
      mode = "bridge"
      hostname = "void-buildbot"

      port "http" {
        static = 8010
        to = 8010
      }

      port "metrics" { to = 9100 }

      port "worker" {
        to = 42042
        host_network = "internal"
      }
    }

    volume "buildbot_database" {
      type = "host"
      source = "buildbot_database"
      read_only = false
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    service {
      name = "buildbot-www"
      port = "http"

      check {
        type = "http"
        address_mode = "host"
        path = "/"
        timeout = "30s"
        interval = "5s"
      }
    }

    service {
      name = "buildbot-worker"
      port = "worker"
    }

    service {
      name = "buildbot-metrics"
      port = "metrics"
    }

    task "buildbot" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-buildbot:20251119R1"
        ports = ["http", "worker"]
      }

      resources {
        memory = 2048
      }

      meta {
        // set to "true" to create or upgrade the database when starting
        db-upgrade = "false"
      }

      volume_mount {
        volume = "buildbot_database"
        destination = "/db"
      }

      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      template {
        data = <<EOF
[buildbot]
worker-port = 42042
url = https://build.voidlinux.org/

[irc]
host = irc.libera.chat
nick = void-builder
channel = #xbps
authz = duncaen maldridge abby
EOF
        destination = "local/config.ini"
      }

      template {
        data = jsonencode({
          workers = [
            { name = "glibc",   max-builds = 4 },
            { name = "musl",    max-builds = 3 },
            { name = "aarch64", max-builds = 2 },
          ],
          builders = [
            { name = "x86_64",       host = "x86_64",                               worker = "glibc",  },
            { name = "i686",         host = "i686",                                 worker = "glibc",  },
            { name = "armv7l",       host = "x86_64",      target = "armv7l",       worker = "glibc",  },
            { name = "armv6l",       host = "x86_64",      target = "armv6l",       worker = "glibc",  },
            { name = "x86_64-musl",  host = "x86_64-musl",                          worker = "musl",   },
            { name = "armv7l-musl",  host = "x86_64-musl", target = "armv7l-musl",  worker = "musl",   },
            { name = "armv6l-musl",  host = "x86_64-musl", target = "armv6l-musl",  worker = "musl",   },
            { name = "aarch64",      host = "aarch64",                              worker = "aarch64" },
            { name = "aarch64-musl", host = "aarch64-musl",                         worker = "aarch64" },
          ],
        })
        destination = "local/workers.json"
      }

      template {
        data = file("buildbot.cfg")
        destination = "local/buildbot.cfg"
      }

      template {
        data = <<EOF
Void Linux Buildbot controller running on {{ env "attr.unique.hostname" -}}
EOF
        destination = "local/info/host"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/buildbot" -}}
{{ .webhook_secret }}
{{- end -}}
EOF
        destination = "secrets/buildbot/github-webhook"
        perms = "400"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/buildbot" -}}
{{ .irc_password }}
{{- end -}}
EOF
        destination = "secrets/buildbot/irc-password"
        perms = "400"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/buildbot-worker" -}}
{{ .worker_password }}
{{- end -}}
EOF
        destination = "secrets/buildbot/worker-password"
        perms = "400"
      }
    }
  }
}
