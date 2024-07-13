# BuildBot

BuildBot is our legacy build scheduler.

The buildbot controller runs at
[build.voidlinux.org](https://build.voidlinux.org) and provides
unified scheduling to all other build tasks in the fleet.  BuildBot
also exposes a web interface.

The current status of the build infrastructure can be found on the
build waterfall.  This view shows what each of the builders is
doing right now, and uses traffic light colors for build state.  A
purple builder is usually a reason to contact void-ops and figure out
what's wrong with the build host.

Authenticated users of the buildbot can restart builds that have
failed without needing to push a new commit.  Not all committers have
access to restart failed builds this way.  If you believe that you
should have this access, contact maldridge@.

## Moving a builder

First, all builds need to be paused until the move can be completed.
Builders must be moved in the groups they currently are in (glibc, musl,
and aarch64). Sync the hostdir host volume to the new location, then
migrate the nomad job to the new host.

## Updating buildbot

The buildbot controller and builders should be kept at the same buildbot
version.

1. Update the buildbot version in both the `buildbot` and
   `buildbot-builder` Dockerfiles.
2. Rebuild the service containers by triggering a build for the
   `infra-buildbot` and `infra-buildbot-builder` containers in CI.
3. Update the nomad jobs to use the new containers and restart them
   with the task meta variable `db-upgrade = "true"`. This will run
   any necessary migrations on startup.
4. Re-set `db-upgrade = "false"`. The job does not need to be
   redeployed, but on the next deployment, it will not run the upgrade.

## Future Plans

Buildbot 4 uses the database to store logs. Currently, we are using the sqlite
backend. If this causes performance issues in the future, we should switch to
[postgres](https://docs.buildbot.net/current/manual/deploy.html#using-a-database-server).
To migrate the database from sqlite, the steps appear to be:

1. Ensure the sqlite database is fully upgraded by running the controller task with
   `db-upgrade = "true"`.
2. Set up a postgres server with a buildbot user (see Buildbot's documentation linked
   above).
3. Run `buildbot copydb postgres://buildbot:passw0rd@ip/buildbot /path/to/buildbot/basedir`.
4. Update the buildbot configuration to use the new database url.

## EOL

BuildBot is slated for replacement in the future.  The system will
be replaced by the Distributed XBPS Package Builder (dxpb) or nbuild
which will resolve many of the long standing problems in the buildbot.
