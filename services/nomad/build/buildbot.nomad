job "buildbot" {
  type = "service"
  datacenters = ["VOID"]
  # namespace = "build"

  group "buildbot" {

    network {
      mode = "bridge"
      port "http" {
        static = 8010
        host_network = "public"
      }
      port "worker" {
        static = 9989
        host_network = "public"
      }
    }

    /*
    service {
      name = "buildbot-www"
      port = "http"
      check {
        type = "http"
        address_mode = "host"
        path = "/"
        timeout = "30s"
        interval = "5s"
      }
    }
    */

    task "buildbot" {
      driver = "docker"
      config {
        image = "localhost:5000/void-buildbot:latest"
        force_pull = true
        ports = ["http", "worker"]
      }
      template {
        data = <<EOF
[buildbot]
worker-port = {{ env "NOMAD_PORT_worker" }}
www-port = tcp:port={{ env "NOMAD_PORT_http" }}
url = http://192.168.0.120:{{ env "NOMAD_PORT_http" }}/

[worker:builder-glibc]
pass = abc123
max-builds = 4

[worker:builder-musl]
pass = abc123
max-builds = 3

[worker:builder-aarch64]
pass = abc123
max-builds = 2

[builder:x86_64_builder]
arch = x86_64
workernames = builder-glibc

[builder:i686_builder]
arch = i686
workernames = builder-glibc

[builder:armv7l_builder]
arch = x86_64
target = armv7l
workernames = builder-glibc

[builder:armv6l_builder]
target = armv6l
arch = x86_64
workernames = builder-glibc

[builder:x86_64-musl_builder]
arch = x86_64-musl
workernames = builder-musl

[builder:armv7l-musl_builder]
arch = x86_64-musl
target = armv7l-musl
workernames = builder-musl

[builder:armv6l-musl_builder]
arch = x86_64-musl
target = armv6l-musl
workernames = builder-musl

[builder:aarch64_builder]
arch = x86_64
target = aarch64
workernames = builder-aarch64

[builder:aarch64-musl_builder]
arch = x86_64-musl
target = aarch64-musl
workernames = builder-aarch64

#[irc]
#host = chat.libera.host
#nick = void-build
#channel = #xbps
#authz = duncaen maldridge
#notify-events = exception problem recovery worker
EOF
        destination = "local/config.ini"
      }
      template {
        data = "Please put a description of this build host here"
        destination = "local/info/host"
      }
    }
  }
}
