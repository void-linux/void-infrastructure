#######################
# Organization Owners #
#######################

resource "github_membership" "org-owner_gottox" {
  username = "Gottox"
  role     = "admin"
}

resource "github_membership" "org-owner_duncaen" {
  username = "Duncaen"
  role     = "admin"
}

resource "github_membership" "org-owner_the-maldridge" {
  username = "the-maldridge"
  role     = "admin"
}

######################
# GitHub Memberships #
######################

locals {
  github_teams = {
    pkg-committers = {
      description = "The people with push access"
      maintainers = [
        "Duncaen",
        "Gottox",
        "the-maldridge",
      ]
      members = [
        "Chocimier",
        "Hoshpak",
        "Johnnynator",
        "Piraty",
        "Vaelatern",
        "abenson",
        "ahesford",
        "ericonr",
        "jnbr",
        "leahneukirchen",
        "lemmi",
        "pullmoll",
        "q66",
        "sgn",
        "thypon",
      ]
    }

    xbps-developers = {
      description = "The people that build XBPS"
      maintainers = [
        "Duncaen",
      ]
    }

    void-ops = {
      description = "Infrastructure Operators"
      maintainers = [
        "Duncaen",
        "Gottox",
        "Vaelatern",
        "the-maldridge",
      ]
    }

    doc-writers = {
      description = "Document Writers"
      maintainers = [
        "the-maldridge",
      ]
      members = [
        "bobertlo",
        "ericonr",
      ]
    }

    webmasters = {
      description = "Reviewers for voidlinux.org"
      maintainers = [
        "Duncaen",
        "Gottox",
        "the-maldridge",
      ]
      members = [
        "Vaelatern",
      ]
    }

    runit-devs = {
      description = "Maintainers of runit"
      maintainers = [
        "Duncaen",
        "Gottox",
        "the-maldridge",
      ]
      members = [
        "ericonr",
      ]
    }
  }
}

resource "github_team" "teams" {
  for_each = local.github_teams

  name        = each.key
  description = each.value.description
  privacy     = "closed"
}

resource "github_team_membership" "team_membership" {
  for_each = { for i in flatten([for team_name, team in local.github_teams : [
    [for username in lookup(team, "maintainers", []) : { team_name = team_name, role = "maintainer", username = username }],
    [for username in lookup(team, "members", []) : { team_name = team_name, role = "member", username = username }],
  ]]) : "${i.team_name}_${i.username}" => i }

  team_id  = github_team.teams[each.value.team_name].id
  role     = each.value.role
  username = each.value.username
}
