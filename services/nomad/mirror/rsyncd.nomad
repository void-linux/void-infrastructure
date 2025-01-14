job "rsyncd" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "rsync" {
    network {
      mode = "host"
    }

    volume "dist-mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = true
    }

    task "rsyncd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:20250114R1"
        volumes = ["local/voidmirror.conf:/etc/rsyncd.conf.d/voidmirror.conf"]
        network_mode = "host"
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
