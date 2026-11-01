job "vmlogs" {
  name        = "vmlogs"
  type        = "service"
  namespace   = "monitoring"
  datacenters = ["VOID"]

  group "vmlogs" {
    count = 1

    network {
      mode = "bridge"
      port "http" { static = 9428 }
      port "syslog" { static = 514 }
    }

    service {
      provider = "nomad"
      name     = "vmlogs"
      port     = "http"

      tags = [
        "nginx_enable",
        "nginx_names=vmlogs.voidlinux.org",
      ]
    }

    volume "vmlogs_data" {
      type      = "host"
      source    = "vmlogs_data"
      read_only = "false"
    }

    task "vmlogs" {
      driver = "docker"

      config {
        image = "docker.io/victoriametrics/victoria-logs:v1.15.0-victorialogs"
        args = [
          "-storageDataPath=/data",
          "-syslog.listenAddr.tcp=:514",
          "-syslog.listenAddr.udp=:514",
        ]
      }

      volume_mount {
        volume      = "vmlogs_data"
        destination = "/data"
      }
    }
  }
}
