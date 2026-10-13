#!/usr/bin/env bash
# Builds the ledger_sync repository, which keeps a CLAUDE.md and no AGENTS.md.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$1"
cp -R "$here/base/." "$dest"
cd "$dest" && git init -q && git add -A
git -c user.name=Eval -c user.email=eval@example.com commit -qm "feat: import bank exports into the ledger"
