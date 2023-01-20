# Fastly

Fastly sponsors a CDN which fronts the main packages colletion and
other artifacts we serve from the mirrors.

The distribution is configured to answer to
`repo-fastly.voidlinux.org` and uses a certificate from Lets Encrypt.
The origin data is served from all mirrors by requesting the
`repo-fastly` name from nginx, which is the same virtual host as the
other tier one mirrors.
