#!/usr/bin/env bash
# Builds the subtitler repository, then one commit adding the project class.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$1"
git_commit() { git -c user.name=Eval -c user.email=eval@example.com commit -qm "$1"; }
cp -R "$here/base/." "$dest"
cd "$dest" && git init -q && git add -A && git_commit "feat: model subtitle segments"
cp -R "$here/change/." "$dest"
git add -A && git_commit "feat: keep a subtitle project open with its translations"
