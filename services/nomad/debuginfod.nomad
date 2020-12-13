job "debuginfod" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    volume "binpkgs" {
      type = "host"
      read_only = true
      source = "root_binpkgs"
    }

    volume "debuginfod" {
      type = "host"
      read_only = false
      source = "debuginfod"
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
        image = "voidlinux/debuginfod:20201118RC01"
        ports = ["http"]
      }

      resources {
        memory = 4000
        cpu = 10000
      }
    }
  }
}
