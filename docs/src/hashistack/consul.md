# Consul

Void uses Consul as our service discovery layer.  As most of our
services are not actually clustered or service discovery aware, this
primarily means that we use Consul's DNS mechanism to provide internal
DNS that is topology aware.

Our Consul system is configured with default deny ACLs, so any
application that needs to make use of consul must have a corresponding
ACL that grants it access.

More information can be found on the [Consul
Website](https://consul.io).
