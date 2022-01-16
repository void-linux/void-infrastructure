job "debuginfod" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    volume "binpkgs" {
      type = "host"
      read_only = true
      source = "root-pkgs"
    }

    volume "debuginfod" {
      type = "host"
      read_only = false
      source = "debuginfod-data"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 8002
      }
    }

    service {
      name = "debuginfod"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.debuginfod.tls=true",
      ]

      check {
        type = "http"
        address_mode = "host"
        path = "/metrics"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "debuginfod" {
      driver = "docker"

      volume_mount {
        volume = "binpkgs"
        destination = "/binpkgs"
        read_only = true
      }

      volume_mount {
        volume = "debuginfod"
        destination = "/debuginfod"
        read_only = false
      }

      config {
        image = "voidlinux/debuginfod:20210316RC02"
        ports = ["http"]
        args = [
          "-vvv",
          "-d", "/debuginfod/db.sqlite",
          "-I", ".*-dbg-.*",
          "-X", "^linux.*",
          "-Z", ".xbps",
          "-c", "2",
          "/binpkgs",
        ]
      }

      resources {
        memory = 8000
        cpu = 6000
      }

      restart {
        attempts = 100
        delay = "30s"
      }
    }
  }
}
