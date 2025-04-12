job "nginx-control" {
  type = "system"
  datacenters = ["VOID-CONTROL"]
  namespace = "infrastructure"

  group "nginx" {
    network {
      mode = "host"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-nginx:20221230RC01"
        network_mode = "host"
        dns_servers = ["127.0.0.1"]
      }

      template {
        data = "{{ with nomadVar \"nomad/jobs/nginx-control\" }}{{ .certificate }}{{ end }}"
        destination = "secrets/certs/voidlinux.org.crt"
        perms = 400
        change_mode = "signal"
      }

      template {
        data = "{{ with nomadVar \"nomad/jobs/nginx-control\" }}{{ .key }}{{ end }}"
        destination = "secrets/certs/voidlinux.org.key"
        perms = 400
        change_mode = "signal"
      }

      dynamic "template" {
        for_each = [
          "00-default.conf",
          "05-hashi.conf",
          "10-ssl-redirect.conf",
          "10-proxy.conf",
        ]

        content {
          data = file("nginx-sites/${template.value}")
          destination = "local/nginx/${template.value}"
          perms = 400
          change_mode = "signal"
        }
      }
    }
  }
}
