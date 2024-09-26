resource "digitalocean_domain" "voidlinux_org" {
  name = "voidlinux.org"
}


#########################################################################
# Apex Records                                                          #
#                                                                       #
# These records setup the apex resources for the domain, and must be    #
# carefully reviewed due to the slow propagation times of the connected #
# systems.                                                              #
#########################################################################

resource "digitalocean_record" "apex_www" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "@"
  value  = "185.199.109.153"
}

resource "digitalocean_record" "apex_www_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "@"
  value  = "2606:50c0:8000::153"
}

resource "digitalocean_record" "apex_mx" {
  domain   = digitalocean_domain.voidlinux_org.name
  type     = "MX"
  name     = "@"
  value    = "c-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
  priority = 10
}

resource "digitalocean_record" "apex_txt" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 mx a:c-hel-fi.m.voidlinux.org ~all"
}

##########################################################################
# Omniproxy                                                              #
#                                                                        #
# The Omniproxy is a record that points to any machine running nginx and #
# capable of serving requests that will ultimately terminate to          #
# somewhere inside Void's private network.  This doesn't refer to any    #
# single machine anywhere, and allows us to dynamically punt traffic     #
# around where and when machines are cycled into and out of service.  It #
# also means that if you reboot one of these machines traffic should     #
# continue to flow since most browsers are smart enough to retry failed  #
# requests to A records.                                                 #
##########################################################################

resource "digitalocean_record" "omniproxy" {
  for_each = toset([
    digitalocean_record.d_hel_fi.value,
    digitalocean_record.a_fra_de.value,
  ])

  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "omniproxy"
  value  = each.value
}

resource "digitalocean_record" "omniproxy_v6" {
  for_each = toset([
    digitalocean_record.b_hel_fi_v6.value,
    digitalocean_record.d_hel_fi_v6.value,
    digitalocean_record.a_fra_de_v6.value,
  ])

  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "omniproxy"
  value  = each.value
}

resource "digitalocean_record" "catchall" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "*.s.${digitalocean_domain.voidlinux_org.name}."
  value  = "omniproxy.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "catchall_apex" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "*.${digitalocean_domain.voidlinux_org.name}."
  value  = "omniproxy.${digitalocean_domain.voidlinux_org.name}."
}

#########################################################################
# Control Hosts                                                         #
#                                                                       #
# Void manages most of the fleet via a Hashicorp Nomad cluster that has #
# certain dependent services.  These services are pointed directly at   #
# the control plane which runs its own proxies distinct from the        #
# services that ingress via the omniproxy above.  The proxy running on  #
# the control hosts is also capable of proxying all traffic, but is not #
# part of the omniproxy alias above to reduce load.                     #
#########################################################################

resource "digitalocean_record" "control_proxy" {
  for_each = toset([
    digitalocean_record.b_sfo3_us.value,
    digitalocean_record.c_sfo3_us.value,
    digitalocean_record.d_sfo3_us.value,
  ])

  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "cproxy.${digitalocean_domain.voidlinux_org.name}."
  value  = each.value
}

resource "digitalocean_record" "control_pointer" {
  for_each = toset(["nomad", "consul", "vault"])

  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = each.value
  value  = "cproxy.${digitalocean_domain.voidlinux_org.name}."
}

##########################################################################
# Machines                                                               #
#                                                                        #
# These records point to all of the managed machines.  The naming        #
# convention is letters in alphabetical order ascending for every        #
# machine in the region, where the region is either the IATA code of the #
# nearest significant airport or the DC name in the event the DC campus  #
# has multiple sites numbered within each IATA code.  The final element  #
# of the name is the country code where the machines reside.             #
##########################################################################

resource "digitalocean_record" "a_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-hel-fi.m"
  value  = "95.216.76.97"
}

resource "digitalocean_record" "a_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "a-hel-fi.m"
  value  = "2a01:4f9:2b:c9e::2"
}

