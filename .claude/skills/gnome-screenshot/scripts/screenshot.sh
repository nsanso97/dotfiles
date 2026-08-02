#!/usr/bin/env bash
# Takes a screenshot via the GNOME/xdg-desktop-portal Screenshot API and
# prints the resulting file path.
#
# Always interactive: GNOME's own picker opens and the user selects a
# window/area/screen each time. Deliberate — there is no scoped, read-only
# way to have GNOME auto-target a specific window (see SKILL.md "Why not"
# section), so a human click per capture is the ceiling here, not a
# limitation of this script.
#
# Needs a one-time permission grant the very first time it's ever called
# (a GNOME prompt appears) — after that just the picker shows, no further
# permission dialog. No daemon/socket/injected input involved.
set -euo pipefail

before=$(find ~/Pictures ~/Pictures/Screenshots -maxdepth 1 -iname 'Screenshot*.png' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

gdbus call --session --dest org.freedesktop.portal.Desktop \
	--object-path /org/freedesktop/portal/desktop \
	--method org.freedesktop.portal.Screenshot.Screenshot \
	"" "{'interactive': <true>}" >/dev/null

# The portal call returns before the file is written; poll for a
# new/updated Screenshot*.png rather than parsing the async D-Bus response.
# Longer timeout than a non-interactive capture — waiting on a human to
# pick a window, not just disk I/O.
for _ in $(seq 1 300); do
	newest=$(find ~/Pictures ~/Pictures/Screenshots -maxdepth 1 -iname 'Screenshot*.png' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
	if [ -n "$newest" ] && [ "$newest" != "$before" ]; then
		echo "$newest"
		exit 0
	fi
	sleep 0.2
done

echo "screenshot.sh: no new screenshot appeared within 60s" >&2
exit 1
