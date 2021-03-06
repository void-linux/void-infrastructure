job "traefik" {
  datacenters = ["VOID-PROXY"]
  namespace = "infrastructure"
  type = "system"
  group "lb" {
    volume "acme_data" {
      type      = "host"
      read_only = false
      source    = "acme_data"
    }

    network {
      mode = "bridge"
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

    task "traefik" {
      driver = "docker"

      volume_mount {
        volume = "acme_data"
        destination = "/acme"
        read_only = false
      }

      vault {
        policies = ["void-secrets-traefik"]
      }

      config {
        image = "traefik:2.3.5"

        args = [
          "--api.dashboard",
          "--api.insecure=true",
          "--entrypoints.http.address=:80",
          "--entrypoints.https.address=:443",
          "--entrypoints.traefik.address=:8080",
          "--metrics.prometheus",
          "--providers.file.filename=/local/dynamic.toml",
          "--providers.consulcatalog.defaultrule=Host(`{{normalize .Name}}.s.voidlinux.org`)",
          "--providers.consulcatalog.exposedbydefault=false",
          "--providers.consulcatalog.endpoint.address=${attr.unique.network.ip-address}:8500",
          "--certificatesresolvers.do.acme.email=hostmaster@voidlinux.org",
          "--certificatesresolvers.do.acme.storage=/acme/acme.json",
          "--certificatesresolvers.do.acme.dnschallenge.provider=digitalocean",
          "--certificatesresolvers.do.acme.dnschallenge.resolvers=8.8.8.8",
        ]
      }

      template {
        data=<<EOF
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
    [http.routers.wildcard-cert]
      entryPoints = ["http"]
      service = "noop@internal"
      rule = "Host(`noop.s.voidlinux.org`)"
      [http.routers.wildcard-cert.tls]
        certResolver = "do"
        [[http.routers.wildcard-cert.tls.domains]]
          main = "*.voidlinux.org"
          sans = ["*.s.voidlinux.org"]
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
        data=<<EOF
{{- with secret "secret/traefik/do-api" }}
DO_AUTH_TOKEN={{.Data.api_key}}
{{- end }}
EOF
        destination = "secrets/env"
        perms = 400
        env = true
      }

      resources {
        cpu    = 500
        memory = 64
      }
    }
  }
}
