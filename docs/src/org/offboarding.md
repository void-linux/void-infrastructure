# Offboarding

Sometimes people leave the project, either of their own volition or
with a helping hand.  Its very important to ensure that things are
done right and according to this process when someone leaves, so
please read it in full.

Cause for following these offboarding guidelines can take the form of
any of the following non-exhaustive list:

  * acted maliciously
  * have become inactive
  * wish to be removed
  * or any other reason that justifies the removal

## Proposing a Removal

Any current member of the Void Linux Organization can propose a
removal.  There are two ways this process may go depending on if the
removal candidate is also the requesting entity.

### Removing Yourself

If you'd like to remove yourself, contact an administrator of the
organization and state your request plainly.

  1. Contact an administrator via a private channel.
  2. The administrator will confirm the request via your registered
     email address.
  3. The administrator will file a PR to the void-infrastructure repo
     to be processed by void-ops.

If you're leaving the project permanently, attempting to find a
successor to maintain your packages is greatly appreciated.

### Removing Someone Else

Removing someone else is a more involved process and may require more
discussion.

**If you're proposing a security removal, escalate to void-ops
directly, these are processed immediately.**

  1. Send an email to an administrator via their registered email
     address.  This email should contain the person you believe should
     be removed and why.
  2. The administrator should contact the named individual and notify
     them of a removal request.  This should be done via the
     registered email.  This email must also contain a deadline of at
     least one week for the individual to make a statement.
  3. Any statement should be considered and discussed amongst the
     admins of the organization.  This may require pushing the
     deadline back.
  4. Once an agreement has been reached the removal will either
     proceed or be dropped.  In the case no agreement can be reached
     after a reasonable amount of time has passed and a sincere effort
     from both admins and the individual, dropping membership is the
     default resolution.
  5. A ticket is created for void-ops to process the removal.

## Ops Removal Checklist

Removing a member of the organization follows the following checklist
which can be copy/pasted into a markdown aware ticket.

  * Remove access from the GitHub organization via TerraForm
  * Remove all memberships in NetAuth, removing the NetAuth principal
    is optional, but discouraged.
  * Remove any moderator bits in the forum
  * Remove any moderator bits in the wiki
  * Remove any existing manually provisioned mail aliases

Preserving NetAuth entities seems a bit unusual, but it prevents
accidentally re-provisioning the name later, and the default groups
grant no non-public access.
