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

resource "nomad_namespace" "apps_restricted" {
  name        = "apps-restricted"
  description = "High privilege applications"
}

resource "nomad_namespace" "build" {
  name        = "build"
  description = "Home of build related tasks"
}
