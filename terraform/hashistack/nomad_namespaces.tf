resource "nomad_namespace" "monitoring" {
  name        = "monitoring"
  description = "Monitoring Components"
}

resource "nomad_namespace" "infrastructure" {
  name        = "infrastructure"
  description = "Shared Infrastructure"
}

resource "nomad_namespace" "apps" {
  name        = "apps"
  description = "Individual applications"
}
