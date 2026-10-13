#!/usr/bin/env bash
# Builds the subtitler repository in a single commit.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$1"
cp -R "$here/base/." "$dest"
cd "$dest" && git init -q && git add -A
git -c user.name=Eval -c user.email=eval@example.com commit -qm "feat: keep a project's segments in order"
