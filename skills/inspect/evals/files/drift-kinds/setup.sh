#!/usr/bin/env bash
# Builds the shop repository: the spec and order list, then one commit where
# /write finished the round's three items.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$1"
git_commit() { git -c user.name=Eval -c user.email=eval@example.com commit -qm "$1"; }
cp -R "$here/base/." "$dest"
cd "$dest" && git init -q && git add -A && git_commit "feat: list a customer's orders newest first"
cp -R "$here/change/." "$dest"
git add -A && git_commit "feat: add member discount, paging, and CSV export"
