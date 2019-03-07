# GitHub

GitHub only provides an interface to sync data from LDAP, and even
then only if using the enterprise version.  Since Void is an open
source project and isn't using this option, we don't sync data.  The
organization at github.com/void-linux has very little state, primarily
users and groups.

## Groups

There are currently three groups that gate access into GitHub resources:

### pkg-committers

Members of this group have broad commit access and can generally push
to any Void owned repo.  The primary reason for people to gain access
to this group is to be able to push package templates.  Access to this
group should be assumed to contain the ability to trigger builds that
will eventually be signed for inclusion in the main repo.

### void-ops

Membership into this group is highly restricted and should generally
not be authorized without a signoff from an infrastructure lead or
`maldridge@`.  This group gates access to the infrastructure repo
itself, and is restricted to prevent accidental breakage from pushing
something that is later pushed by automation that performs change
detection against the state of the repo.

### doc-writers

Members of this group have access to push changes into the
[void-docs](https://github.com/void-linux/void-docs)
repository which is responsible for holding all content that appears
on our [handbook](docs.voidlinux.org).

## Adding and Removing Members

Adding and removing members takes place in `github_members.tf`.  This
file contains a stanza for every user and every group they are in.  To
change membership of a group add or remove a stanza, then apply the
state transformation to GitHub.

This file is manually formatted, take care to maintain lexical sort
ordering and indentation.  For example if a new committer with
username voidfu was to be added, a new stanza as follows would be
added to the file:

```
resource "github_team_membership" "pkg-committers_voidfu" {
  team_id = "${github_team.pkg-committers.id}"
  role = "maintainer"
  username = "voidfu"
}
```

The name placed in the resource line should always be lower case.  The
name that appears in the username should be an exact match for the
username shown on the user's profile page.

## Pushing state changes

Pushing a state change can only be done by organization owners.  To
request a push of terraform state, request action from one of:

    * the-maldridge
    * gottox
    * duncaen

It is very important that only one push be in progress at a time.  To
this end, anyone making a push should endeavor to determine no other
changes are in motion, manual or terraformed.

### Authenticating to GitHub for Push

Github needs authentication to authorize the push.  This takes the
format of a personal access token.  The token must contain sufficient
permissions to add and remove people from the organization, add and
remove repositories, and add and remove groups.  The token should be
stored in the environment variable `GITHUB_TOKEN`.

### Pushing the Changes

Pushing the changes is done in two phases.  The first phase is a
planning phase.  In this phase call terraform as shown:

```
$ terraform plan
```

Verify that the output is sane, it will provide a diff of any action
that terraform wants to take.  This should be very simple to
understand what is going to happen because you shouldn't push large
changes, instead prefer to push incremental changes in succession.

When you are satisfied with the planned actions, apply them:

```
$ terraform apply
```

You'll be asked to confirm the application of state.  If you're
satisfied, apply the state.  Terraform is not like Ansible, be careful
that you don't remove people from the organization or clear
permissions that you can't put back without assistance.
