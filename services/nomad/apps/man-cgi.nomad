job "man-cgi" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "system"

  # FIXME: b-hel-fi is not currently syncing
  constraint {
    attribute = "${node.unique.name}"
    operator = "set_contains_any"
    value = "d-hel-fi,a-fra-de"
  }

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
        image = "ghcr.io/void-linux/infra-man-cgi:20250726R1"
      }

      volume_mount {
        volume = "dist_mirror"
        destination = "/mirror"
      }
    }
  }
}
