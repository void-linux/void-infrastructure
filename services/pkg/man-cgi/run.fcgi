#!/bin/sh
exec spawn-fcgi -n -s /var/run/fcgiwrap.sock -- /usr/bin/fcgiwrap
