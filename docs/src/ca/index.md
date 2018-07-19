# Certificate Authority

Void operates a private certificate authority based on CloudFlare's
`cfssl` tool.  The configuration data for this CA lives in the `CA/`
directory of the infrastructure repo.

The certificates can be generated using the `bin/gencerts.sh` script.
They should be copied to the appropriate location in the
`ansible/secret` directory after being generated.  Once copied, use
`bin/shred.sh` in the `CA/` directory to clean up.

## LetsEncrypt vs Void CA

When the option exists to obtain a certificate dynamically from
LetsEncrypt, this option should be used.  Additionally any time a
certificate will be visible to an end user this certificate must have
a valid trust-root.  Since Void's CA isn't trusted by anything
automatically user facing certificates MUST be issued by an external
CA.

Void's CA should be used for infrastructure needs that require
certificates for authentication, or long lived certificates for
channel integrity.  Void Operations should be consulted before adding
any new certificate configurations or adjusting the CA configuration.
