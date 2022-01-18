job "mirror" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "services" {
    network {
      mode = "bridge"
      port "http" { to = 80 }
      port "rsync" {
        to = 873
        static = 873
      }
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
        ports = ["http"]
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/srv/www"
      }
    }

    task "rsync" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:v20210926rc01"
        ports = ["rsync"]
        volumes = ["local/voidmirror.conf:/etc/rsyncd.conf.d/voidmirror.conf"]
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/srv/rsync"
      }

      template {
        data = <<EOF
[voidlinux]
comment = Main Void Repository
path = /srv/rsync
read only = yes
list = yes
transfer logging = true
EOF
        destination = "local/voidmirror.conf"
      }
    }
  }
}
