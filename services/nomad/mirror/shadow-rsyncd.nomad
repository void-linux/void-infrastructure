job "shadow-rsyncd" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "mirror"

  group "rsync" {
    count = 1
    network {
      mode = "bridge"
      port "rsync" {
        to = 873
        host_network = "internal"
      }
    }

    volume "root_mirror" {
      type = "host"
      source = "root_mirror"
      read_only = true
    }

    volume "glibc_hostdir" {
      type = "host"
      source = "glibc_hostdir"
      read_only = true
    }

    service {
      provider = "nomad"
      name = "shadow-rsyncd"
      port = "rsync"
    }

    task "rsyncd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:20230815"
        volumes = [ "local/shadowsync.conf:/etc/rsyncd.conf.d/shadowsync.conf" ]
      }

      volume_mount {
        volume = "root_mirror"
        destination = "/mirror"
      }

      volume_mount {
        volume = "glibc_hostdir"
        destination = "/hostdir"
      }

      template {
        data = <<EOF
[global]
uid = 992
gid = 991
read only = yes
list = yes
transfer logging = true
timeout = 600

[mirror]
path = /mirror
exclude = - *-repodata.* - *-stagedata.* - .*

[sources]
path = /hostdir/sources
exclude = - .*
EOF
        destination = "local/shadowsync.conf"
      }
    }
  }
}
