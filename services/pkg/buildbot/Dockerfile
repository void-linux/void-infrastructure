FROM  ghcr.io/void-linux/void-glibc-full:latest

RUN xbps-install -Suy xbps && xbps-install -uy python3 tini git curl && rm -rf /var/cache/xbps /tmp/*

# version must be synced with ../buildbot-worker
ARG BUILDBOT_VERSION=4.3.0
ARG THEME_VERSION=v0.1.0

RUN python3 -m venv /venv && \
	/venv/bin/pip3 install wheel && \
	/venv/bin/pip3 install 'buildbot[tls,bundle]~='$BUILDBOT_VERSION \
		buildbot-prometheus buildbot-netauth \
		git+https://github.com/void-linux/buildbot-theme.git@$THEME_VERSION
WORKDIR /buildbot
COPY buildbot.tac /buildbot/
COPY run.sh /
# buildbot config should be in its basedir
# buildbot upgrade-master hardcodes master.cfg
RUN ln -sf /local/buildbot.cfg /buildbot/buildbot.cfg && \
	ln -sf /buildbot/buildbot.cfg /buildbot/master.cfg
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/sh", "/run.sh"]
