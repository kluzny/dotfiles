#!/usr/bin/env bash
# Shows a table starting with right now, then the next 12 hours in half-hour
# steps across UTC, EDT, CDT, MDT, and PDT (east to west, UTC leading since
# it's ahead of all of them), as ISO 8601 timestamps.
#
# --plain skips the decorated header and prints a bare one instead.

set -euo pipefail

plain=0
if [ "${1:-}" = "--plain" ]; then
  plain=1
fi

zones=(UTC America/New_York America/Chicago America/Denver America/Los_Angeles)
col_width=27
gap=3
label_width=$(( col_width - gap ))

now=$(date +%s)
remainder=$(( now % 1800 ))
if [ "$remainder" -eq 0 ]; then
  start=$now
else
  start=$(( now - remainder + 1800 ))
fi

print_row() {
  local epoch=$1
  local row=""
  for tz in "${zones[@]}"; do
    row+=$(printf "%-${col_width}s" "$(TZ=$tz date -r "$epoch" +%FT%T%z)")
  done
  echo "$row"
}

header_cell() {
  local text=" $1 "
  local pad=$(( label_width - ${#text} ))
  local left=$(( pad / 2 ))
  local right=$(( pad - left ))
  printf '%s%s%s' "$(printf '=%.0s' $(seq 1 "$left"))" "$text" "$(printf '=%.0s' $(seq 1 "$right"))"
}

if [ "$plain" -eq 1 ]; then
  header=""
  for tz in "${zones[@]}"; do
    header+=$(printf "%-${col_width}s" "$(TZ=$tz date -r "$start" +%Z)")
  done
  echo "$header"
else
  header=""
  for tz in "${zones[@]}"; do
    header+=$(printf "%-${col_width}s" "$(header_cell "$(TZ=$tz date -r "$start" +%Z)")")
  done
  echo "$header"
fi

print_row "$now"

for (( i=0; i<24; i++ )); do
  t=$(( start + i*1800 ))
  print_row "$t"
done
