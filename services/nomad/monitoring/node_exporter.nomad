job "node_exporter" {
  datacenters = [
    "VOID",
    "VOID-MX",
    "VOID-MIRROR",
    "VOID-CONTROL",
  ]
  namespace = "monitoring"
  type      = "system"
  priority  = 99

  group "app" {
    network {
      mode = "bridge"
      port "metrics" { to = 9100 }
    }

    task "vector" {
      driver = "exec2"

      config {
        command = "node_exporter"
        args    = ["--collector.runit", "--collector.runit.servicedir", "/var/service"]
      }

      service {
        provider = "nomad"
        name     = "node_exporter"
        port     = "metrics"
        tags     = ["prometheus_enable"]
      }
    }
  }
}
