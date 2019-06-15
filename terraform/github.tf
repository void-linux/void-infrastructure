provider "github" {
  organization = "void-linux"
}

#####################
# Core Repositories #
#####################
resource "github_repository" "void-infrastructure" {
  name        = "void-infrastructure"
  description = "Infrastructure configuration data for Void systems"
  has_issues = true
  homepage_url = "https://voidlinux.org"
  allow_merge_commit = false
}

resource "github_repository" "void-packages" {
  name        = "void-packages"
  description = "The Void source packages collection"
  has_issues = true
  homepage_url = "https://voidlinux.org"
  allow_merge_commit = false
  allow_squash_merge = false
}

resource "github_repository" "void-mklive" {
  name = "void-mklive"
  description = "The Void Linux live image maker"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "void-docs" {
  name = "void-docs"
  description = "mdbook source for docs.voidlinux.org"
  has_issues = true
  homepage_url = "https://docs.voidlinux.org"
  allow_merge_commit = false
  allow_squash_merge = false
}

resource "github_repository" "void-wiki" {
  name = "void-wiki"
  description = "Components for wiki.voidlinux.org"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "void-texlive" {
  name = "void-texlive"
  description = "Components for packaging TeX into XBPS"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "void-runit" {
  name = "void-runit"
  description = "runit init scripts for Void"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "void-updates" {
  name = "void-updates"
  description = "Update check system for void-packages"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "void-linux-website" {
  name = "void-linux.github.io"
  description = "Void Linux website"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "socklog-void" {
  name = "socklog-void"
  description = "SockLog configuration for Void Linux"
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

resource "github_repository" "xbps" {
  name = "xbps"
  description = "The X Binary Package System"
  has_issues = true
  homepage_url = "https://voidlinux.org/xbps/"
}

resource "github_repository" "xbps-bulk" {
  name = "xbps-bulk"
  description = "Builds a set of packages that need to be updated with inter-dependencies."
  has_issues = true
  homepage_url = "https://voidlinux.org"
}

###########################
# Auxilliary Repositories #
###########################

resource "github_repository" "netbsd-wtf" {
  name = "netbsd-wtf"
  description = "NetBSD's wtf(6) adapted for Void Linux"
  has_issues = true
}

resource "github_repository" "libglob" {
  name = "libglob"
  description = "BSD glob(3) implementation with non-POSIX features"
  has_issues = true
}

resource "github_repository" "jbigkit-shared" {
  name = "jbigkit-shared"
  description = "Autotools and libtool for JBIG-KIT version 2.1"
  has_issues = true
}

resource "github_repository" "musl-obstack" {
  name = "musl-obstack"
  description = "A standalone library to implement GNU libc's obstack"
  has_issues = true
}

resource "github_repository" "musl-fts" {
  name = "musl-fts"
  description = "Implementation of fts(3) for musl libc packages in Void Linux"
  has_issues = true
}

resource "github_repository" "openbsd-man" {
  name = "openbsd-man"
  description = "The OpenBSD man(1) utility for Linux"
  has_issues = true
}

#########
# Teams #
#########

resource "github_team" "pkg-committers" {
  name = "pkg-committers"
  description = "The people with push access"
  privacy = "closed"
}

resource "github_team" "xbps-developers" {
  name = "xbps-developers"
  description = "The people that build XBPS"
  privacy = "closed"
}

resource "github_team" "void-ops" {
  name = "void-ops"
  description = "Infrastructure Operators"
  privacy = "closed"
}

resource "github_team" "doc-writers" {
  name = "doc-writers"
  description = "Document Writers"
  privacy = "closed"
}

resource "github_team" "webmasters" {
  name = "webmasters"
  description = "Reviewers for voidlinux.org"
  privacy = "closed"
}

###############
# Memberships #
###############

# See github_members.tf.

##########################
# Membership Permissions #
##########################

resource "github_team_repository" "repo-void-infrastructure" {
  # The infrastructure repo is special and has restricted push so that
  # its harder to accidentally break systems that are subscribed to
  # it.
  team_id    = "${github_team.void-ops.id}"
  repository = "${github_repository.void-infrastructure.name}"
  permission = "push"
}

resource "github_team_repository" "void-packages" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-packages.name}"
  permission = "push"
}

resource "github_team_repository" "void-mklive" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-mklive.name}"
  permission = "push"
}

resource "github_team_repository" "void-docs" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-docs.name}"
  permission = "push"
}

resource "github_team_repository" "void-docs-dedicated" {
  # Document writers are also allowed to merge to the void-docs
  # repository.
  team_id    = "${github_team.doc-writers.id}"
  repository = "${github_repository.void-docs.name}"
  permission = "push"
}

resource "github_team_repository" "void-wiki" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-wiki.name}"
  permission = "push"
}

resource "github_team_repository" "void-texlive" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-texlive.name}"
  permission = "push"
}

resource "github_team_repository" "void-runit" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-runit.name}"
  permission = "push"
}

resource "github_team_repository" "void-updates" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.void-updates.name}"
  permission = "push"
}

resource "github_team_repository" "void-linux-website" {
  team_id    = "${github_team.webmasters.id}"
  repository = "${github_repository.void-linux-website.name}"
  permission = "push"
}

resource "github_team_repository" "socklog-void" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.socklog-void.name}"
  permission = "push"
}

resource "github_team_repository" "xbps" {
  team_id    = "${github_team.xbps-developers.id}"
  repository = "${github_repository.xbps.name}"
  permission = "push"
}

resource "github_team_repository" "xbps-bulk" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.xbps-bulk.name}"
  permission = "push"
}

resource "github_team_repository" "netbsd-wtf" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.netbsd-wtf.name}"
  permission = "push"
}

resource "github_team_repository" "libglob" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.libglob.name}"
  permission = "push"
}

resource "github_team_repository" "jbigkit-shared" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.jbigkit-shared.name}"
  permission = "push"
}

resource "github_team_repository" "musl-obstack" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.musl-obstack.name}"
  permission = "push"
}

resource "github_team_repository" "musl-fts" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.musl-fts.name}"
  permission = "push"
}

resource "github_team_repository" "openbsd-man" {
  team_id    = "${github_team.pkg-committers.id}"
  repository = "${github_repository.openbsd-man.name}"
  permission = "push"
}
