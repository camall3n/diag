#!/bin/bash
# Stop hook.
# 1) If FROM_APP.md has unhandled items, keep Claude Code working on them (at most 3 times in a row).
# 2) If the latest PROGRESS.md entry says "[REVIEW] awaiting FROM_APP #N" and item N doesn't
#    exist yet, wait up to $APP_REVIEW_WAIT seconds (default 600) for the app's reply, then continue.
cat >/dev/null
. "$(dirname "$0")/app_lib.sh"
WAIT=${APP_REVIEW_WAIT:-600}
STATE="$DIR/.claude/app_hook_state"
count=$(cat "$STATE" 2>/dev/null || echo 0)

block() {
  r=$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')
  printf '{"decision": "block", "reason": "%s"}\n' "$r"
  exit 0
}

U=$(unhandled | tr '\n' ' ')
if [ -n "${U// /}" ]; then
  if [ "$count" -ge 3 ]; then echo 0 > "$STATE"; exit 0; fi
  echo $((count + 1)) > "$STATE"
  block "Unhandled notes from the Claude app in FROM_APP.md: $(fmt $U). Read them, act on them, and record 'Handled FROM_APP #n' in PROGRESS.md."
fi
echo 0 > "$STATE"

# The latest PROGRESS entry (from the last line starting "- [").
last=$(awk '/^- \[/{buf=""} {buf=buf "\n" $0} END{print buf}' "$PROG")
N=$(printf '%s' "$last" | grep -oE 'awaiting FROM_APP #[0-9]+' | grep -oE '[0-9]+' | tail -1)
[ -z "$N" ] && exit 0
case "$last" in *"[REVIEW]"*) ;; *) exit 0 ;; esac

has_item() { items | grep -qx "$1"; }
has_item "$N" && exit 0          # already answered (and handled, or we'd have blocked above)

waited=0
while [ "$waited" -lt "$WAIT" ]; do
  sleep 20
  waited=$((waited + 20))
  if has_item "$N"; then
    echo 1 > "$STATE"
    U=$(unhandled | tr '\n' ' ')
    block "The Claude app replied to your [REVIEW] in FROM_APP.md: $(fmt $U). Read it and continue, and record 'Handled FROM_APP #n' in PROGRESS.md."
  fi
done
exit 0
