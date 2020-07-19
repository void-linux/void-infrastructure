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
time.  We use a central state and lock server to ensure this happens,
but occasionally there are changes that have been pushed but not
merged yet.  Always ensure that the diff that terraform offers is what
you expected it to be.

# Setting Up

Terraform is configured to use remote state.  One-time configuration
is required to access this state:

Ensure that your netauth user is a member of the appropriate NetAuth
group for the project you want to act on.  Presently, all projects are
in the prod namespace and membership in the `netauth/terrastate-prod`
group is required.  Without access to this group you will not be able
to access the terraform state.

Change the terraform directory and run the following command:

```
$ terraform init --backend-config "username=<username>" --backend-config "password=<password>"
```

NOTE: This will cache your password to local disk.  This is a known
defect.

## Obtaining Control Authority

Having access to state isn't sufficient.  You will also need a
Personal Access Token from GitHub, and access to the cloud service
account.  Obtain a token for your account, and contact another member
of the infrastructure team to obtain the service principal.  Place the
service principal in terraform/account.json, and the token in the
environment variable `GITHUB_TOKEN`.
