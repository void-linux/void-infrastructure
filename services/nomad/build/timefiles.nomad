job "timefiles" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "timefiles" {
    count = 1
    network { mode = "bridge" }

    volume "root_mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    task "timefiles" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/void-glibc:20240526R1"
        command = "/local/run.sh"
      }

      volume_mount {
        volume = "root_mirror"
        destination = "/mirror"
      }

      template {
        data = <<EOF
#!/bin/sh

while true ; do
  t="$(date +%s)"
  for dir in / /nonfree /debug /multilib /multilib/nonfree /nonfree; do
    [ -e "/mirror/current/$dir" ] && echo "$t">"/mirror/current/$dir/otime"
    [ -e "/mirror/current/musl/$dir" ] && echo "$t">"/mirror/current/musl/$dir/otime"
    [ -e "/mirror/current/aarch64/$dir" ] && echo "$t">"/mirror/current/aarch64/$dir/otime"
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
