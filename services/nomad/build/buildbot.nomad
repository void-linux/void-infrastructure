job "buildbot" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "buildbot" {
    network {
      mode = "bridge"
      hostname = "void-buildbot"

      // TODO: static only for testing
      // port "http" { to = 8010 }
      port "http" { static = 8010 }

      port "metrics" { to = 9100 }

      // TODO: add when deploying
      port "worker" { /* host_network = "internal" */ }
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
      // TODO: can't be nomad with meta {}
      provider = "nomad"
      name = "buildbot-www"
      port = "http"

      // TODO
      // meta {
      //   nginx_enable = "true"
      //   nginx_names = "build.voidlinux.org"
      // }

      check {
        type = "http"
        address_mode = "host"
        path = "/"
        timeout = "30s"
        interval = "5s"
      }
    }

    service {
      provider = "nomad"
      name = "buildbot-worker"
      port = "worker"
    }

    service {
        // TODO: remove
        provider = "nomad"
        name = "buildbot-metrics"
        port = "metrics"
    }

    task "buildbot" {
      driver = "docker"

      config {
        // TODO: proper image name and version
        image = "localhost:5000/infra-buildbot:latest"
        force_pull = true
        ports = ["http", "worker"]
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
worker-port = {{ env "NOMAD_PORT_worker" }}
# TODO
#url = http://build.voidlinux.org/

[irc]
host = irc.libera.chat
# TODO
# nick = void-builder
# channel = #xbps
# authz = duncaen maldridge abby
nick = abby-testbot
channel = ###abby-testbot
authz = duncaen maldridge abby
EOF
        destination = "local/config.ini"
      }

      template {
            //{ name = "armv7l",       host = "x86_64",      target = "armv7l",       worker = "glibc"                        },
            //{ name = "armv6l",       host = "x86_64",      target = "armv6l",       worker = "glibc"                        },
            //{ name = "armv7l-musl",  host = "x86_64-musl", target = "armv7l-musl",  worker = "musl"                         },
            //{ name = "armv6l-musl",  host = "x86_64-musl", target = "armv6l-musl",  worker = "musl"                         },
        data = jsonencode({
          workers = [
            { name = "glibc",   max-builds = 4 },
            { name = "musl",    max-builds = 3 },
            { name = "aarch64", max-builds = 2 },
          ],
          builders = [
            { name = "x86_64",       host = "x86_64",                               worker = "glibc"                        },
            { name = "i686",         host = "i686",                                 worker = "glibc"                        },
            { name = "x86_64-musl",  host = "x86_64-musl",                          worker = "musl"                         },
            { name = "aarch64",      host = "x86_64",      target = "aarch64",      worker = "aarch64", bootstrap_args = "" },
            { name = "aarch64-musl", host = "x86_64-musl", target = "aarch64-musl", worker = "aarch64", bootstrap_args = "" },
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
