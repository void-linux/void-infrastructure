job "buildbot-worker" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [
      // memory is ~90% of capacity
      // memory_max is ~95% of capacity
      { name = "glibc",   jobs = 10, mem = 115840, mem_max = 122270 },
      { name = "musl",    jobs = 6,  mem = 57690,  mem_max = 60890  },
      { name = "aarch64", jobs = 3,  mem = 28500,  mem_max = 30500  },
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

      dynamic "volume" {
        for_each = [ "${group.value.name}" ]
        labels = [ "${volume.value}_buildrootdir" ]

        content {
          type = "host"
          source = "${volume.value}_buildrootdir"
          read_only = false
        }
      }

      // https://github.com/hashicorp/nomad/issues/8892
      task "prep-host-dirs" {
        driver = "docker"

        config {
          image = "ghcr.io/void-linux/void-glibc-full:20240526R1"
          command = "chown"
          args = ["418:418", "/hostdir", "/workdir", "/buildroots"]
        }

        volume_mount {
          volume = "${group.value.name}_hostdir"
          destination = "/hostdir"
        }

        volume_mount {
          volume = "${group.value.name}_workdir"
          destination = "/workdir"
        }

        volume_mount {
          volume = "${group.value.name}_buildrootdir"
          destination = "/buildroots"
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
          volumes = [
            "local/xbps-repos.conf:/etc/xbps.d/00-repository-main.conf",
            "local/xbps-arch.conf:/etc/xbps.d/xbps-arch.conf",
          ]
          cap_add = ["sys_admin"]
        }

        resources {
          cores = "${group.value.jobs}"
          memory = "${group.value.mem}"
          memory_max = "${group.value.mem_max}"
        }

        volume_mount {
          volume = "${group.value.name}_hostdir"
          destination = "/hostdir"
        }

        volume_mount {
          volume = "${group.value.name}_workdir"
          destination = "/workdir"
        }

        volume_mount {
          volume = "${group.value.name}_buildrootdir"
          destination = "/buildroots"
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

        // the builders should use local repos
        // except for aarch64, which must be able to get hostmakedepends from repo-default
        template {
          data = <<EOF
repository=/hostdir/binpkgs/bootstrap
repository=/hostdir/binpkgs
repository=/hostdir/binpkgs/nonfree
{{ if eq "${group.value.name}" "glibc" }}
repository=/hostdir/binpkgs/multilib/bootstrap
repository=/hostdir/binpkgs/multilib
repository=/hostdir/binpkgs/multilib/nonfree
{{ end }}
{{ if eq "${group.value.name}" "aarch64" }}
repository=https://repo-default.voidlinux.org/current
repository=https://repo-default.voidlinux.org/current/musl
{{ end }}
EOF
          destination = "local/xbps-repos.conf"
        }

        // /usr/share/xbps.d/xbps-arch.conf will mess up xbps-checkvers, so mask it with an empty file
        template {
          data = <<EOF
# this file intentionally left blank
EOF
          destination = "local/xbps-arch.conf"
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
