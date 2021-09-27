job "mirror" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "http" {
    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = true
    }

    service {
      name = "mirror-${node.unique.name}"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.mirror-${node.unique.name}.tls=true",
        "traefik.http.routers.mirror-${node.unique.name}.rule=HostRegexp(`repo.voidlinux.org`, `{subdomain:repo-[a-z]{2}}.voidlinux.org`)",
      ]
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-nginx:v20210926rc01"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/srv/www"
      }
    }
  }
}
