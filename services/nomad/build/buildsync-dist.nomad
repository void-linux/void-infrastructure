job "buildsync-dist" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "rsync" {
    count = 1

    network { mode = "bridge" }

    volume "dist-pkgs" {
      type = "host"
      source = "dist_pkgs"
      read_only = false
    }

    volume "dist-sources" {
      type = "host"
      source = "dist_sources"
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
        CRON_TASK_1="* * * * * flock -n /run/sync.lock rsync -vurk --filter '- .*' --delete-after -e 'ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts' void-buildsync@a-fsn-de.node.consul:/data/pkgs/ /pkgs/"
        CRON_TASK_2="* * * * * flock -n /run/srcs.lock rsync -vurk --delete-after -e 'ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts' void-buildsync@a-fsn-de.node.consul:/hostdir/sources/ /sources/"
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "dist-pkgs"
        destination = "/pkgs"
      }

      volume_mount {
        volume = "dist-sources"
        destination = "/sources"
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
a-fsn-de.node.consul ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjnTyMBnRBQD6NXA5ejX1qV2u+rjuIpRHHBWLidJOjB
EOF
        destination = "local/known_hosts"
      }
    }
  }
}
