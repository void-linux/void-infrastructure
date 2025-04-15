job "reposigner" {
  type = "service"
  namespace = "build"
  datacenters = ["VOID"]

  group "xbps" {
    count = 1

    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
      read_only = false
    }

    task "legacy-sign" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/xbps-legacy-sign:20230815"
        args = [
          "-private-key", "/secrets/id_rsa", "-passphrase-file", "/secrets/id_rsa_passphrase", "-watch",
          "/pkgs",          "/pkgs/bootstrap",          "/pkgs/nonfree",          "/pkgs/debug",
          "/pkgs/multilib", "/pkgs/multilib/bootstrap", "/pkgs/multilib/nonfree",
          "/pkgs/musl",     "/pkgs/musl/bootstrap",     "/pkgs/musl/nonfree",     "/pkgs/musl/debug",
          "/pkgs/aarch64",  "/pkgs/aarch64/bootstrap",  "/pkgs/aarch64/nonfree",  "/pkgs/aarch64/debug",
        ]
      }

      volume_mount {
        volume = "root-pkgs"
        destination = "/pkgs"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/reposigner" -}}
{{ .key }}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
        perms = "0400"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/reposigner" -}}
{{ .keyphrase }}
{{- end -}}
EOF
        destination = "secrets/id_rsa_passphrase"
        perms = "0400"
      }
    }
  }
}
