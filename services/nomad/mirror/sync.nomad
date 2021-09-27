job "sync" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "rsync" {
    count = 1

    network { mode = "bridge" }

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
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
        CRON_TASK_1="* * * * * flock -n /run/sync.lock rsync -vurk --filter '- .*' --delete-after -e 'ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts' void-buildsync@a-hel-fi.node.consul:/srv/www/void-repo/ /mirror/"
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
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
