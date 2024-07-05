job "buildbot-builder" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [
      // TODO: jobs = 16, 6, 3
      // TODO: mem = 109512, 54512, 27256
      // memory is ~85% of capacity
      { name = "glibc",   jobs = 2, mem = 8192 },
      { name = "musl",    jobs = 2, mem = 8192 },
      { name = "aarch64", jobs = 2, mem = 8192 },
    ]
    labels = [ "buildbot-builder-${group.value.name}" ]

    content {
      dynamic "volume" {
        for_each = [ "${group.value.name}" ]
        labels = [ "${volume.value}_hostdir" ]

        content {
          type = "host"
          source = "${volume.value}_hostdir"
          read_only = false
        }
      }

      // https://github.com/hashicorp/nomad/issues/8892
      task "prep-hostdir" {
        driver = "docker"

        config {
          image = "ghcr.io/void-linux/void-glibc-full:20240526R1"
          command = "chown"
          args = ["-R", "418:418", "/hostdir"]
        }

        volume_mount {
          volume = "${group.value.name}_hostdir"
          destination = "/hostdir"
        }

        lifecycle {
          hook = "prestart"
        }
      }

      task "buildbot-worker" {
        driver = "docker"

        user = "void-builder"

        config {
          // TODO: proper image name and version
          image = "localhost:5000/infra-buildbot-builder:latest"
          force_pull = true
          cap_add = ["sys_admin"]
        }

        resources {
          cores = "${group.value.jobs}"
          memory = "${group.value.mem}"
        }

        volume_mount {
          volume = "${group.value.name}_hostdir"
          destination = "/hostdir"
        }

        template {
          data = <<EOF
{{ $allocID := env "NOMAD_ALLOC_ID" -}}
{{ range nomadService 1 $allocID "buildbot-worker" -}}
[buildbot]
host = {{ .Address }}
worker-port = {{ .Port }}
{{ end -}}

[worker]
name = worker-${group.value.name}
EOF
          destination = "local/config.ini"
        }

        template {
          data = <<EOF
XBPS_MAKEJOBS=${group.value.jobs}
XBPS_CHROOT_CMD=uchroot
XBPS_CHROOT_CMD_ARGS='-t'
XBPS_CCACHE=yes
XBPS_DEBUG_PKGS=yes
XBPS_USE_GIT_REVS=yes
XBPS_DISTFILES_MIRROR=https://sources.voidlinux.org
XBPS_PRESERVE_PKGS=yes
EOF
          destination = "local/xbps-src.conf"
        }

        template {
          data = "Void Build Operators <build-ops@voidlinux.org>"
          destination = "local/info/admin"
        }

        template {
          data = <<EOF
Void Linux Buildbot builder for ${group.value.name} running on {{ env "attr.unique.hostname" -}}
EOF
          destination = "local/info/host"
        }

        template {
          data = <<EOF
{{- with nomadVar "nomad/jobs/buildbot-worker" -}}
{{ .worker_password }}
{{- end -}}
EOF
          destination = "secrets/buildbot/worker-password"
          perms = "400"
          uid = 418
          gid = 418
        }
      }
    }
  }
}
