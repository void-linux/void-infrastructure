job "buildsync-musl" {
  type = "batch"
  datacenters = ["VOID"]
  namespace = "build"

  group "rsync" {
    network { mode = "bridge" }

    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
      read_only = false
    }

    task "rsync" {
      driver = "docker"

      vault {
        policies = ["void-secrets-buildsync"]
      }

      config {
        image = "eeacms/rsync"
        args = [
          "rsync", "-avzurk",
          "-e", "ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts",
          "--exclude", "'*.sig'",
          "--delete-after",
          "-f", "+ */",
          "-f", "+ *-repodata",
          "-f", "+ *.xbps",
          "-f", "- *",
          "xbps-master@198.204.250.219:/hostdir/binpkgs/", "/pkgs/musl"
        ]
      }

      volume_mount {
        volume = "root-pkgs"
        destination = "/pkgs"
      }

      template {
        data = <<EOF
{{- with secret "secret/buildsync/ssh" -}}
{{.Data.private_key}}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
        perms = "0400"
      }

      template {
        data = <<EOF
198.204.250.219 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/m4r1s3RWBDSUn3ZK0ZfXbzuvxKZPQMgvuhNXpvxFY
EOF
        destination = "local/known_hosts"
      }
    }
  }
}
