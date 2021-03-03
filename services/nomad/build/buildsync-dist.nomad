job "buildsync-dist" {
  type = "batch"
  datacenters = ["VOID"]
  namespace = "build"

  periodic {
    cron             = "*/2 * * * * *"
    prohibit_overlap = true
  }

  group "rsync" {
    network { mode = "bridge" }

    volume "dist-pkgs" {
      type = "host"
      source = "dist_pkgs"
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
          "rsync", "-vurk",
          "--delete-after",
          "-e", "ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts",
          "void-buildsync@b-hel-fi.node.consul:/mnt/data/pkgs/", "/pkgs/"
        ]
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "dist-pkgs"
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
b-hel-fi.node.consul ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMU4d2VBQ3GYGdPOFlvjsJupPnnCk+42hLhrGuCrGLgT
EOF
        destination = "local/known_hosts"
      }
    }
  }
}
