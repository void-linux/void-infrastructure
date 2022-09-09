job "man-cgi" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "service"

  group "man-cgi" {
    count = 1

    volume "manpages" {
      type = "host"
      source = "manpages"
      read_only = true
    }

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    service {
      name = "man-cgi"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.man-cgi.tls=true",
        "traefik.http.routers.man-cgi.rule=Host(`man.voidlinux.org`)",
      ]
    }

    task "man-cgi" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-man-cgi:20220910RC01"
      }

      volume_mount {
        volume = "manpages"
        destination = "/pages"
      }
    }
  }
}
