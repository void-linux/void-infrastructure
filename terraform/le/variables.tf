resource "nomad_variable" "certs" {
  for_each = {
    "nomad/jobs/nginx" = "mirror"
    "nomad/jobs/nginx-control" = "infrastructure"
    "nomad/jobs/maddy" = "apps-restricted"
  }

  namespace = each.value
  path = each.key

  items = {
    certificate = "${acme_certificate.voidlinux_org.certificate_pem}${acme_certificate.voidlinux_org.issuer_pem}"
    key = acme_certificate.voidlinux_org.private_key_pem
  }
}
