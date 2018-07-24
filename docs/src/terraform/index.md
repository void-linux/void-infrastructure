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
