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
$ netauth new-entity --ID <username> --number <number>
```

### Making an entity a valid shell user

Shell users have additional required attributes, these can be set
seperately:

```shell
$ netauth modify-meta --ID <username> --primary-group netusers --shell /bin/bash
```

For all users the primary group should be `netusers` and the shell
should generally be `/bin/bash`.  Additional fields may be set as
needed.

### Adding an entity to a group

Groups are used to gate access to all resources across the fleet.  For
example to add a new build operator who can unwedge the buildslaves,
the following command sets the appropriate groups:

```shell
$ netauth entity-membership --ID <username> --group build-ops --action add
```

### Adding and removing SSH keys

Adding and removing SSH keys is done with the netauth command.  The
default type of key is SSH.  When adding and removing keys the key
content needs to be quoted to avoid splitting by the shell.  When
removing keys the server will match keys on substrings, so technically
the key comment should be sufficient to remove it if it is unique.

```shell
$ netauth modify-keys --ID <username> --mode ADD --key "<key>"
```
