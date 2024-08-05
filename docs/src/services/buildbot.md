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

Don't.

In the event that this is unavoidable, all builds need to be paused
until the move can be completed.  In the even the builder that needs
to be moved is on the musl cluster, all musl builders will need to be
moved with it.  Similarly, the aarch64 builders must always move as a
pair.

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

## EOL

BuildBot is slated for replacement in the future.  The system will
be replaced by the Distributed XBPS Package Builder (dxpb) or nbuild
which will resolve many of the long standing problems in the buildbot.
