# Vault

Vault serves as a dedicated storage point for secret values such as
the signing keys for repos, authentication tokens to 3rd party
services, and as an authentication nexus between short lived API
tokens and long lived NetAuth credentials.

To log into vault you will need a NetAuth account, and may then log in
using the following command:

```
export VAULT_ADDR=https://vault.voidlinux.org
vault login -method=ldap username=<you>
```

This will prompt you for your password and request a vault token valid
for a maximum of 12 hours.  You don't need to do anything to actually
use the vault token, all software that is Vault aware will natively
pick up your authority.  After the 12 hours has expired you will need
to log in again to refresh your session.

If you wish to explicitly revoke your token, for example logging off
for the day, you may do so with the command `vault token revoke -self`
which will request immediate revocation.
