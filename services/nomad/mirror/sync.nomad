job "sync" {
  type = "sysbatch"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  periodic {
    cron = "* * * * *"
    prohibit_overlap = true
  }

  group "rsync" {
    count = 1

    network { mode = "bridge" }

    volume "dist-mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = false
    }

    task "rsync" {
      leader = true
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-rsync:v20220316RC02"
        command = "/usr/bin/rsync"
        args = [
          "-vurk",
          "--filter", "- .*",
          "--filter", "- *-repodata.*",
          "--delete-after",
          "--timeout", "15",
          "--contimeout", "5",
          "--links",
          "rsync://a-hel-fi.node.consul/voidmirror/",
          "/mirror/",
        ]
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "dist-mirror"
        destination = "/mirror"
      }
    }
  }
}
