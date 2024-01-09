resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "maldridge@voidlinux.org"
}

resource "acme_certificate" "voidlinux_org" {
  account_key_pem = acme_registration.reg.account_key_pem
  pre_check_delay = 30
  common_name     = "voidlinux.org"
  subject_alternative_names = [
    "*.voidlinux.org",
    "*.s.voidlinux.org",
    "*.m.voidlinux.org",
  ]

  dns_challenge {
    provider = "digitalocean"
  }

  recursive_nameservers = ["1.1.1.1"]
}
