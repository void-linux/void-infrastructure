job "build-mirror" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "busybox" {
    network {
      mode = "host"
      port "http" {
        to = 80
        static = 80
      }
    }

    service {
      name = "root-pkgs-internal"
      port = "http"
    }

    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
      read_only = true
    }

    task "httpd" {
      driver = "docker"

      config {
        image = "busybox:1.32-musl"
        args = ["httpd", "-f", "-p", "80", "-h", "/pkgs"]
        network_mode = "host"
      }

      volume_mount {
        volume = "root-pkgs"
        destination = "/pkgs"
      }
    }
  }
}
