# Mirrorbits

Mirrorbits is a geographically aware IP based mirror redirection
system.  We use mirrorbits to dynamically route repository traffic to
the nearest mirror that has the correct file to service the request.
Mirrorbits is a VLC project with more information available [on
GitHub](https://github.com/etix/mirrorbits).  Mirrorbits needs either
rsync (preferred) or ftp access to all mirrors to run periodic scans
and health checks.  Mirrorbits can also handle dynamic handoff between
mirrors and is configured to do so by issuing per-file redirects.

Mirrorbits serves traffic under the virtual hostname
[auto.voidlinux.org](http://auto.voidlinux.org).

## Useful Tricks

Mirrorbits keeps a log of traffic that has been routed for the last 24
hours.  Since mirrorbits knows how large each file it is directing is,
the bandwidth cost of each mirror is known to mirrorbits.  To see this
data visit
[auto.voidlinux.org?mirrorstats](http://auto.voidlinux.org?mirrorstats).

The mirrorstats page also has a handy map that shows you where all the
servers currently mirroring Void are located.  Leads with shell access
to the mirrorbits host can summon further information from the
mirrordb by using the mirrorbits CLI.  For example:

```shell
$ mirrorbits --config /etc/mirrorbits/config.yml show a-lej-de
Mirror: vm1-a-lej-de
HttpURL: http://vm1.a-lej-de.m.voidlinux.org/
RsyncURL: rsync://localhost/voidmirror/
FtpURL: ""
SponsorName: Void Linux
SponsorURL: https://www.voidlinux.org
SponsorLogoURL: https://voidlinux.github.io/assets/img/void_fg.png
AdminName: Michael Aldridge
AdminEmail: maldridge@voidlinux.eu
CustomData: ""
ContinentOnly: false
CountryOnly: false
ASOnly: false
Score: 1
Latitude: 49.11594
Longitude: 10.7534
ContinentCode: EU
CountryCodes: DE
ExcludedCountryCodes: ""
ASNum: 0
Enabled: true
AllowRedirects: null

Comment:

```

If you think that mirrorbits has made the wrong call in where a file
was served from, you can append `?mirrorlist` to any mirror URL and
see why you're being routed to a particular mirror.

An example URL to try:
[http://auto.voidlinux.org/live/current/sha256sums.txt?mirrorlist](http://auto.voidlinux.org/live/current/sha256sums.txt?mirrorlist)


## No SSL

Mirrorbits runs without SSL because it needs to be able to issue
redirects to other servers.  Not all of these mirrors offer SSL
connection options and protocol downgrade during a 302 redirect is not
well supported.  Users that wish to use SSL at all times should be
advised to manually configure a preferred mirror.
