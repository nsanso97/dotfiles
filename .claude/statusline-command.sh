#!/bin/bash
# Claude Code statusLine script converted from ~/.bashrc.d/ps1.sh PS1:
#   PS1="[\u@\h \W] $(__git_ps1 '(%s) ')\$ "
# with yellow/reset ANSI coloring.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')

five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

YELLOW=$'\033[00;33m'
GREEN=$'\033[00;32m'
RED=$'\033[00;31m'
CYAN=$'\033[00;36m'
PURPLE=$'\033[00;35m'
BLUE=$'\033[00;34m'
WHITE=$'\033[00;37m'
DIM=$'\033[00;2m'
RESET=$'\033[00m'

usage_color() {
    awk -v p="$1" 'BEGIN {
        if (p < 60) print "GREEN";
        else if (p < 90) print "YELLOW";
        else print "RED";
    }'
}

time_until() {
    local resets_at="$1"
    [ -z "$resets_at" ] && return
    local now
    now=$(date +%s)
    local diff=$(( resets_at - now ))
    [ "$diff" -lt 0 ] && diff=0
    local hours=$(( diff / 3600 ))
    local minutes=$(( (diff % 3600) / 60 ))
    printf "%02d:%02d" "$hours" "$minutes"
}

git_part=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    fi

    if [ -n "$branch" ]; then
        status=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
        dirty=""
        color="$GREEN"
        if [ -n "$status" ]; then
            dirty="*"
            if echo "$status" | grep -qE '^[MADRC]'; then
                color="$YELLOW"
            else
                color="$RED"
            fi
        fi
        git_part=$(printf " ${color}(%s%s)${RESET}" "$branch" "$dirty")
    fi
fi

extra=""
if [ -n "$model" ]; then
    extra="${extra} ${CYAN}${model}${RESET}"
fi
if [ -n "$effort" ]; then
    case "$effort" in
        low)    effort_str="${YELLOW}[${effort}]${RESET}" ;;
        medium) effort_str="${GREEN}[${effort}]${RESET}" ;;
        high)   effort_str="${BLUE}[${effort}]${RESET}" ;;
        xhigh)  effort_str="${PURPLE}[${effort}]${RESET}" ;;
        max)    effort_str="${RED}[${effort}]${RESET}" ;;
        *)      effort_str="${DIM}[${effort}]${RESET}" ;;
    esac
    extra="${extra} ${effort_str}"
fi
if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
    session_str="session ?"
    week_str="week ?"
    eta_session=""
    eta_week=""
    if [ -n "$five_hour" ]; then
        used_5h=$(awk -v p="$five_hour" 'BEGIN { printf "%.0f", p }')
        color_5h_name=$(usage_color "$five_hour")
        color_5h="${!color_5h_name}"
        session_str="${color_5h}session ${used_5h}%${RESET}"
        eta_session=$(time_until "$five_hour_resets_at")
    fi
    if [ -n "$seven_day" ]; then
        used_7d=$(awk -v p="$seven_day" 'BEGIN { printf "%.0f", p }')
        color_7d_name=$(usage_color "$seven_day")
        color_7d="${!color_7d_name}"
        week_str="${color_7d}week ${used_7d}%${RESET}"
        eta_week=$(time_until "$seven_day_resets_at")
    fi
    extra="${extra} | usage: ${session_str}, ${week_str} (${eta_session};${eta_week})"
fi

printf "[${YELLOW}%s@%s %s${RESET}]%s%s " "$user" "$host" "$dir" "$git_part" "$extra"
