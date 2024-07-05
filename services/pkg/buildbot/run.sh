#!/bin/sh

: "${DB_UPGRADE:=$NOMAD_META_DB_UPGRADE}"

if [ "$DB_UPGRADE" = "true" ]; then
	until /venv/bin/buildbot upgrade-master /buildbot; do
		echo "upgrading buildbot installation..."
		sleep 1
	done
fi

exec /venv/bin/buildbot start --nodaemon /buildbot
