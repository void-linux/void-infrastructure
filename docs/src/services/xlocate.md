# xlocate

The xlocate service provides the data source for consumption by the
xlocate command from the xtools package.  This task is responsible for
once a day regenerating the search index that is used for all package
files.

## Required Colocation

Because the xlocate indexing task requires running xbps-query over all
packages in x86_64, this task must be colocated with a package mirror.
The mirror must also be configured locally so that xlocate does not
unecessarily load a webserver on the same host.

