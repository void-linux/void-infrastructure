# node_exporter needs a token to be able to register it to the service
# catalog.
resource "consul_acl_policy" "node_exporter" {
  name        = "void-node-exporter"
  description = "Policy for node_exporter"
  rules = jsonencode({
    service = {
      "node-exporter" = {
        policy = "write"
      }
    }
  })
}
