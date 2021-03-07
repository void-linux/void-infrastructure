# Nomad

Nomad is a cluster level job scheduler.  Nomad lets us pretend that
our various machines are part of one large pool of compute, and that
as we add and remove machines we don't have to edit as many task
definitions to account for the change in fleet resources.

Nomad also allows us to carve up machines so that different sevice
groups can be managed by different people, such as debuginfod having a
different level of access than the cron-job that signs packages.
Complete documentation for Nomad can be found in the upstream docs
site [here](https://learn.hashicorp.com/nomad).

To work with nomad you will need a nomad token which you can obtain
from vault:

```
export NOMAD_ADDR=https://nomad.s.voidlinux.org
vault read nomad/creds/<role>
```

By default nomad tokens are valid for 1 hour.  You can renew your
token until your vault session expires by using `vault lease renew
<lease ID>` where the lease ID is the value provided with the initial
token.
