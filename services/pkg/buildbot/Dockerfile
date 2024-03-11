FROM  ghcr.io/void-linux/void-linux:latest-full-x86_64

RUN xbps-install -Suy xbps; xbps-install -Sy python3 tini git curl
RUN python3 -m venv /buildbot_venv && \
	/buildbot_venv/bin/pip3 install 'buildbot[bundle]'
WORKDIR /buildbot
COPY master.cfg /buildbot/
COPY buildbot.tac /buildbot/
RUN /buildbot_venv/bin/buildbot upgrade-master
ENTRYPOINT ["/usr/bin/tini", "--", "/buildbot_venv/bin/buildbot", "start", "--nodaemon", "/buildbot"]
