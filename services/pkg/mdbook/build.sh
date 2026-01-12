#!/bin/sh
set -eu
git clone --filter=tree:0 "${REPO_URL}" /mdbook/repo
mdbook-legacy build -d /mdbook/book/ /mdbook/repo/
rsync -a --delete /mdbook/book/html/* "${OUTDIR:-/out}"
