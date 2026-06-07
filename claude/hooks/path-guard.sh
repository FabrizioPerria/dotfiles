#!/usr/bin/env bash

# PreToolUse guard for FILE tools: Write|Edit|MultiEdit|NotebookEdit|Read|Grep.
# Blocks operations whose TARGET PATH is sensitive. It inspects only the path
# fields from the tool input (via jq), NOT file content, to avoid
# false-positives on legitimate writes that merely mention a path in their body.

# Fail closed if jq or rg missing.
command -v jq >/dev/null 2>&1 || { echo "Blocked: path-guard cannot run (jq missing). Failing closed." >&2; exit 2; }
command -v rg >/dev/null 2>&1 || { echo "Blocked: path-guard cannot run (rg missing). Failing closed." >&2; exit 2; }

input=$(cat)

# Pull every path-like field the file tools use.
paths=$(printf '%s' "$input" | jq -r '
  (.tool_input // {}) as $t |
  [ $t.file_path?, $t.notebook_path?, $t.path?, ($t.edits[]?.file_path?) ]
  | map(select(. != null)) | .[]' 2>/dev/null)

# Defensive: if jq parsed nothing, scan the raw input so we never fail open.
[ -z "$paths" ] && paths="$input"

if printf '%s' "$paths" | rg -qi \
    -e '\.ssh/' \
    -e 'id_rsa' \
    -e 'id_ed25519' \
    -e '/\.aws/' \
    -e 'gcloud' \
    -e '\.claude/settings' \
    -e '\.claude/hooks' \
    -e '\.claude/policy-limits' \
    -e '\.credentials' \
    -e '(^|/)\.env($|\.)' \
    -e '/etc/' ; then
  echo "Blocked: target is a protected path. User must do this manually." >&2
  exit 2
fi
exit 0
