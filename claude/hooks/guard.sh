#!/usr/bin/env bash

# PreToolUse guard for COMMAND tools: Bash | PowerShell | mcp__*.
# Scans the command text for destructive / exfil / policy-tamper patterns.
# Fail closed: if rg is unavailable the pattern check cannot run.
if ! command -v rg >/dev/null 2>&1; then
  echo "Blocked: guard cannot run (ripgrep/rg missing). Failing closed." >&2
  exit 2
fi

PATTERNS=(
  # --- policy / self-protection ---
  'guard\.sh'
  'path-guard'
  '\.claude/settings\.json'
  '\.claude/settings\.local'
  '\.claude/policy-limits'
  '\.claude/hooks'
  '\.credentials'
  # --- git / perforce destructive ---
  'push.*--force'
  'push.*--delete'
  'push .*-f\b'                # short-flag force push
  'reset.*--hard'
  'clean.*-f'
  'commit.*--amend'
  'filter-branch'
  'filter-repo'
  'branch.*-[dD]'
  'submit'
  'obliterate'
  'p4 .*admin'
  'protect'
  'triggers'
  'p4 .*configure'
  'depot.*-d'
  'stream.*-d'
  'label.*-d'
  'shelve.*-d'
  'p4 .*user.*-d'
  'p4 .*group.*-d'
  # --- filesystem destruction ---
  'rm -rf'
  'rm -fr'
  'rm -f /'
  'rm .*-r.* -f'              # flag-spacing variants of recursive force delete
  'rm .*-f.* -r'
  'rm .*--recursive'
  'rm .*--force'
  'shred'
  '\bdd\b'
  'mkfs'
  'fdisk'
  'parted'
  'truncate'
  'base64 .*-d'
  'base64 .*--decode'
  '\| *(ba)?sh\b'            # pipe into sh/bash (curl|sh, wget|bash)
  # --- secret reads via shell (partial; may FP on ssh/aws CLI usage) ---
  'id_rsa'
  'id_ed25519'
  '\.aws/credentials'
  # --- interpreter indirection (AGGRESSIVE — expect false positives, trim if noisy) ---
  'python[0-9]* +-c'
  'perl +-e'
  'node +-e'
  'ruby +-e'
  ' -delete\b'
  '-exec +rm'
  'xargs.*\brm\b'
  # --- outbound exfil channels ---
  'curl.* (-d|--data|-T|--upload-file|-F)'
  'wget.*--post'
  '/dev/tcp/'
  '\bnc '
  '\bncat '
  # --- PowerShell / Windows-native destructive ops ---
  '-Recurse.*-Force'          # Remove-Item -Recurse -Force (and aliases rm/del/rd/ri)
  '-Force.*-Recurse'          # same, flags reversed
  'Clear-Content'             # empties a file (truncate equivalent)
  'Format-Volume'
  'Format-Disk'
  'Clear-Disk'
  'Remove-Partition'
  'Initialize-Disk'
  'diskpart'                  # partition utility (fdisk/parted equivalent)
  'fsutil'                    # e.g. fsutil file setzerodata (zero/truncate)
  'cipher /w'                 # wipes free space (shred equivalent)
  'reg delete'                # registry destruction
  'del /s'                    # cmd-style recursive delete
  'rd /s'
  'rmdir /s'
  # --- PowerShell command-hiding / bypass ---
  '-EncodedCommand'           # -enc <base64>: hides the actual command
  '-enc '
  'FromBase64String'          # decoding an inline payload
  'Invoke-Expression'         # iex: runs an arbitrary string
  '\biex\b'
  '-ExecutionPolicy Bypass'   # disables script-execution safeguards
  '-ep bypass'
)

args=()
for p in "${PATTERNS[@]}"; do args+=(-e "$p"); done

# Normalize runs of blanks so spacing tricks (e.g. "rm  -rf") can't slip past.
if tr -s '[:blank:]' ' ' | rg -qi "${args[@]}"; then
  echo "Blocked: command matches a guarded pattern. User must run this manually" >&2
  exit 2
fi
exit 0
