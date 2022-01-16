job "buildsync-musl" {
  type = "service"
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
      leader = true
      driver = "docker"

      vault {
        policies = ["void-secrets-buildsync"]
      }

      config {
        image = "eeacms/rsync"
        args = ["client"]
      }

      env {
        CRON_TASK_1="*/5 * * * * flock -n /run/rsync.lock rsync -vurk -e 'ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts' --exclude '*.sig' --delete-after -f '+ */' -f '+ *-repodata' -f '+ *.xbps' -f '+ otime' -f '- *' void-buildsync@a-hel-fi.node.consul:/hostdir/binpkgs/ /pkgs/musl/"
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
a-hel-fi.node.consul ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIW8voCZh9nQpdx3fAsvfZO4mCYv0/OUVNPF9A/GsHtX
EOF
        destination = "local/known_hosts"
      }
    }
  }
}
