FROM  ghcr.io/void-linux/void-linux:latest-full-x86_64

RUN xbps-install -Suy xbps; xbps-install -Sy python3 tini git curl
RUN python3 -m venv /buildbot_venv && \
	/buildbot_venv/bin/pip3 install 'buildbot-worker'
WORKDIR /buildbot
RUN mkdir -p /buildbot && ln -sf /local/info /buildbot/info
COPY buildbot.tac /buildbot/
ENTRYPOINT ["/usr/bin/tini", "--", "/buildbot_venv/bin/buildbot-worker", "start", "--nodaemon", "/buildbot"]
