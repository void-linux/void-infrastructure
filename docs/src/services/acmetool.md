# acmetool

All SSL certificates for Void are provided by LetsEncrypt via
acmetool.  Configuration for names requested in acmetool certs are
done through various host variables.

Acmetool is configured to run under snooze, and should attempt to
renew certificates once a day.  Certificates that have more than 30
days remaining will not be renewed.  Acmetool does not automatically
restart services that consume certificates.  In the case of web
services, it is assumed that there will be a push that restarts
services frequently enough that this will not be an issue.

In the future we may include certificate checks to restart services
that do not support dynamic certificate reloading.
