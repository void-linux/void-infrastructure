job "maddy" {
  type = "service"
  datacenters = ["VOID-MX"]
  namespace = "apps-restricted"

  group "maddy" {
    count = 1

    network {
      mode = "bridge"
      port "smtp" {
        to = 25
        static = 25
      }
      port "imap" {
        to = 143
        static = 143
      }
      port "submission" {
        to = 587
        static = 587
      }
      port "imaps" {
        to = 993
        static = 993
      }
    }

    volume "maddy_data" {
      type = "host"
      read_only = "false"
      source = "maddy_data"
    }

    task "app" {
      driver = "docker"

      config {
        image = "foxcpp/maddy:0.4.3"
      }

      volume_mount {
        volume = "maddy_data"
        destination = "/data"
        read_only = false
      }
    }
  }
}
