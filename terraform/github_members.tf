######################
# GitHub Memberships #
######################

# You might expect that this file would contain a bunch of loops that
# compute what memberships people are supposed to have and then add
# them to it.  No, that would require Terraform to support sane state
# transitions which it doesn't.  In order to add or remove people in
# github, terraform nukes the membership and then adds everyone back
# as requested.

# Yes, this includes the organization owners.

# Literally the only thing that saved us while running this in setup
# was that GitHub's API won't let you delete yourself from the
# organization if you're the last man standing.  So now we have this
# expanded monstrosity which puts people in groups the long way round.

#######################
# Organization Owners #
#######################

resource "github_membership" "org-owner_gottox" {
  username = "Gottox"
  role = "admin"
}

resource "github_membership" "org-owner_duncaen" {
  username = "Duncaen"
  role = "admin"
}

resource "github_membership" "org-owner_the-maldridge" {
  username = "the-maldridge"
  role = "admin"
}

###################
# Void Operations #
###################

# These memberships belong to groups defined in github.tf.  These are
# sorted by lexical sort order keyed on the username.  This order is
# manually preserved, please be careful when editing.

resource "github_team_membership" "void-ops_duncaen" {
  team_id = "${github_team.void-ops.id}"
  role = "maintainer"
  username = "Duncaen"
}

resource "github_team_membership" "void-ops_gottox" {
  team_id = "${github_team.void-ops.id}"
  role = "maintainer"
  username = "Gottox"
}

resource "github_team_membership" "void-ops_vaelatern" {
  team_id = "${github_team.void-ops.id}"
  role = "maintainer"
  username = "Vaelatern"
}

resource "github_team_membership" "void-ops_the-maldridge" {
  team_id = "${github_team.void-ops.id}"
  role = "maintainer"
  username = "the-maldridge"
}

######################
# Package Committers #
######################

# These memberships belong to groups defined in github.tf.  These are
# sorted by lexical sort order keyed on the username.  This order is
# manually preserved, please be careful when editing.

# Maintainers

resource "github_team_membership" "pkg-committers_duncaen" {
  team_id = "${github_team.pkg-committers.id}"
  role = "maintainer"
  username = "Duncaen"
}

resource "github_team_membership" "pkg-committers_gottox" {
  team_id = "${github_team.pkg-committers.id}"
  role = "maintainer"
  username = "Gottox"
}

resource "github_team_membership" "pkg-committers_the-maldridge" {
  team_id = "${github_team.pkg-committers.id}"
  role = "maintainer"
  username = "the-maldridge"
}

# Members

resource "github_team_membership" "pkg-committers_vaelatern" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "Vaelatern"
}

resource "github_team_membership" "pkg-committers_asergi" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "asergi"
}

resource "github_team_membership" "pkg-committers_chneukirchen" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "chneukirchen"
}

resource "github_team_membership" "pkg-committers_hoshpak" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "Hoshpak"
}

resource "github_team_membership" "pkg-committers_jnbr" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "jnbr"
}

resource "github_team_membership" "pkg-committers_lemmi" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "lemmi"
}

resource "github_team_membership" "pkg-committers_maxice8" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "maxice8"
}

resource "github_team_membership" "pkg-committers_pullmoll" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "pullmoll"
}

resource "github_team_membership" "pkg-committers_thypon" {
  team_id = "${github_team.pkg-committers.id}"
  role = "member"
  username = "thypon"
}
