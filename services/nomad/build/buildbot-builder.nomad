job "buildbot-builder" {
  type = "service"
  datacenters = ["VOID"]
  # namespace = "build"

  group "buildbot-builder-glibc" {
    task "buildbot-worker" {
      driver = "docker"
      config {
        image = "localhost:5000/void-buildbot-builder:latest"
        force_pull = true
      }
      template {
        data = <<EOF
[buildbot]
worker-port = 9989
host = 192.168.0.120

[worker]
name = builder-glibc
pass = abc123
EOF
        destination = "local/config.ini"
      }
      template {
        data = "Your Name Here <admin@youraddress.invalid>"
        destination = "local/info/admin"
      }
      template {
        data = "Please put a description of this build host here"
        destination = "local/info/host"
      }
    }
  }

  group "buildbot-builder-musl" {
    task "buildbot-worker" {
      driver = "docker"
      config {
        image = "localhost:5000/void-buildbot-builder:latest"
        force_pull = true
      }
      template {
        data = <<EOF
[buildbot]
worker-port = 9989
host = 192.168.0.120

[worker]
name = builder-musl
pass = abc123
EOF
        destination = "local/config.ini"
      }
      template {
        data = "Your Name Here <admin@youraddress.invalid>"
        destination = "local/info/admin"
      }
      template {
        data = "Please put a description of this build host here"
        destination = "local/info/host"
      }
    }
  }
}
