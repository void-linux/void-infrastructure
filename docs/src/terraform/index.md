# Terraform

Not all infrastructure owned by the Void project is hosted on our
infrastructure or integrated into our systems.  For some
infrastructure we need to mirror data out to 3rd party systems.  This
is done with [HashiCorp Terraform](https://terraform.io).

Files for terraform end in `.tf` and live in the terraform
subdirectory of the infrastructure repo.  There is currently no
automation that pushes terraform state to remote systems.
