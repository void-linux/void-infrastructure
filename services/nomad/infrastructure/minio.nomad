job "minio" {
  datacenters = ["VOID"]
  namespace = "infrastructure"
  type = "service"

  group "app" {
    count = 1

    volume "minio_data" {
      type = "host"
      read_only = false
      source = "minio-data"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 9000
      }
    }

    service {
      name = "minio"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.minio.tls=true",
      ]
      check {
        type = "http"
        address_mode = "host"
        path = "/minio/health/live"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "minio" {
      driver = "docker"

      vault {
        policies = ["void-secrets-minio"]
      }

      volume_mount {
        volume = "minio_data"
        destination = "/data"
        read_only = false
      }

      config {
        image = "minio/minio:RELEASE.2020-10-28T08-16-50Z.e0655e24f"
        args = ["server", "/data"]
      }

      template {
        data = <<EOT
{{- with secret "secret/minio/root" }}
MINIO_ACCESS_KEY="{{.Data.access_key}}"
MINIO_SECRET_KEY="{{.Data.secret_key}}"
{{- end }}
EOT
        destination = "secrets/env"
        env = true
      }

      resources {
        memory = 1000
        cpu = 5000
      }
    }
  }
}
