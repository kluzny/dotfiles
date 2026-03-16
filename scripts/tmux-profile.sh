#!/usr/bin/env bash
# tmux-profile.sh - Profile tmux startup performance
# Usage: ./tmux-profile.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_BACKUP="$HOME/.tmux.conf.backup.$(date +%s)"
TMUX_CONF_TEST="$HOME/.tmux.conf.test"
RESULTS_FILE="/tmp/tmux-profile-results.txt"

# Cleanup function
cleanup() {
    if [[ -f "$TMUX_CONF_BACKUP" ]]; then
        echo -e "${YELLOW}Restoring original config...${NC}"
        mv "$TMUX_CONF_BACKUP" "$TMUX_CONF"
    fi
    rm -f "$TMUX_CONF_TEST"
    # Kill any test tmux sessions
    tmux kill-session -t tmux-profile-test 2>/dev/null || true
}

trap cleanup EXIT

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         TMUX STARTUP PERFORMANCE PROFILER         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Backup original config
echo -e "${YELLOW}Creating backup of .tmux.conf...${NC}"
cp "$TMUX_CONF" "$TMUX_CONF_BACKUP"

# Initialize results file
echo "TMUX Profile Results - $(date)" > "$RESULTS_FILE"
echo "=======================================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Function to measure tmux startup time
measure_startup() {
    local description="$1"
    local config_file="$2"
    local iterations=5
    local total=0
    
    echo -e "${YELLOW}Testing: ${description}${NC}" >&2
    
    # Use the test config
    if [[ "$config_file" != "$TMUX_CONF" ]]; then
        cp "$config_file" "$TMUX_CONF"
    fi
    
    for i in $(seq 1 $iterations); do
        # Kill any existing test sessions
        tmux kill-session -t tmux-profile-test 2>/dev/null || true
        
        # Measure time to create and destroy a session
        start=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
        tmux new-session -d -s tmux-profile-test 2>/dev/null
        tmux kill-session -t tmux-profile-test 2>/dev/null
        end=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
        
        duration=$(awk "BEGIN {print $end - $start}")
        total=$(awk "BEGIN {print $total + $duration}")
        
        printf "  Run %d: %.3fs\n" "$i" "$duration" >&2
    done
    
    average=$(awk "BEGIN {printf \"%.3f\", $total / $iterations}")
    echo -e "${GREEN}  Average: ${average}s${NC}" >&2
    echo "" >&2
    
    echo "$description: ${average}s" >> "$RESULTS_FILE"
    echo "$average"
}

# Test 1: Baseline with full config
echo -e "${BLUE}═══ Test 1: Full Configuration (Baseline) ═══${NC}"
baseline=$(measure_startup "Full configuration" "$TMUX_CONF_BACKUP")

