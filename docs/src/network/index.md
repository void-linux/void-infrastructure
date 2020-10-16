# Network Architecture

Void's global network is based on a Wireguard mesh between all
servers.  The network does not support ECMP.  The mesh is statically
computed by Ansible and is installed into the fleet when machines are
added or removed.

The primary use case of the mesh is to allow us to run services that
expect to be inside of a single broadcast domain without expending
significant effort to enable machine to machine communication.  As
such, most services should be accessed via HTTP proxies rather than
connecting to the mesh directly.
