server {
  enabled = true
  heartbeat_grace = "2m"

  server_join {
    retry_join = {{ nomad_retry_join_servers | to_json }}
  }
}
