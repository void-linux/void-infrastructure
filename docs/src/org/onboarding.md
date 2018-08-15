# Onboarding

This section explains how new members are proposed, approved, and new
permissions are assigned.

## Proposing a New Member

Any existing member of the organization may propose a candidate.
Candidates are expected to have been an active part of the
organization for some time prior to proposing.

The proposal should take the form of written notice to the existing
team via some private channel.  Email is a good option for this.  The
mail should include the following information:

  * Candidate's name or well-known username
  * Candidate's contributions to Void, ideally as bullet points
  * A deadline by which comments should be provided, at least 1 week

After the comment period expires, the comments and final statements
should be reviewed.  Organization owners will have the final ability
to approve a proposal and to dismiss comments or objections to the
proposal.

If the proposal is approved, the candidate should be contacted, if
they agree to join the organization, proceed to the next section.

## Onboarding an Approved Candidate

Onboarding the candidate requires at minimum a member of
`netauth/terraform` to run the final commands that will add the new
candidate.  During the review approval process, a Void Ops lead should
have agreed to handle the proposals, they will ensure the following
steps are done.

A patch should be created for the void-infrastructure repo which adds
the candidate to the `github_members.tf` file.  This patch should be
sent to the repo as a pull request.  The pull request should contain
the same information as the email to internal team members, including
a comment period of at least one week.

At the conclusion of the comment period, a final decision will be made
to submit the patch or to rescind the invitation.  This decision is
made by agreement of the organization owners.  The default is to approve.

Unless the new member objects, a post should be made to voidlinux.org
welcoming them to the organization (a new member may not wish to have
this kind of attention immediately).

## Additional Powers

Once added to the organization, additional powers may need to be
delegated.  This should be discussed in the PR that added the
individual to the organization.

Additional powers include:
  * Forum Moderator status
  * NetAuth system account
  * NetAuth mail account
  * NetAuth group memberships

Consult the service specific documentation for how to apply additional
permissions as needed.
