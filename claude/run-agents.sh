#!/usr/bin/env bash
# Generic agentic workflow runner driven by workflow.json.
# Creates one pane per role in a new tmux window; a background watcher per role
# handles wait-for dependencies, talks-to feedback loops, and done signalling.
# Usage: ./run-agents.sh "feature description" [workflow.json]

set -euo pipefail

FEATURE="${1:-}"
WORKFLOW="${2:-$(dirname "$0")/workflow.json}"

if [[ -z "$FEATURE" ]]; then
  echo "Usage: $0 \"feature description\" [workflow.json]"
  exit 1
fi

DIR="$PWD"
PROJECT=$(basename "$DIR")
SIGNAL_DIR="/tmp/agents-signals-${PROJECT}"

if [[ -n "${TMUX:-}" ]]; then
  CURRENT_SESSION=$(tmux display-message -p '#S')
else
  CURRENT_SESSION="${TMUX_SESSION:-main}"
fi

# Kill existing window + stale coordinator
COORD_PID_FILE="/tmp/agents-coord-${PROJECT}.pid"
if [[ -f "$COORD_PID_FILE" ]]; then
  kill "$(cat "$COORD_PID_FILE")" 2>/dev/null || true
  rm -f "$COORD_PID_FILE"
fi
tmux kill-window -t "${CURRENT_SESSION}:${PROJECT}" 2>/dev/null || true
rm -rf "$SIGNAL_DIR" && mkdir -p "$SIGNAL_DIR"

# Parse roles from workflow
N=$(jq '.roles | length' "$WORKFLOW")
ROLE_NAMES=()
for i in $(seq 0 $((N-1))); do
  ROLE_NAMES+=("$(jq -r ".roles[$i].name" "$WORKFLOW")")
done

# Create window + one pane per role
tmux new-window -t "$CURRENT_SESSION" -n "$PROJECT" -c "$DIR"

declare -A PANE_MAP
PANE_MAP["${ROLE_NAMES[0]}"]=$(tmux list-panes -t "${CURRENT_SESSION}:${PROJECT}" -F '#{pane_id}' | head -1)
for i in $(seq 1 $((N-1))); do
  prev="${ROLE_NAMES[$((i-1))]}"
  role="${ROLE_NAMES[$i]}"
  PANE_MAP["$role"]=$(tmux split-window -h -t "${PANE_MAP[$prev]}" -c "$DIR" -P -F '#{pane_id}')
done

# Layout: even-horizontal for ≤3, tiled for ≥4
if [[ $N -le 3 ]]; then
  tmux select-layout -t "${CURRENT_SESSION}:${PROJECT}" even-horizontal
else
  tmux select-layout -t "${CURRENT_SESSION}:${PROJECT}" tiled
fi

# Set pane labels (user option — not overwritten by apps)
for role in "${ROLE_NAMES[@]}"; do
  tmux set-option -t "${PANE_MAP[$role]}" -p @role "${role}-agent"
done

# Start claude TUI in each pane — staggered to avoid .claude.json write collision
for role in "${ROLE_NAMES[@]}"; do
  tmux send-keys -t "${PANE_MAP[$role]}" "claude --permission-mode auto" Enter
  sleep 3
done

# ── helper functions ────────────────────────────────────────────────────────

wait_tui_ready() {
  local pane="$1"
  until tmux capture-pane -p -t "$pane" 2>/dev/null | grep -qE "bypass permissions|auto mode"; do
    sleep 2
  done
}

wait_pane_done() {
  local pane="$1" snap1 snap2
  sleep 10
  while true; do
    snap1=$(tmux capture-pane -p -t "$pane" 2>/dev/null | md5sum)
    sleep 8
    snap2=$(tmux capture-pane -p -t "$pane" 2>/dev/null | md5sum)
    [[ "$snap1" == "$snap2" ]] && return
  done
}

send_prompt() {
  local pane="$1" prompt="$2"
  # Expand ${FEATURE} inside the prompt string
  prompt="${prompt//\$\{FEATURE\}/$FEATURE}"
  tmux send-keys -t "$pane" "$prompt"
  tmux send-keys -t "$pane" Enter
}

# ── per-role watcher (runs as background subshell) ──────────────────────────

run_role() {
  local idx="$1"
  local role pane prompt wait_for talks_to approve_signal reject_prompt max_rounds

  role=$(jq -r ".roles[$idx].name" "$WORKFLOW")
  prompt=$(jq -r ".roles[$idx].prompt" "$WORKFLOW")
  mapfile -t wait_for < <(jq -r ".roles[$idx][\"wait-for\"]? // [] | .[]" "$WORKFLOW")
  mapfile -t talks_to < <(jq -r ".roles[$idx][\"talks-to\"]? // [] | .[]" "$WORKFLOW")
  approve_signal=$(jq -r ".roles[$idx][\"approve-signal\"] // \"\"" "$WORKFLOW")
  reject_prompt=$(jq -r ".roles[$idx][\"reject-prompt\"] // \"\"" "$WORKFLOW")
  max_rounds=$(jq -r ".roles[$idx][\"max-rounds\"] // 1" "$WORKFLOW")
  pane="${PANE_MAP[$role]}"

  # Wait for TUI on first role only (others wait via signal files)
  [[ $idx -eq 0 ]] && wait_tui_ready "$pane"

  # Wait for all declared dependencies
  for dep in "${wait_for[@]}"; do
    until [[ -f "$SIGNAL_DIR/${dep}.done" ]]; do sleep 3; done
  done

  if [[ -n "$approve_signal" ]]; then
    # Review loop with optional talks-to feedback
    for round in $(seq 1 "$max_rounds"); do
      send_prompt "$pane" "$prompt Round ${round}."
      wait_pane_done "$pane"

      if tmux capture-pane -p -t "$pane" 2>/dev/null | grep -q "$approve_signal"; then
        break
      fi

      if [[ $round -lt $max_rounds && -n "$reject_prompt" ]]; then
        for target in "${talks_to[@]}"; do
          send_prompt "${PANE_MAP[$target]}" "$reject_prompt"
          wait_pane_done "${PANE_MAP[$target]}"
        done
      fi
    done
  else
    send_prompt "$pane" "$prompt"
    wait_pane_done "$pane"
  fi

  touch "$SIGNAL_DIR/${role}.done"
}

# ── launch all role watchers, coordinate via signal files ───────────────────

(
  for i in $(seq 0 $((N-1))); do
    run_role "$i" &
  done
  wait
) &
COORD_PID=$!
echo $COORD_PID > "$COORD_PID_FILE"
disown $COORD_PID

echo "Window '$PROJECT' added to session '$CURRENT_SESSION' ($N panes: ${ROLE_NAMES[*]})."
