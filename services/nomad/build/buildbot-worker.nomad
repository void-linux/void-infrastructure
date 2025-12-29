job "buildbot-worker" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  dynamic "group" {
    for_each = [
      // cpu is ~equivalent to a number of cores
      // memory is ~90% of capacity
      // memory_max is ~95% of capacity
      # XXX
      # { name = "glibc",   jobs = 10, cpu = 38100, mem = 115840, mem_max = 122270 },
      # { name = "musl",    jobs = 6,  cpu = 21700, mem = 57690,  mem_max = 60890  },
      # { name = "aarch64", jobs = 12, cpu = 16000, mem = 27500,  mem_max = 29500  },
      { name = "glibc",   jobs = 2, cpu = 10000, mem = 4096, mem_max = 8192 },
      { name = "musl",    jobs = 2, cpu = 10000, mem = 4096, mem_max = 8192 },
      { name = "aarch64", jobs = 2, cpu = 10000, mem = 4096, mem_max = 8192 },
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
          image = "ghcr.io/void-linux/void-glibc-full:20250616R2"
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
          image = "ghcr.io/void-linux/infra-buildbot-builder:20251119R1"
          volumes = [
            "local/xbps-repos.conf:/etc/xbps.d/00-repository-main.conf",
            "local/xbps-arch.conf:/etc/xbps.d/xbps-arch.conf",
          ]
          cap_add = ["sys_admin"]
        }

        resources {
          cpu = "${group.value.cpu}"
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

        # XXX
        template {
          data = <<EOF
{{ range nomadService "buildbot-worker" -}}
[buildbot]
host = {{ .Address }}
worker-port = {{ .Port }}
{{ end -}}

[worker]
name = worker-${group.value.name}
EOF
          destination = "local/config.ini"
        }

        # XXX
        template {
          data = <<EOF
XBPS_MAKEJOBS=${group.value.jobs}
XBPS_CHROOT_CMD=uchroot
XBPS_CCACHE=yes
XBPS_DEBUG_PKGS=yes
XBPS_USE_GIT_REVS=yes
XBPS_DISTFILES_MIRROR=https://sources.voidlinux.org
XBPS_PRESERVE_PKGS=yes
{{ range nomadService "root-pkgs-internal" }}
XBPS_MIRROR=http://{{ .Address }}:{{ .Port }}
{{ end }}
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
        # XXX
        template {
          data = <<EOF
{{ range nomadService "root-pkgs-internal" }}
{{ if eq "${group.value.name}" "glibc" }}
repository=http://{{ .Address }}:{{ .Port }}/bootstrap
repository=http://{{ .Address }}:{{ .Port }}
repository=http://{{ .Address }}:{{ .Port }}/nonfree
repository=http://{{ .Address }}:{{ .Port }}/multilib/bootstrap
repository=http://{{ .Address }}:{{ .Port }}/multilib
repository=http://{{ .Address }}:{{ .Port }}/multilib/nonfree
{{ else }}
repository=http://{{ .Address }}:{{ .Port }}/${group.value.name}/bootstrap
repository=http://{{ .Address }}:{{ .Port }}/${group.value.name}
repository=http://{{ .Address }}:{{ .Port }}/${group.value.name}/nonfree
{{ end }}
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
{{ .password }}
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