# Test 2: Without TPM/plugins
echo -e "${BLUE}═══ Test 2: Without Plugins ═══${NC}"
grep -v '^run.*tpm' "$TMUX_CONF_BACKUP" | grep -v '^set -g @plugin' > "$TMUX_CONF_TEST"
no_plugins=$(measure_startup "Without plugins" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 3: Without status bar customizations
echo -e "${BLUE}═══ Test 3: Without Status Bar Customizations ═══${NC}"
grep -v 'set.*status-right' "$TMUX_CONF_BACKUP" | \
    grep -v 'set.*status-left' | \
    grep -v 'set.*@catppuccin' > "$TMUX_CONF_TEST"
no_status=$(measure_startup "Without status bar customizations" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 4: Minimal config (almost empty)
echo -e "${BLUE}═══ Test 4: Minimal Configuration ═══${NC}"
cat > "$TMUX_CONF_TEST" << 'EOF'
# Minimal config for profiling
set -g prefix C-a
set -g base-index 1
set -g default-terminal "screen-256color"
EOF
minimal=$(measure_startup "Minimal configuration" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 5: Only catppuccin plugin
echo -e "${BLUE}═══ Test 5: Only Catppuccin Plugin ═══${NC}"
cat > "$TMUX_CONF_TEST" << 'EOF'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'catppuccin/tmux#v2.1.3'
set -g @catppuccin_flavor "mocha"
set -g prefix C-a
set -g base-index 1
run '~/.tmux/plugins/tpm/tpm'
EOF
only_catppuccin=$(measure_startup "Only catppuccin plugin" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 6: Only tmux-cpu plugin
echo -e "${BLUE}═══ Test 6: Only tmux-cpu Plugin ═══${NC}"
cat > "$TMUX_CONF_TEST" << 'EOF'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g prefix C-a
set -g base-index 1
run '~/.tmux/plugins/tpm/tpm'
EOF
only_cpu=$(measure_startup "Only tmux-cpu plugin" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 7: Only vim-tmux-navigator plugin
echo -e "${BLUE}═══ Test 7: Only vim-tmux-navigator Plugin ═══${NC}"
cat > "$TMUX_CONF_TEST" << 'EOF'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g prefix C-a
set -g base-index 1
run '~/.tmux/plugins/tpm/tpm'
EOF
only_vim_nav=$(measure_startup "Only vim-tmux-navigator plugin" "$TMUX_CONF_TEST")
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Test 8: Profile external scripts
echo -e "${BLUE}═══ Test 8: External Script Performance ═══${NC}"
if [[ -f "$HOME/.local/bin/ramchop" ]]; then
    echo -e "${YELLOW}Testing ramchop script...${NC}"
    ramchop_total=0
    for i in $(seq 1 10); do
        start=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
        "$HOME/.local/bin/ramchop" > /dev/null
        end=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
        duration=$(awk "BEGIN {print $end - $start}")
        ramchop_total=$(awk "BEGIN {print $ramchop_total + $duration}")
    done
    ramchop_avg=$(awk "BEGIN {printf \"%.4f\", $ramchop_total / 10}")
    echo -e "${GREEN}  ramchop average: ${ramchop_avg}s${NC}"
    echo "ramchop script: ${ramchop_avg}s" >> "$RESULTS_FILE"
else
    ramchop_avg="N/A"
    echo -e "${RED}  ramchop script not found${NC}"
fi

echo ""
echo -e "${YELLOW}Testing memory_pressure command...${NC}"
mp_total=0
for i in $(seq 1 10); do
    start=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
    memory_pressure 2>/dev/null > /dev/null || true
    end=$(perl -MTime::HiRes -e 'printf("%.6f\n", Time::HiRes::time())')
    duration=$(awk "BEGIN {print $end - $start}")
    mp_total=$(awk "BEGIN {print $mp_total + $duration}")
done
mp_avg=$(awk "BEGIN {printf \"%.4f\", $mp_total / 10}")
echo -e "${GREEN}  memory_pressure average: ${mp_avg}s${NC}"
echo "memory_pressure command: ${mp_avg}s" >> "$RESULTS_FILE"

# Restore original config
echo ""
echo -e "${YELLOW}Restoring original configuration...${NC}"
cp "$TMUX_CONF_BACKUP" "$TMUX_CONF"

# Generate summary report
echo "" >> "$RESULTS_FILE"
echo "=======================================" >> "$RESULTS_FILE"
echo "SUMMARY" >> "$RESULTS_FILE"
echo "=======================================" >> "$RESULTS_FILE"

echo "" >> "$RESULTS_FILE"
echo "Performance Impact Analysis:" >> "$RESULTS_FILE"
plugin_impact=$(awk "BEGIN {printf \"%.3f\", ($baseline - $no_plugins)}")
status_impact=$(awk "BEGIN {printf \"%.3f\", ($baseline - $no_status)}")
if (( $(awk "BEGIN {print $baseline > 0}") )); then
    plugin_pct=$(awk "BEGIN {printf \"%.1f\", ($plugin_impact / $baseline) * 100}")
    status_pct=$(awk "BEGIN {printf \"%.1f\", ($status_impact / $baseline) * 100}")
else
    plugin_pct="0.0"
    status_pct="0.0"
fi
echo "  Plugins overhead: ${plugin_impact}s (${plugin_pct}%)" >> "$RESULTS_FILE"
echo "  Status bar overhead: ${status_impact}s (${status_pct}%)" >> "$RESULTS_FILE"

# Display final report
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                 PROFILE SUMMARY                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Configuration Comparison:${NC}"
printf "  %-40s %10s\n" "Full configuration (baseline):" "${baseline}s"
printf "  %-40s %10s\n" "Without plugins:" "${no_plugins}s"
printf "  %-40s %10s\n" "Without status bar:" "${no_status}s"
printf "  %-40s %10s\n" "Minimal config:" "${minimal}s"
printf "  %-40s %10s\n" "Only catppuccin:" "${only_catppuccin}s"
printf "  %-40s %10s\n" "Only tmux-cpu:" "${only_cpu}s"
printf "  %-40s %10s\n" "Only vim-tmux-navigator:" "${only_vim_nav}s"
echo ""
echo -e "${YELLOW}Impact Analysis:${NC}"
printf "  %-40s %10s (%5.1f%%)\n" "Plugins overhead:" "${plugin_impact}s" "$plugin_pct"
printf "  %-40s %10s (%5.1f%%)\n" "Status bar overhead:" "${status_impact}s" "$status_pct"
echo ""
echo -e "${YELLOW}External Scripts:${NC}"
if [[ "$ramchop_avg" != "N/A" ]]; then
    printf "  %-40s %10s\n" "ramchop script:" "${ramchop_avg}s"
fi
printf "  %-40s %10s\n" "memory_pressure command:" "${mp_avg}s"
echo ""
echo -e "${GREEN}Full results saved to: ${RESULTS_FILE}${NC}"
echo ""

# Generate recommendations
echo -e "${BLUE}═══ Recommendations ═══${NC}"

if (( $(awk "BEGIN {print ($plugin_impact / $baseline) > 0.5}") )); then
    echo -e "${RED}⚠  Plugins account for >50% of startup time${NC}"
    echo "   Consider: lazy-loading or removing unused plugins"
    echo ""
fi

if (( $(awk "BEGIN {print ($only_cpu > $only_catppuccin * 1.5)}") )); then
    echo -e "${RED}⚠  tmux-cpu plugin is significantly slower than catppuccin${NC}"
    echo "   Consider: replacing tmux-cpu with a lighter alternative"
    echo ""
fi

if [[ "$ramchop_avg" != "N/A" ]] && (( $(awk "BEGIN {print ($ramchop_avg > 0.05)}") )); then
    echo -e "${YELLOW}⚠  ramchop script takes >50ms per execution${NC}"
    echo "   Impact: Status bar updates will feel sluggish"
    echo ""
fi

if (( $(awk "BEGIN {print ($mp_avg > 0.1)}") )); then
    echo -e "${YELLOW}⚠  memory_pressure command is slow (>100ms)${NC}"
    echo "   Consider: caching the result or using alternative method"
    echo ""
fi

# Calculate slowest component
catppuccin_overhead=$(awk "BEGIN {printf \"%.3f\", $only_catppuccin - $minimal}")
cpu_overhead=$(awk "BEGIN {printf \"%.3f\", $only_cpu - $minimal}")
vim_nav_overhead=$(awk "BEGIN {printf \"%.3f\", $only_vim_nav - $minimal}")

echo -e "${BLUE}═══ Per-Plugin Overhead ═══${NC}"
printf "  %-40s %10s\n" "catppuccin theme:" "${catppuccin_overhead}s"
printf "  %-40s %10s\n" "tmux-cpu:" "${cpu_overhead}s"
printf "  %-40s %10s\n" "vim-tmux-navigator:" "${vim_nav_overhead}s"
echo ""

# Identify slowest plugin
slowest="catppuccin"
slowest_time=$catppuccin_overhead
if (( $(awk "BEGIN {print $cpu_overhead > $slowest_time}") )); then
    slowest="tmux-cpu"
    slowest_time=$cpu_overhead
fi
if (( $(awk "BEGIN {print $vim_nav_overhead > $slowest_time}") )); then
    slowest="vim-tmux-navigator"
    slowest_time=$vim_nav_overhead
fi

echo -e "${GREEN}✓ Slowest plugin: ${slowest} (${slowest_time}s overhead)${NC}"
echo ""
