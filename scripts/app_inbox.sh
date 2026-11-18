#!/bin/bash
# SessionStart / UserPromptSubmit hook: tell Claude Code about unhandled app notes.
# Plain stdout from these hooks is added to Claude's context.
cat >/dev/null
. "$(dirname "$0")/app_lib.sh"
U=$(unhandled | tr '\n' ' ')
[ -z "${U// /}" ] && exit 0
echo "Unhandled notes from the Claude app session in FROM_APP.md: $(fmt $U). Read them, act on them, and record 'Handled FROM_APP #n' in PROGRESS.md."
exit 0
