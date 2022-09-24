# NetAuth

NetAuth provides all the authentication and authorization information
to systems within Void's managed fleet.  NetAuth is an open source
project with a website at [https://netauth.org](https://netauth.org).

Full documentation and usage information for NetAuth can be found at
[docs.netauth.org](https://docs.netauth.org).

## Architecture

Void's deployment has a NetAuth server hosted on a dedicated VM which
uses certificates from the Void CA for transport security.  The server
is configured to use the ProtoDB storage engine and is backed up
regularly by manual action.  Automatic backups are not deemed
necessary at this time since the information changes infrequently.

The primary NetAuth server can be reached at `netauth.voidlinux.org`
on port `8443` and uses TLS for all connections.

## Remote Linux Systems

Linux systems that need to derive authentication and authorization
information are configured to use a combination of pam_netauth and
nsscache to provide required services.  The authentication information
is cached to local systems on use by the PAM Policycache and refreshed
periodically.  The grooup and authorization information is cached
every 30 minutes to disk on all machines.  Keys for systems such as
SSH are requested on-demand via a helper binary `netkeys` which does
not perform any caching.

While less than ideal, Void could operate for an extended period of
time without the primary NetAuth server running.

## Basic Administration

NetAuth uses a capability based system for administration of itself.
Members of group `dante` have permissions to make changes on behalf of
other users and generally should be the only people making changes to
the directory.

### Adding a New User

When adding a new user make sure to specify the username and number to
ensure the number is in the range that will be cached by nsscached.

```shell
$ netauth entity create <username> --number <number>
```

### Making an entity a valid shell user

Shell users have additional required attributes, these can be set
seperately:

```shell
$ netauth entity update <username> --primary-group netusers --shell /bin/bash
```

For all users the primary group should be `netusers` and the shell
should generally be `/bin/bash`.  Additional fields may be set as
needed.

### Adding an entity to a group

Groups are used to gate access to all resources across the fleet.  For
example to add a new build operator who can unwedge the buildslaves,
the following command sets the appropriate groups:

```shell
$ netauth entity membership <username> ADD build-ops
```

### Adding and removing SSH keys

Adding and removing SSH keys is done with the netauth command.  The
default type of key is SSH.  When adding and removing keys the key
content needs to be quoted to avoid splitting by the shell.  When
removing keys the server will match keys on substrings, so technically
the key comment should be sufficient to remove it if it is unique.

```shell
$ netauth entity key add SSH "<key>"
```

## Basic user interaction

### Initial configuration

An initial config file for NetAuth can be obtained from the [void-infrastructure
repository](https://github.com/void-linux/void-infrastructure/blob/master/ansible/roles/netauth-config/files/config.toml).
It can be stored in `~/.netauth/config.toml`, for example, and should be
modified so that the `tls.certificate` key points to a file containing the
certificate for the <netauth.voidlinux.org> domain.  The certificate can be
obtained one of two ways shown below:

```shell
$ openssl s_client -showcerts -connect netauth.voidlinux.org:1729 </dev/null | openssl x509 -outform pem
```

or

```shell
$ cfssl certinfo -domain netauth.voidlinux.org:1729 | jq --raw-output .pem
```

At that point, the password can be set with [netauth auth
change-secret](https://docs.netauth.org/commands/netauth_auth_change-secret.html).

### Setting the entity ID

Netauth uses the system username as the entity ID for netauth operations.
In some cases, the netauth entity ID for a user may be different from the system username.
To override this, use the `--entity` flag or set the `NETAUTH_ENTITY` environment variable.
