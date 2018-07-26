provider "google" {
  credentials = "${file("account.json")}"
  project     = "void-linux-175807"
  region      = "us-central1"
}

resource "google_dns_managed_zone" "voidlinux-org" {
  name        = "voidlinux-org"
  dns_name    = "voidlinux.org."
  description = "Primary DNS Zone"
}



######################################################################
# Machines                                                           #
#                                                                    #
# These should be ordered in the form of the region, then within the #
# region by machine name, and under any machine that is hosting VMs  #
# should be its VMs.                                                 #
######################################################################

resource "google_dns_record_set" "a-lej-de" {
  name = "a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["136.243.133.13"]
}

resource "google_dns_record_set" "vm1-a-lej-de" {
  name = "vm1.a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.112"]
}

resource "google_dns_record_set" "vm2-a-lej-de" {
  name = "vm2.a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.117"]
}

resource "google_dns_record_set" "b-lej-de" {
  name = "b-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["78.46.212.193"]
}

resource "google_dns_record_set" "c-lej-de" {
  name = "c-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["5.9.152.66"]
}

resource "google_dns_record_set" "a-mci-us" {
  name = "a-mci-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["198.204.250.218"]
}

resource "google_dns_record_set" "vm1-a-mci-us" {
  name = "vm1.a-mci-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["198.204.250.219"]
}

######################################################################
# Legacy Hosts                                                       #
#                                                                    #
# These hosts have legacy A records because they predate the managed #
# fleet.                                                             #
######################################################################

resource "google_dns_record_set" "wiki-legacy" {
  name = "wiki.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.115"]
}

resource "google_dns_record_set" "forum-legacy" {
  name = "forum.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["174.138.52.96"]
}

#######################
# GitHub Sites Record #
#######################

resource "google_dns_record_set" "homepage-github" {
  name = "${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["185.199.109.153"]
}

resource "google_dns_record_set" "homepage-github-www" {
  name = "www.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "A"
  ttl     = 300
  rrdatas = ["185.199.109.153"]
}

###################
# Forum Mail Keys #
###################

resource "google_dns_record_set" "forum-mailkey1" {
  name = "forum.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "TXT"
  ttl     = 300
  rrdatas = ["v=spf1 include:mailgun.org ~all"]
}

resource "google_dns_record_set" "forum-mailkey2" {
  name = "mailo._domainkey.forum.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "TXT"
  ttl     = 300
  rrdatas = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+l2MjKLTITnCaKL9Z8dM18OcnsbJuDp2+RPc7R3yKHgdV9axHIgeZV2ycn4dMesUJmLIMQKKSkNpULUwEvR2bN16UwcWTcbppP5K/ZL387TH6UL+OKqhXcfxJqIitzds88CPCrQqXrLL97jfycMbML3aZCc7MZ9zAkz0+Q+Wx3QIDAQAB"]
}

resource "google_dns_record_set" "forum-mailkey3" {
  name = "pic._domainkey.forum.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "TXT"
  ttl     = 300
  rrdatas = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4DPi6hF1UPXxYv7giQzZSc3LGvN22jTWdN2pL+VNbAuFAYXpLjhdJGDPCRc3IRAYi/6SCDLBaNdlTx4yWWEnZ848RkrgKbxHVKz7UnEtS1ClSt4/6rD59TBXE4eaa/aneHHCGed2kWYYteXHDfn9+4kYYLn7SpjKrjIgND8ZVgwIDAQAB"]
}

####################################################
# Service Names                                    #
#                                                  #
# This section should maintain alphabetical order. #
####################################################

resource "google_dns_record_set" "service-auto" {
  # Automatic Mirror directory
  name = "auto.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm1.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-build" {
  # Builder web page
  name = "build.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm1.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-monitoring" {
  # Monitoring Site
  name = "monitoring.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["b-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-netauth" {
  # Authentication Service
  name = "netauth.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm2.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-popcorn" {
  # PopCorn XBPS Stats system
  name = "popcorn.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm1.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-sources" {
  # Sources site
  name = "sources.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = "${google_dns_managed_zone.voidlinux-org.name}"

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm1.a-lej-de.m.voidlinux.org."]
}

