# HashiStack

Void's fleet and desire for services makes it impractical to ask every
contributor to understand how the Ansible playbooks are laid out and
how the fleet is architected.  It is also brittle from a services
perspective to host important things in only one machine with no
fallback capability.  To solve these problems Void uses the Hashicorp
stack to enable dynamic workloads scheduled across the fleet, and to
enable updates to be decoupled from package updates leading to a more
stable infrastructure ecosystem.

More information about the individual services can be found on their
specific pages.  The remainder of this document speaks in general
terms about the architecture of Void's cluster.

## The Global Namespace

Void runs a single large global namespace, rather than segmenting our
fleet into "datacenters".  This is largely a result of the small
number of machines we have in each region, but also reflects that
Void's fleet is viewed as a single large pool of computing power,
rather than segmented computing power.

Presently, the control plane is located in the US, and the larger
build machines are located in Hetzner datacenters in the EU.  Small
service machines are colocated in the US with the control plane.
Where possible traffic egresses at the nearest edge to the source data
to avoid our traffic needing to transit multiple regions.

## The Control Plane

The control plane is composed of the Consul, Nomad, and Vault servers
which are colocated on a set of machines hosted in the DigitalOcean
SFO3 region.  These machines are the point from which the fleet is
commanded, and they operate as a highly available trio to ensure fault
tolerance.

