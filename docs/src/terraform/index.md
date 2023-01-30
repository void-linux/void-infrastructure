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

Export the following variables in order to authenticate your access to
the remote state storage.  These are your [netauth
credentials](../services/netauth.html):

```
TF_HTTP_USERNAME=<entity-id>
TF_HTTP_PASSWORD=<entity-pw>
```

Change the terraform project directory and run the following command:

```
$ terraform init
```

## Obtaining Control Authority

Having access to state isn't sufficient.  Depending on what projects
you're wishing to manage, you may need any of the following additional
credentials:

  * GitHub Personal Access Token (PAT) exported as `GITHUB_TOKEN`
  * Fastly API Token exported as `FASTLY_API_KEY`
  * DigitalOcean API Token exported as `DIGITALOCEAN_API_TOKEN`
  * Vault Token at either `~/.vault-token` or `VAULT_TOKEN`
  * Nomad Token exported as `NOMAD_TOKEN`
  * Consul Token exported as `CONSUL_HTTP_TOKEN`

These variables and keys are in addition to the state access which
must be initialized individually per project.
