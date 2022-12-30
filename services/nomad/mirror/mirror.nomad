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

    volume "dist-mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = true
    }

    service {
      name = "mirror-${meta.mirror_region}"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.mirror-${meta.mirror_region}.tls=true",
        "traefik.http.routers.mirror-${meta.mirror_region}.rule=Host(`repo-${meta.mirror_region}.voidlinux.org`)",
      ]
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-nginx:20220804RC02"
        volumes = ["local/compat-layout.conf:/etc/nginx/locations.d/compat-layout.conf"]
      }

      volume_mount {
        volume = "dist-mirror"
        destination = "/srv/www"
      }

      template {
        data = file("compat-layout.conf")
        destination = "local/compat-layout.conf"
      }
    }

    task "rsync" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:v20210926rc01"
        volumes = ["local/voidmirror.conf:/etc/rsyncd.conf.d/voidmirror.conf"]
      }

      volume_mount {
        volume = "dist-mirror"
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
timeout = 600
exclude = - .* - *-repodata.* - *-stagedata.*
EOF
        destination = "local/voidmirror.conf"
      }
    }
  }
}
