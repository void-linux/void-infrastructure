# Services

Void operates a number of services across the managed fleet.  This
section documents that various services and appropriate care and
feeding.

Services are mapped onto physical or virtual hosts by Ansible
configuration.  This mapping is encapsulated in the
`ansible/inventory` file.  Some services are replicated or
distributed.  In many cases, services take additional configuration
values which are stored in either the `host_vars` or the `group_vars`
depending on the appropriate variable scope.
