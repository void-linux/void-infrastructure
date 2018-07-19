# rsyncd

All managed mirrors provide unauthenticated rsync.  Like nginx rsyncd
is configured to use drop in files read from `/etc/rsync.conf.d`.

rsync is the preferred way to mirror large amounts of package data
between two locations, even for ad-hoc migrations.  For persistent
sync the rsync protocol (`rsync://`) is preferred.

