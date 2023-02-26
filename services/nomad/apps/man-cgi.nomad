job "man-cgi" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "system"

  group "man-cgi" {
    count = 1

    volume "dist_mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = true
    }

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    service {
      name = "man-cgi"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "man.voidlinux.org"
      }
    }

    task "man-cgi" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-man-cgi:20230226RC01"
      }

      volume_mount {
        volume = "dist_mirror"
        destination = "/mirror"
      }
    }
  }
}
