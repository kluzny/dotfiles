#!/usr/bin/env bash
set -euo pipefail

# ramchop: Outputs percentage of RAM in use as a decimal float.
#   - On Darwin (macOS): parses memory_pressure for used RAM percent
#   - On Linux: uses 'free' to calculate used RAM as percent of total
# Prints result similar to 8.0 or 21.4

PLATFORM=$(uname)

if [ "$PLATFORM" = "Darwin" ]; then
    # Get memory pressure, extract the free percentage
    PERCENT_FREE=$(memory_pressure 2>/dev/null | awk -F: '/System-wide memory free percentage/ { gsub(/[% ]/, "", $2); print $2 }')
    if [[ -z "$PERCENT_FREE" ]]; then
        echo "Could not determine memory pressure." 1>&2
        exit 1
    fi
    # Output percentage used as float
    PERCENT_USED=$(awk "BEGIN { print 100-$PERCENT_FREE }")
    printf "%.1f\n" "$PERCENT_USED"
elif [ "$PLATFORM" = "Linux" ]; then
    # Parse free to get total and available, then calculate percent used
    read -r total available < <(free -m | awk '/^Mem:/ { print $2, $7 }')
    if [[ -z "$total" || -z "$available" ]]; then
        echo "Could not determine memory info." 1>&2
        exit 1
    fi
    percent_used=$(awk -v t="$total" -v a="$available" 'BEGIN { printf "%.1f", 100*(t-a)/t }')
    printf "%s\n" "$percent_used"
else
    echo "Unsupported platform: $PLATFORM" 1>&2
    exit 2
fi
