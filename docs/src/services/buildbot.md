# BuildBot

BuildBot is our legacy build scheduler.

The buildbot master runs at
[build.voidlinux.org](https://build.voidlinux.org) and provides
unified scheduling to all other build tasks in the fleet.  BuildBot
also exposes a web interface.

The current status of the build infrastructure can be found on the
build waterfall.  This view shows what each of the buildslaves is
doing right now, and uses traffic light colors for build state.  A
purple builder is usually a reason to contact void-ops and figure out
what's wrong with the build host.

Authenticated users of the buildbot can restart builds that have
failed without needing to push a new commit.  Not all committers have
access to restart failed builds this way.  If you believe that you
should have this access, contact maldridge@.

## Moving a buildslave

Don't.

In the event that this is unavoidable, all builds need to be paused
until the move can be completed.  In the even the builder that needs
to be moved is on the musl cluster, all musl builders will need to be
moved with it.  Similarly, the aarch64 builders must always move as a
pair.

## EOL

BuildBot is slated for replacement this fall/winter.  The system will
be replaced by the Distributed XBPS Package Builder (dxpb) which will
resolve many of the long standing problems in the buildbot.
