# Google Cloud Platform

We use some resources on Google Cloud Platform.  Most prominently the
primary DNS zone for voidlinux.org is hosted on GCP.

To minimize the number of people with access to the cloud account, we
use a service account.  The service account should be given only the
minimum of permissions and its key should be stored as 'account.json'
in the terraform directory (which is gitignored).
