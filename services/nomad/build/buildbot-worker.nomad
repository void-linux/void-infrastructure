job "buildbot-worker" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [
      // memory is ~85% of capacity
      { name = "glibc",   jobs = 10, mem = 109512 },
      { name = "musl",    jobs = 6,  mem = 54512  },
      { name = "aarch64", jobs = 3,  mem = 27256  },
    ]
    labels = [ "buildbot-worker-${group.value.name}" ]

    content {
      network {
        mode = "bridge"
        hostname = "void-buildbot-worker-${group.value.name}"
      }

      dynamic "volume" {
        for_each = [ "${group.value.name}" ]
        labels = [ "${volume.value}_hostdir" ]

        content {
          type = "host"
          source = "${volume.value}_hostdir"
          read_only = false
        }
      }

      dynamic "volume" {
        for_each = [ "${group.value.name}" ]
        labels = [ "${volume.value}_workdir" ]

        content {
          type = "host"
          source = "${volume.value}_workdir"
          read_only = false
        }
      }

      // https://github.com/hashicorp/nomad/issues/8892
      task "prep-host-dirs" {
        driver = "docker"

        config {
          image = "ghcr.io/void-linux/void-glibc-full:20240526R1"
          command = "chown"
          args = ["418:418", "/hostdir", "/workdir"]
        }

        volume_mount {
          volume = "${group.value.name}_hostdir"
          destination = "/hostdir"
        }

        volume_mount {
          volume = "${group.value.name}_workdir"
          destination = "/workdir"
        }

        lifecycle {
          hook = "prestart"
        }
      }

      task "buildbot-worker" {
        driver = "docker"

        user = "void-builder"

        config {
          image = "ghcr.io/void-linux/infra-buildbot-builder:20240928R1"
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

        volume_mount {
          volume = "${group.value.name}_workdir"
          destination = "/workdir"
        }

        template {
          data = <<EOF
{{ range service "buildbot-worker" -}}
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

        template {
          data = <<EOF
{{- with nomadVar "nomad/jobs/buildsync" -}}
{{ .${group.value.name}_password }}
{{- end -}}
EOF
          destination = "secrets/rsync/password"
          perms = "400"
          uid = 418
          gid = 418
        }
      }
    }
  }
}
