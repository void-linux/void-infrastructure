job "build-rsyncd" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "rsync" {
    count = 1
    network {
      mode = "bridge"
      port "rsync" { to = 873 }
    }

    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
      read_only = false
    }

    service {
      provider = "nomad"
      name = "build-rsyncd"
      port = "rsync"
    }

    task "rsyncd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:20230815"
        volumes = [ "local/buildsync.conf:/etc/rsyncd.conf.d/buildsync.conf" ]
      }

      volume_mount {
        volume = "root-pkgs"
        destination = "/pkgs"
      }

      template {
        data = file("xbps-clean-sigs")
        destination = "local/xbps-clean-sigs"
        perms = "0755"
      }

      template {
        data = <<EOF
[pkgs]
path = /pkgs
uid = 992
gid = 991
read only = no
list = yes
transfer logging = true
timeout = 600
incoming chmod = D0755,F0644
filter = + */ + *-repodata + otime + *.xbps - *.sig - *.sig2 - *-repodata.* - *-stagedata.* - .*
post-xfer exec = /local/xbps-clean-sigs
EOF
        destination = "local/buildsync.conf"
      }
    }
  }
}
