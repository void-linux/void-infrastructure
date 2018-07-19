# nginx

Void's preferred webserver is nginx using drop in config fragments.
All nginx instances are managed by Ansible and have an Apache2 style
sites-available and sites-enabled directory structure in
`/etc/nginx/`.  Additionally an `/etc/nginx/locations.d/` exists for
each site to provide `location {}` fragments that may not be owned by
the same task that created the original site.

When possible, it is preferable to proxy web services through nginx to
do TLS termination and to abstract certificate handling away from
backend services.  Services that communicate via protocols that use
HTTP as a transport such as gRPC services do not need to use nginx as
a proxy.
