#!/bin/bash
# Shared helpers for the hooks that connect Claude Code with the Claude app session.
# Kept portable on purpose: macOS bash 3.2, BSD grep/sed, no jq.
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
FROM="$DIR/FROM_APP.md"
PROG="$DIR/PROGRESS.md"

# Numbers of all items in FROM_APP.md (lines starting "N. ").
items() { grep -E '^[0-9]+\. ' "$FROM" 2>/dev/null | sed -E 's/^([0-9]+)\..*/\1/'; }

# Numbers marked handled in PROGRESS.md: every #N on a line that contains "Handled FROM_APP".
handled() { grep 'Handled FROM_APP' "$PROG" 2>/dev/null | grep -oE '#[0-9]+' | tr -d '#' | sort -u; }

# Items that exist but aren't handled yet, one per line.
unhandled() {
  h=" $(handled | tr '\n' ' ') "
  for n in $(items); do
    case "$h" in *" $n "*) ;; *) echo "$n" ;; esac
  done
}

# "#4, #5" from a list of numbers.
fmt() { echo "$*" | sed -E 's/ +/, #/g; s/^/#/'; }