resource "digitalocean_record" "b_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "b-hel-fi.m"
  value  = "65.21.160.177"
}

resource "digitalocean_record" "b_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "b-hel-fi.m"
  value  = "2a01:4f9:4b:42dc::d01"
}

resource "digitalocean_record" "c_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "c-hel-fi.m"
  value  = "95.217.132.25"
}

resource "digitalocean_record" "c_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "c-hel-fi.m"
  value  = "2a01:4f9:c012:498a::2"
}

resource "digitalocean_record" "d_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "d-hel-fi.m"
  value  = "135.181.160.58"
}

resource "digitalocean_record" "d_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "d-hel-fi.m"
  value  = "2a01:4f9:3a:17d7::2"
}

resource "digitalocean_record" "e_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type = "A"
  name = "e-hel-fi.m"
  value = "95.216.161.173"
}

resource "digitalocean_record" "e_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "e-hel-fi.m"
  value  = "2a01:4f9:c010:ddfd::2"
}

resource "digitalocean_record" "f_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type = "A"
  name = "f-hel-fi.m"
  value = "65.21.149.215"
}

resource "digitalocean_record" "f_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "f-hel-fi.m"
  value  = "2a01:4f9:c012:7a9e::2"
}

resource "digitalocean_record" "g_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type = "A"
  name = "g-hel-fi.m"
  value = "95.217.130.28"
}

resource "digitalocean_record" "g_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "g-hel-fi.m"
  value  = "2a01:4f9:c012:65::2"
}

resource "digitalocean_record" "h_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type = "A"
  name = "h-hel-fi.m"
  value = "65.21.145.134"
}

resource "digitalocean_record" "h_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "h-hel-fi.m"
  value  = "2a01:4f9:c012:8db::2"
}

resource "digitalocean_record" "i_hel_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type = "A"
  name = "i-hel-fi.m"
  value = "95.216.191.60"
}

resource "digitalocean_record" "i_hel_fi_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "i-hel-fi.m"
  value  = "2a01:4f9:c012:be3::2"
}

resource "digitalocean_record" "a_fra_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-fra-de.m"
  value  = "212.83.43.28"
}

resource "digitalocean_record" "a_fra_de_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "a-fra-de.m"
  value  = "2a00:f48:2000:1031::3"
}

resource "digitalocean_record" "a_fsn_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-fsn-de.m"
  value  = "138.201.204.130"
}

resource "digitalocean_record" "a_fsn_de_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "a-fsn-de.m"
  value  = "2a01:4f8:173:1481::2"
}

resource "digitalocean_record" "b_fsn_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "b-fsn-de.m"
  value  = "168.119.90.174"
}

resource "digitalocean_record" "b_fsn_de_v6" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "AAAA"
  name   = "b-fsn-de.m"
  value  = "2a01:4f8:251:5391:5054:ff:fe89:6714"
}

resource "digitalocean_record" "a_lej_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-lej-de.m"
  value  = "136.243.133.13"
}

resource "digitalocean_record" "vm3_a_lej_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "vm3.a-lej-de.m"
  value  = "148.251.199.113"
}

resource "digitalocean_record" "b_lej_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "b-lej-de.m"
  value  = "78.46.212.193"
}

resource "digitalocean_record" "a_sfo3_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-sfo3-us.m"
  value  = digitalocean_droplet.a_sfo3_us.ipv4_address
}

resource "digitalocean_record" "b_sfo3_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "b-sfo3-us.m"
  value  = digitalocean_droplet.b_sfo3_us.ipv4_address
}

resource "digitalocean_record" "c_sfo3_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "c-sfo3-us.m"
  value  = digitalocean_droplet.c_sfo3_us.ipv4_address
}

resource "digitalocean_record" "d_sfo3_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "d-sfo3-us.m"
  value  = digitalocean_droplet.d_sfo3_us.ipv4_address
}

