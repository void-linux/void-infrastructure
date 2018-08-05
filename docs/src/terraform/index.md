# Terraform

Not all infrastructure owned by the Void project is hosted on our
infrastructure or integrated into our systems.  For some
infrastructure we need to mirror data out to 3rd party systems.  This
is done with [HashiCorp Terraform](https://terraform.io).

Files for terraform end in `.tf` and live in the terraform
subdirectory of the infrastructure repo.  There is currently no
automation that pushes terraform state to remote systems.

# Important!

It is VERY IMPORTANT that only one Terraform push is in progress at a
time.  It is additionally VERY IMPORTANT that anyone pushing terraform
has up to date terraform state, and that this state is synced back to
other people who have it.  The state should be treated as secure since
terraform has a bad habbit of putting things in there it shouldn't.

We are currently evaluating Atlantis to push terraform state from a
central location.

# Setting Up

Terraform is configured to use remote state.  One-time configuration
is required to access this state:

Ensure that your netauth user is a member of `netauth/terraform`,
without access to this group you will not be able to access the
terraform state.

Change the terraform directory and run the following command:

```
$ terraform init --backend-config "username=<username>" --backend-config "password=<password>"
```

NOTE: This will cache your password to local disk.  This is a known
defect that will be resolved in Terraform 2.  Until then, either
remove your password from the .terraform/ cache files, or more
preferably, store the entire void-infrastructure repo on an EncFS, as
there is other sensitive content that winds up in gitignored
subdirectories of this repository.

## Obtaining Control Authority

Having access to state isn't sufficient.  You will also need a
Personal Access Token from GitHub, and access to the cloud service
account.  Obtain a token for your account, and contact another member
of the infrastructure team to obtain the service principal.  Place the
service principal in terraform/account.json, and the token in the
environment variable `GITHUB_TOKEN`.
