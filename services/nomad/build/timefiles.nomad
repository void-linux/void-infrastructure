job "timefiles" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [ "glibc", "aarch64", "musl", ]
    labels = [ "timefiles-${group.value}" ]

    content {
      count = 1
      network { mode = "bridge" }

      dynamic "volume" {
        for_each = [ "${group.value}" ]
        labels = [ "${volume.value}_hostdir" ]

        content {
          type = "host"
          source = "${volume.value}_hostdir"
          read_only = false
        }
      }

      task "timefiles" {
        driver = "docker"

        config {
          image = "ghcr.io/void-linux/void-glibc:20240526R1"
          command = "/local/run.sh"
        }

        volume_mount {
          volume = "${group.value}_hostdir"
          destination = "/hostdir"
        }

        template {
          data = <<EOF
#!/bin/sh

while true ; do
    t="$(date +%s)"
    for dir in / /nonfree /debug /multilib /multilib/nonfree /nonfree ; do
        echo "$t">"/hostdir/binpkgs/$dir/otime"
    done
    sleep 60
done
EOF
          destination = "local/run.sh"
          perms = "0755"
        }
      }
    }
  }
}
