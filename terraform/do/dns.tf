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

resource "digitalocean_record" "apex_mx" {
  domain   = digitalocean_domain.voidlinux_org.name
  type     = "MX"
  name     = "@"
  value    = "vm3.a-lej-de.m.${digitalocean_domain.voidlinux_org.name}."
  priority = 10
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

resource "digitalocean_record" "a_fsn_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-fsn-de.m"
  value  = "138.201.204.130"
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

resource "digitalocean_record" "c_lej_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "c-lej-de.m"
  value  = "5.9.152.66"
}

resource "digitalocean_record" "a_mci_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "a-mci-us.m"
  value  = "199.168.97.186"
}

resource "digitalocean_record" "vm1_a_mci_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "vm1.a-mci-us.m"
  value  = "198.204.250.219"
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

resource "digitalocean_record" "e_sfo3_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "e-sfo3-us.m"
  value  = digitalocean_droplet.e_sfo3_us.ipv4_address
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
  value  = "b-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "devspace_sftp" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "devspace-sftp"
  value  = "b-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "docs" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "docs"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "infradocs" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "infradocs"
  value  = "${digitalocean_record.e_sfo3_us.fqdn}."
}

resource "digitalocean_record" "man" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "man"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
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
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "sources" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "sources"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "wiki" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "wiki"
  value  = "e-sfo3-us.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "A"
  name   = "www"
  value  = "185.199.109.153"
}

resource "digitalocean_record" "xqapi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "xq-api"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

# Catchall which points at the dynamic load balancers, this is going
# to match if nothing else above does.
resource "digitalocean_record" "catchall" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "*.s.${digitalocean_domain.voidlinux_org.name}."
  value  = "e-sfo3-us.m.${digitalocean_domain.voidlinux_org.name}."
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

resource "digitalocean_record" "repo_fi" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-fi.${digitalocean_domain.voidlinux_org.name}."
  value  = "b-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "repo-us.${digitalocean_domain.voidlinux_org.name}."
  value  = "a-mci-us.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_alpha_de" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "alpha.de.repo"
  value  = "a-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_alpha_us" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "alpha.us.repo"
  value  = "vm1.a-mci-us.m.${digitalocean_domain.voidlinux_org.name}."
}

resource "digitalocean_record" "repo_shadow" {
  domain = digitalocean_domain.voidlinux_org.name
  type   = "CNAME"
  name   = "shadow.repo"
  value  = "b-hel-fi.m.${digitalocean_domain.voidlinux_org.name}."
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
