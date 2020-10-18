listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true

  telemetry {
    unauthenticated_metrics_access = true
  }
}
