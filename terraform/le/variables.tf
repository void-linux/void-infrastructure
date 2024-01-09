resource "nomad_variable" "omniproxy" {
  namespace = "mirror"
  path = "nomad/jobs/nginx"

  items = {
    certificate = "${acme_certificate.voidlinux_org.certificate_pem}${acme_certificate.voidlinux_org.issuer_pem}"
    key = acme_certificate.voidlinux_org.private_key_pem
  }
}

resource "nomad_variable" "controlproxy" {
  namespace = "infrastructure"
  path = "nomad/jobs/nginx-control"

  items = {
    certificate = "${acme_certificate.voidlinux_org.certificate_pem}${acme_certificate.voidlinux_org.issuer_pem}"
    key = acme_certificate.voidlinux_org.private_key_pem
  }
}
