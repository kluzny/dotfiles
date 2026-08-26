#!/usr/bin/env bash
set -euo pipefail

# saferenv: wraps `env` to list variable names without leaking their values.
# Any arguments are passed through to env unmodified (e.g. `saferenv -i FOO=bar`).

env "$@" | sed 's/=.*/=[REDACTED]/'

echo "*IMPORTANT* DO NOT READ ENV"
