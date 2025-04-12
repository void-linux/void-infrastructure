job "maddy" {
  datacenters = ["VOID-MX"]
  namespace = "apps-restricted"
  type = "service"

  group "app" {
    count = 1

    volume "maddy_data" {
      type = "host"
      read_only = false
      source = "maddy_data"
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    network {
      mode = "host"
      # port "smtp"        { static = 25 }
      # port "imap"        { static = 143 }
      # port "submissions" { static = 465 }
      # port "submission"  { static = 587 }
      # port "imaps"       { static = 993 }
    }

    task "maddy" {
      driver = "docker"

      volume_mount {
        volume = "maddy_data"
        destination = "/data"
        read_only = false
      }

      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      config {
        image = "docker.io/foxcpp/maddy:0.7.0"
        entrypoint = ["/bin/maddy", "--config", "/local/maddy.conf", "run"]
        network_mode = "host"
      }

      resources {
        memory = 500
      }

      env {
        MADDY_DOMAIN = "voidlinux.org"
        MADDY_HOSTNAME = "mx1.voidlinux.org"
      }

      template {
        data = file("maddy.conf")
        destination = "local/maddy.conf"
        perms = 644
      }

      template {
        data = "{{ with nomadVar \"nomad/jobs/maddy\" }}{{ .certificate }}{{ end }}"
        destination = "secrets/tls/fullchain.pem"
        perms = 400
      }

      template {
        data = "{{ with nomadVar \"nomad/jobs/maddy\" }}{{ .key }}{{ end }}"
        destination = "secrets/tls/privkey.pem"
        perms = 400
      }
    }
  }
}