#######################################################################
# Services                                                            #
#                                                                     #
# These services, with the exception of the website itself, are all   #
# just CNAMEs onto other machines defined above.                      #
#######################################################################

resource "digitalocean_record" "build" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "build"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "devspace" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "devspace"
  value  = "d-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "devspace_sftp" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "devspace-sftp"
  value  = "d-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "mx1" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "mx1"
  value  = "${digitalocean_record.c_hel_fi.fqdn}."
}

resource "digitalocean_record" "netauth" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "netauth"
  value  = "a-sfo3-us.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "popcorn" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "popcorn"
  value  = "d-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "www"
  value  = "185.199.109.153"
}

resource "digitalocean_record" "xbps_api_docs" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "xbps-api-docs"
  value  = "void-linux.github.io."
}

resource "digitalocean_record" "xmirror" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "xmirror"
  value  = "void-linux.github.io."
}

################################################################
# Mirrors                                                      #
#                                                              #
# We have a few mirrors that get special names, those go here. #
################################################################

# Default repo, can be repointed as necessary
resource "digitalocean_record" "repo_default" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-default.${digitalocean_domain.voidlinux_org.name}."
  value  = "repo-fi.voidlinux.org."
}

# CI repo, can be repointed as necessary
resource "digitalocean_record" "repo_ci" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-ci.${digitalocean_domain.voidlinux_org.name}."
  value  = "repo-fi.voidlinux.org."
}

# Sync repo that other origins default to, can be repointed as
# necessary
resource "digitalocean_record" "repo_sync" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-sync.${digitalocean_domain.voidlinux_org.name}."
  value  = "repo-fi.voidlinux.org."
}

resource "digitalocean_record" "repo_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-de.${digitalocean_domain.voidlinux_org.name}."
  value  = "a-fra-de.m.voidlinux.org."
}

resource "digitalocean_record" "repo_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-fi.${digitalocean_domain.voidlinux_org.name}."
  value  = "d-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-us.${digitalocean_domain.voidlinux_org.name}."
  value  = "b-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_fastly" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-fastly"
  value  = "dualstack.n.sni.global.fastly.net."
}

###################################################################
# Verification Records                                            #
#                                                                 #
# Some services want to have long-lived validation records in DNS #
###################################################################

resource "digitalocean_record" "verification_github" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "TXT"
  name   = "_github-challenge-void-linux"
  value  = "3dc3629c19"
}

resource "digitalocean_record" "verification_fastly" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "_acme-challenge.repo-fastly"
  value  = "q355elndt9ih044oyf.fastly-validations.com."
}

#################################################################
# Email Records                                                 #
#                                                               #
# These are for the myriad of things that attempt to make email #
# some semblance of secure.                                     #
#################################################################

resource "digitalocean_record" "_dmarc" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "TXT"
  name   = "_dmarc.${digitalocean_domain.voidlinux_org.name}."
  value  = "v=DMARC1; p=quarantine; ruf=mailto:postmaster@voidlinux.org"
}

resource "digitalocean_record" "__dkim" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "TXT"
  name   = "default._domainkey.${digitalocean_domain.voidlinux_org.name}"
  value  = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArgfWwtFQp4PzJSXCIkPvaID+PiiZhloR0u/A5XylUQfmR4w/JvAbsPLbXNRPJXPihSyBrzh4hRk2k6Sq66yBIk9qOKoV4dgQJnAkTrvoNMfSVPjVCd9yYQcShZOOw4/g/zQM1RJA0uf8N4V8hmQ3/gFr8M2QRLdnYl8f99XkFS5099SZKZ36E2zWeYK9nMwepGhtlTEuQoI0y7FWm1p8+r33vt2Sol1EuG+A0EC5r/qJAwB78Dac0JChbWaPrj1ZqBhnBP57bh8Zq3Vx+4s6IBqg8HCRn6jhxjng/ql20ppviC9Xxa9hpFiT2drszFcbMhq4IlQLkXBD7SILvDGlmwIDAQAB"
}
