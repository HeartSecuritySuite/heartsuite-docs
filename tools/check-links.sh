#!/usr/bin/env bash
# Link and anchor check for the built Hugo site.
#
# Wraps htmltest so `npm run check:links` reproduces the CI step locally.
# CI runs the same checks through wjdp/htmltest-action, reading the same
# .htmltest.yml, so a clean run here means a clean run there.
set -euo pipefail

cd "$(dirname "$0")/.."

CONFIG=".htmltest.yml"
BIN_DIR="tools/bin"

# Prefer an htmltest already on PATH; fall back to the repo-local copy;
# otherwise build one with Go (same source the CI action uses).
HTMLTEST="$(command -v htmltest || true)"
if [[ -z "$HTMLTEST" && -x "$BIN_DIR/htmltest" ]]; then
  HTMLTEST="$PWD/$BIN_DIR/htmltest"
fi

if [[ -z "$HTMLTEST" ]]; then
  if ! command -v go >/dev/null 2>&1; then
    echo "check:links: htmltest not found, and Go is not installed to build it." >&2
    echo "  Install Go, or drop an htmltest binary on PATH or in $BIN_DIR/." >&2
    echo "  Source: https://github.com/wjdp/htmltest" >&2
    exit 1
  fi
  echo "check:links: htmltest not found — building it into $BIN_DIR (first run only)" >&2
  mkdir -p "$BIN_DIR"
  GOBIN="$PWD/$BIN_DIR" go install github.com/wjdp/htmltest@latest
  HTMLTEST="$PWD/$BIN_DIR/htmltest"
fi

if [[ ! -d public ]]; then
  echo "check:links: no public/ directory to test — run 'npm run build' first." >&2
  exit 1
fi

# .htmltest.yml keeps CheckExternal off so routine runs stay fast and
# non-flaky. `npm run check:links:all` sets CHECK_EXTERNAL=1 to audit
# external links from a throwaway copy of the config, leaving the
# committed config (and therefore CI) untouched.
if [[ -n "${CHECK_EXTERNAL:-}" ]]; then
  generated="$(mktemp -t htmltest-external-XXXXXX)"
  trap 'rm -f "$generated"' EXIT
  sed 's/^CheckExternal:.*/CheckExternal: true/' "$CONFIG" > "$generated"
  CONFIG="$generated"
  echo "check:links: auditing external links too — this is slow and can be flaky" >&2
fi

"$HTMLTEST" -c "$CONFIG" ${HTMLTEST_ARGS:-}
