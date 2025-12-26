job "feediverse" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "apps"

  group "feediverse" {
    network {
      mode = "bridge"
    }

    ephemeral_disk {
      migrate = true
      size = 200
      sticky = true
    }

    task "app" {
      driver = "docker"

      config {
        image = "ghcr.io/classabbyamp/feediverse:20251226R2"
      }

      env {
        VERBOSE = 1
        CONFIG_FILE = "/secrets/config.yaml"
        STATE_FILE = "/alloc/data/state.json"
        DEDUPE = "url"
      }

      template {
        data = <<EOT
{{- with nomadVar "nomad/jobs/feediverse" }}
access_token: "{{ .access_token }}"
client_id: "{{ .client_id }}"
client_secret: "{{ .client_secret }}"
{{- end }}
feeds:
- include_images: true
  template: '{title} {url}'
  url: https://voidlinux.org/atom.xml
name: feediverse
url: chaos.social
EOT
        destination = "secrets/config.yaml"
      }
    }
  }
}

