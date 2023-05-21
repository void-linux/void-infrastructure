job "ccache_exporter" {
  type = "service"
  namespace = "monitoring"
  datacenters = ["VOID"]

  dynamic "group" {
    for_each = {
      glibc = { host = "a-fsn-de", size = "16GB" }
      musl = { host = "a-hel-fi", size = "8GB" }
      aarch64 = { host = "b-fsn-de", size = "16GB" }
    }

    labels = [group.key]

    content {
      constraint {
        attribute = "${node.unique.name}"
        value = group.value.host
      }

      volume "ccache" {
        type = "host"
        read_only = true
        source = "ccache"
      }

      network {
        mode = "bridge"
        port "http" { to = 9508 }
      }

      service {
        name = "ccache-exporter"
        port = "http"
      }

      task "exporter" {
        driver = "docker"

        volume_mount {
          volume = "ccache"
          destination = "/ccache"
          read_only = true
        }

        config {
          image = "ghcr.io/duncaen/ccache_exporter:v0.0.1"
          args = ["-ccache-dir", "/ccache", "-ccache-size", group.value.size]
        }
      }
    }
  }
}
