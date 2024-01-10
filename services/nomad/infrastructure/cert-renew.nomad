job "cert-renew" {
  datacenters = ["VOID"]
  namespace = "infrastructure"
  type = "batch"

  periodic {
    cron = "@weekly"
  }

  group "terraform" {
    count = 1

    network { mode = "bridge" }

    task "terraform" {
      driver = "docker"

      config {
        image = "docker.io/hashicorp/terraform:1.6.6"
        entrypoint = ["/local/entrypoint"]
      }

      identity {
        env = true
      }

      env {
        TF_HTTP_USERNAME="_terraform"
        NOMAD_ADDR="unix://${NOMAD_SECRETS_DIR}/api.sock"
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/cert-renew" }}
TF_HTTP_PASSWORD={{.terraform_password}}
DO_AUTH_TOKEN={{.digitalocean_token}}
{{ end }}
EOF
        destination = "${NOMAD_SECRETS_DIR}/env"
        env = true
      }

      template {
        data = <<EOF
#!/bin/sh
cd /local
terraform init
terraform apply -auto-approve
EOF
        destination = "local/entrypoint"
        perms = "755"
      }

      dynamic "artifact" {
        for_each = ["acme.tf", "provider.tf", "variables.tf", "backend.tf", ".terraform.lock.hcl"]
        content {
          source = "https://raw.githubusercontent.com/void-linux/void-infrastructure/master/terraform/le/${artifact.value}"
        }
      }
    }
  }
}
