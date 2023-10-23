job "grafana" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "app" {
    count = 1

    volume "grafana" {
      type = "host"
      read_only = false
      source = "grafana"
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    network {
      mode = "bridge"
      port "http" { to = 3000 }
    }

    service {
      name = "grafana"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "grafana.s.voidlinux.org grafana.voidlinux.org"
      }

      check {
        type = "http"
        address_mode = "host"
        path = "/healthz"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "grafana" {
      driver = "docker"

      volume_mount {
        volume = "grafana"
        destination = "/var/lib/grafana"
        read_only = false
      }

      config {
        image = "grafana/grafana:10.1.5"
      }

      env {
        GF_AUTH_ANONYMOUS_ENABLED="true"
        GF_AUTH_ANONYMOUS_ORG_NAME="Main Org."
        GF_AUTH_ANONYMOUS_ORG_ROLE="Viewer"
        GF_AUTH_LDAP_ENABLED="true"
        GF_AUTH_LDAP_CONFIG_FILE="/local/ldap.toml"
        GF_AUTH_LDAP_ALLOW_SIGN_UP="true"
      }

        template {
          data = <<EOT
[[servers]]
host = "localhost"
port = 389
use_ssl = false
bind_dn = "uid=%s,ou=entities,dc=netauth,dc=voidlinux,dc=org"
search_filter = "(uid=%s)"
search_base_dns = ["ou=entities,dc=netauth,dc=voidlinux,dc=org"]

[servers.attributes]
username = "uid"
member_of = "memberOf"

[[servers.group_mappings]]
group_dn = "cn=grafana-root,ou=groups,dc=netauth,dc=voidlinux,dc=org"
org_role = "Admin"
grafana_admin = true # Available in Grafana v5.3 and above

[[servers.group_mappings]]
group_dn = "cn=grafana-editor,ou=groups,dc=netauth,dc=voidlinux,dc=org"
org_role = "Editor"

[[servers.group_mappings]]
group_dn = "*"
org_role = "Viewer"
EOT
          perms = 644
          destination = "local/ldap.toml"
        }
    }

    task "ldap" {
      driver = "docker"

      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      config {
        image = "ghcr.io/netauth/ldap:v0.2.3"
      }

      resources {
        memory = 100
      }

      env {
        NETAUTH_LOGLEVEL = "trace"
      }
    }
  }
}
