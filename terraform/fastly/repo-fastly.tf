resource "fastly_service_vcl" "main_repo" {
  name = "main_repo"

  domain {
    name    = "repo-fastly.voidlinux.org"
    comment = "Main Repository"
  }

  backend {
    address = "repo-fi.voidlinux.org"
    name    = "primary-origin"
    port    = 443
    use_ssl = true
  }

  snippet {
    content  = <<-EOT
      if (req.url.path ~ "^.+[.gz|.xz|.xbps|.iso]$") {
        set req.enable_segmented_caching = true;
      }
    EOT
    name     = "Enable segment caching for XBPS pool"
    priority = 60
    type     = "recv"
  }

  snippet {
    content = "set beresp.do_stream = true;"
    name    = "Enable streaming-miss"
    type    = "fetch"
  }

  cache_setting {
    name = "max-ttl"
    ttl  = 3600 * 24 * 30
  }
}

resource "fastly_tls_subscription" "repo_fastly_voidlinux_org" {
  certificate_authority = "lets-encrypt"
  domains               = ["repo-fastly.voidlinux.org"]
}
