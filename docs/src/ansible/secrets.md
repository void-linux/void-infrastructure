# Secrets

Almost all of Void's configuration data is public.  Things that are
not public are referred to as "secrets".  This includes information
such as the buildbot login file, signing keys, various tokens that
authenticate services and so on.  This data lives in `ansible/secret`
and you must obtain a copy of this directory before trying to push to
any machine.

The format of files in the secret directory should be plain text for
files that are string secrets, or the native file format of the secret
in question.  Secret names should be of the form ROLENAME_SECRET so a
token signing key for the netauth service should be named
`netauth_token.key` in the secret directory and its file format should
be PEM encoded key data.

## Storing Secrets

Secrets should be encrypted when at rest.  It is advised to store
secrets in an EncFS directory which is mounted into the appropriate
location as needed.  Any encrypted system is acceptable here assuming
that it provides a normal filesystem view and supports strong
cryptography.

## Obtaining Secrets

Secrets should be held by as few people as possible, but no fewer than
2 at any given time.  Secrets should only be exchanged after positive
identity confirmation has been confirmed.  Transfer should then be
done via secure means, such as a copy made to a Void host and then
made visible via Unix file permissions.
