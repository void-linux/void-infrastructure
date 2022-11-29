job "traefik" {
  datacenters = ["VOID-PROXY", "VOID-MIRROR"]
  namespace = "infrastructure"
  type = "system"
  group "lb" {
    network {
      mode = "host"
      port "http" {
        to = 80
        static = 80
      }
      port "https" {
        to = 443
        static = 443
      }
      port "traefik" {
        to = 8080
        static = 8080
      }
    }

    service {
      name = "traefik-${node.unique.name}"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.traefik-${node.unique.name}.service=api@internal",
        "traefik.http.routers.traefik-${node.unique.name}.tls=true",
      ]
    }

    task "traefik" {
      driver = "docker"

      vault {
        policies = ["void-secrets-traefik"]
      }

      config {
        image = "traefik:v2.6.1"
        network_mode = "host"
        dns_servers = ["127.0.0.1"]

        args = [
          "--api.dashboard",
          "--api.insecure=true",
          "--entrypoints.http.address=:80",
          "--entrypoints.https.address=:443",
          "--entrypoints.traefik.address=:8080",
          "--metrics.prometheus",
          "--pilot.dashboard=false",
          "--providers.file.filename=/local/dynamic.toml",
          "--providers.consulcatalog.defaultrule=Host(`{{normalize .Name}}.s.voidlinux.org`)",
          "--providers.consulcatalog.exposedbydefault=false",
          "--providers.consulcatalog.endpoint.address=${attr.unique.network.ip-address}:8500",
        ]
      }

      template {
        data=<<EOF
[tls.stores]
  [tls.stores.default]
    [tls.stores.default.defaultCertificate]
      certFile = "/secrets/certs/voidlinux.org.crt"
      keyFile  = "/secrets/certs/voidlinux.org.key"
[http]
  [http.middlewares]
    [http.middlewares.httpsredirect.redirectScheme]
      scheme = "https"
  [http.routers]
    [http.routers.redirecttohttps]
      entryPoints = ["http"]
      middlewares = ["httpsredirect"]
      rule = "HostRegexp(`{host:.+}`)"
      service = "noop@internal"
    [http.routers.nomad]
      entryPoints = ["https"]
      service = "nomad"
      rule = "Host(`nomad.s.voidlinux.org`)"
      [http.routers.nomad.tls]
    [http.routers.consul]
      entryPoints = ["https"]
      service = "consul"
      rule = "Host(`consul.s.voidlinux.org`)"
      [http.routers.consul.tls]
    [http.routers.vault]
      entryPoints = ["https"]
      service = "vault"
      rule = "Host(`vault.s.voidlinux.org`)"
      [http.routers.vault.tls]
    [http.routers.repo-ci]
      entryPoints = ["http", "https"]
      service = "mirror-fi@consulcatalog"
      rule = "Host(`repo-ci.voidlinux.org`)"
      [http.routers.repo-ci.tls]
    [http.routers.repo-default]
      entryPoints = ["http", "https"]
      service = "mirror-fi@consulcatalog"
      rule = "Host(`repo-default.voidlinux.org`)"
      [http.routers.repo-default.tls]
  [http.services]
    [http.services.nomad]
      [http.services.nomad.loadBalancer]
        [[http.services.nomad.loadBalancer.servers]]
          url = "http://nomad.service.consul:4646"
    [http.services.consul]
      [http.services.consul.loadBalancer]
        [[http.services.consul.loadBalancer.servers]]
          url = "http://consul.service.consul:8500"
    [http.services.vault]
      [http.services.vault.loadBalancer]
        [[http.services.vault.loadBalancer.servers]]
          url = "http://active.vault.service.consul:8200"
EOF
        destination = "local/dynamic.toml"
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.crt" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/certs/voidlinux.org.crt"
        perms = 400
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.key" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/certs/voidlinux.org.key"
        perms = 400
      }

      resources {
        cpu    = 500
        memory = 128
      }
    }
  }
}
