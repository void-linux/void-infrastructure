provider "google" {
  credentials = file("account.json")
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

resource "google_dns_record_set" "a-hel-fi" {
  name         = "a-hel-fi.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["95.216.76.97"]
}

resource "google_dns_record_set" "a-lej-de" {
  name         = "a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["136.243.133.13"]
}

resource "google_dns_record_set" "vm2-a-lej-de" {
  name         = "vm2.a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.117"]
}

resource "google_dns_record_set" "vm3-a-lej-de" {
  name         = "vm3.a-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.113"]
}

resource "google_dns_record_set" "b-lej-de" {
  name         = "b-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["78.46.212.193"]
}

resource "google_dns_record_set" "c-lej-de" {
  name         = "c-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["5.9.152.66"]
}

resource "google_dns_record_set" "d-lej-de" {
  name         = "d-lej-de.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["94.130.237.33"]
}

resource "google_dns_record_set" "a-mci-us" {
  name         = "a-mci-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["198.204.250.218"]
}

resource "google_dns_record_set" "vm1-a-mci-us" {
  name         = "vm1.a-mci-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["198.204.250.219"]
}

resource "google_dns_record_set" "a_sfo3_us" {
  name         = "a-sfo3-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["161.35.231.145"]
}

resource "google_dns_record_set" "b_sfo3_us" {
  name         = "b-sfo3-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["143.110.155.135"]
}

resource "google_dns_record_set" "c_sfo3_us" {
  name         = "c-sfo3-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["143.110.147.196"]
}

resource "google_dns_record_set" "d_sfo3_us" {
  name         = "d-sfo3-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["143.110.155.124"]
}

resource "google_dns_record_set" "e_sfo3_us" {
  name         = "e-sfo3-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["161.35.228.17"]
}

######################################################################
# Legacy Hosts                                                       #
#                                                                    #
# These hosts have legacy A records because they predate the managed #
# fleet.                                                             #
######################################################################

resource "google_dns_record_set" "wiki-legacy" {
  name         = "wiki.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["148.251.199.115"]
}

#######################
# GitHub Sites Record #
#######################

resource "google_dns_record_set" "homepage-github" {
  name         = google_dns_managed_zone.voidlinux-org.dns_name
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["185.199.109.153"]
}

resource "google_dns_record_set" "homepage-github-www" {
  name         = "www.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "A"
  ttl     = 300
  rrdatas = ["185.199.109.153"]
}

####################################################
# Service Names                                    #
#                                                  #
# This section should maintain alphabetical order. #
####################################################

resource "google_dns_record_set" "service-auto" {
  # Automatic Mirror directory
  name         = "auto.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-build" {
  # Builder web page
  name         = "build.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-docs" {
  # Documentation
  name         = "docs.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-infradocs" {
  # Infrastructure Documentation
  name         = "infradocs.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm2.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-netauth" {
  # Authentication Service
  name         = "netauth.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-sfo3-us.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-popcorn" {
  # PopCorn XBPS Stats system
  name         = "popcorn.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-sources" {
  # Sources site
  name         = "sources.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-terraform" {
  # Terraform service
  name         = "terraform.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm2.a-lej-de.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-xqapi" {
  # XBPS repodata API (xq-api)
  name         = "xq-api.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "service-man" {
  name         = "man.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

# This is a special service record which points ot the load balancer
# on e-sfo3-us. This in-turn ingresses to the rest of the fleet via
# the mesh network and Nomad.
resource "google_dns_record_set" "service-catchall" {
  name         = "*.s.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["e-sfo3-us.m.voidlinux.org."]
}


#######################################################################
# Mirror Records                                                      #
#                                                                     #
# These records are largely for failover when the more intelligent    #
# mirror router is unavailable.  This section should be hierarchical. #
#######################################################################

resource "google_dns_record_set" "mirror-de-1" {
  name         = "alpha.de.repo.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["a-hel-fi.m.voidlinux.org."]
}

resource "google_dns_record_set" "mirror-de-2" {
  name         = "beta.de.repo.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["void.nerdclub.org."]
}

resource "google_dns_record_set" "mirror-us-1" {
  name         = "alpha.us.repo.${google_dns_managed_zone.voidlinux-org.dns_name}"
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = ["vm1.a-mci-us.m.${google_dns_managed_zone.voidlinux-org.dns_name}"]
}

#######################################################################
# MX Records                                                          #
#                                                                     #
#######################################################################

resource "google_dns_record_set" "mx-mail-host" {
  name         = google_dns_managed_zone.voidlinux-org.dns_name
  managed_zone = google_dns_managed_zone.voidlinux-org.name

  type    = "MX"
  ttl     = 300
  rrdatas = ["10 vm3.a-lej-de.m.voidlinux.org."]
}
