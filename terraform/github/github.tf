locals {
  github_repos = {
    #####################
    # Core Repositories #
    #####################
    void-infrastructure = {
      description        = "Infrastructure configuration data for Void systems"
      homepage_url       = "https://voidlinux.org"
      allow_merge_commit = false
      # The infrastructure repo is special and has restricted push so that
      # its harder to accidentally break systems that are subscribed to
      # it.
      teams = [
        "void-ops",
      ]
    }


    void-packages = {
      description        = "The Void source packages collection"
      homepage_url       = "https://voidlinux.org"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "pkg-committers",
      ]
      topics = [
        "hacktoberfest",
      ]
    }

    void-mklive = {
      description        = "The Void Linux live image maker"
      homepage_url       = "https://voidlinux.org"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "pkg-committers",
      ]
    }

    void-docs = {
      description        = "mdbook source for docs.voidlinux.org"
      homepage_url       = "https://docs.voidlinux.org"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "doc-writers",
        "pkg-committers",
      ]
      topics = [
        "hacktoberfest",
      ]
    }

    void-wiki = {
      description  = "Components for wiki.voidlinux.org"
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    void-texlive = {
      description  = "Components for packaging TeX into XBPS"
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    void-runit = {
      description        = "runit init scripts for Void"
      homepage_url       = "https://voidlinux.org"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "pkg-committers",
      ]
    }

    void-updates = {
      description  = "Update check system for void-packages"
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    void-docker = {
      description  = "Docker images for Void Linux"
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    socklog-void = {
      description  = "SockLog configuration for Void Linux"
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    xbps = {
      description  = "The X Binary Package System (XBPS)"
      homepage_url = "https://voidlinux.org/xbps/"
      teams = [
        "xbps-developers",
      ]
    }

    xbps-bulk = {
      description  = "Builds a set of packages that need to be updated with inter-dependencies."
      homepage_url = "https://voidlinux.org"
      teams = [
        "pkg-committers",
      ]
    }

    runit = {
      description        = "The init system for Void Linux."
      homepage_url       = "https://voidlinux.org"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "runit-devs",
      ]
    }

    ###########################
    # Auxilliary Repositories #
    ###########################
    ircbot = {
      description        = "Void's IRC Notification Bot"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "void-ops",
      ]
    }

    repo-exporter = {
      description        = "Prometheus exporter for XBPS Repos"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "void-ops",
      ]
    }

    man-site = {
      description         = "Components related to man.voidlinux.org"
      allow_merge_commit  = false
      allow_squash_commit = false
      teams = [
        "pkg-committers",
      ]
    }

    netbsd-wtf = {
      description = "NetBSD's wtf(6) adapted for Void Linux"
      teams = [
        "pkg-committers",
      ]
    }

    libglob = {
      description = "BSD glob(3) implementation with non-POSIX features"
      teams = [
        "pkg-committers",
      ]
    }

    jbigkit-shared = {
      description = "Autotools and libtool for JBIG-KIT version 2.1"
      teams = [
        "pkg-committers",
      ]
    }

    musl-obstack = {
      description = "A standalone library to implement GNU libc's obstack"
      teams = [
        "pkg-committers",
      ]
    }

    musl-fts = {
      description = "Implementation of fts(3) for musl libc packages in Void Linux"
      teams = [
        "pkg-committers",
      ]
    }

    openbsd-man = {
      description = "The OpenBSD man(1) utility for Linux"
      has_issues  = true
      archived    = true
      teams = [
        "pkg-committers",
      ]
    }

    xmandump = {
      description        = "Dump all manpages in an XBPS package for use with man.cgi"
      allow_merge_commit = false
      allow_squash_merge = false
      teams = [
        "pkg-committers",
      ]
    }
  }
}

resource "github_repository" "repositories" {
  for_each = local.github_repos

  name               = each.key
  description        = each.value.description
  has_issues         = true
  homepage_url       = lookup(each.value, "homepage_url", null)
  allow_merge_commit = lookup(each.value, "allow_merge_commit", null)
  allow_squash_merge = lookup(each.value, "allow_squash_merge", null)
  archived           = lookup(each.value, "archived", null)
  topics = flatten([["voidlinux"], lookup(each.value, "topics", [])])

  vulnerability_alerts = true
}

resource "github_team_repository" "team_repositories" {
  for_each = { for i in flatten([for repo_name, repo in local.github_repos :
    [for team_name in repo.teams : { repo_name = repo_name, team_name = team_name }]
  ]) : "${i.repo_name}_${i.team_name}" => i }

  team_id    = github_team.teams[each.value.team_name].id
  repository = github_repository.repositories[each.value.repo_name].name
  permission = "push"
}

# The website is special, it needs a pages block and generally other
# stuff that nothing else needs.
resource "github_repository" "void_linux_github_io" {
  name                 = "void-linux.github.io"
  description          = "Void Linux website"
  homepage_url         = "https://voidlinux.org"
  has_issues           = true
  vulnerability_alerts = true

  topics = [
    "voidlinux",
    "hacktoberfest",
  ]

  pages {
    cname = "voidlinux.org"

    source {
      branch = "master"
      path   = "/"
    }
  }
}

resource "github_team_repository" "void_linux_github_io_webmasters" {
  team_id    = github_team.teams["webmasters"].id
  repository = github_repository.void_linux_github_io.name
  permission = "push"
}
