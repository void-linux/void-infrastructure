job "reposigner" {
  type = "batch"
  namespace = "build"
  datacenters = ["VOID"]

  periodic {
    cron             = "* * * * * *"
    prohibit_overlap = true
  }

  group "xbps" {
    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
      read_only = false
    }

    task "rindex" {
      driver = "docker"

      vault {
        policies = ["void-secrets-repomgmt"]
      }

      config {
        image = "ghcr.io/void-linux/void-linux:20210221rc01-full-x86_64-musl"
        entrypoint = ["/local/xbps-sign-repos"]
      }

      volume_mount {
        volume = "root-pkgs"
        destination = "/pkgs"
      }

      template {
        data = <<EOF
{{- with secret "secret/repomgmt/signing" -}}
{{.Data.key}}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
        perms = "0400"
      }

      template {
        data = <<EOF
{{- with secret "secret/repomgmt/signing" -}}
XBPS_PASSPHRASE={{.Data.keyphrase}}
{{- end -}}
EOF
        destination = "secrets/env"
        perms = "0400"
        env = true
      }

      template {
        data = file("xbps-sign-repos")
        destination = "local/xbps-sign-repos"
        perms = "0755"
      }
    }
  }
}
