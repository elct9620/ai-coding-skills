#!/usr/bin/env bash
# Builds the report repository: a suspected hotspot, the real one, and an unused cache.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$1"
cp -R "$here/base/." "$dest"
cd "$dest" && git init -q && git add -A
git -c user.name=Eval -c user.email=eval@example.com commit -qm "feat: build the monthly sales report"
