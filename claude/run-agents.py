#!/usr/bin/env python3
"""Generic agentic workflow runner driven by workflow.json.
Usage: ./run-agents.py "feature description" [workflow.json]
"""

import json
import logging
import os
import shutil
import signal
import sys
import threading
import time
from pathlib import Path


DEFAULT_TIMEOUT = 600  # seconds


# ── tmux helpers ──────────────────────────────────────────────────────────────

def tmux(*args):
    import subprocess
    r = subprocess.run(['tmux'] + list(args), capture_output=True, text=True)
    return r.stdout.strip()


def capture(pane):
    return tmux('capture-pane', '-p', '-t', pane)


def send(pane, text):
    tmux('send-keys', '-t', pane, text)
    tmux('send-keys', '-t', pane, 'Enter')


# ── sentinel helpers ───────────────────────────────────────────────────────────

def sentinel(signal_dir, name):
    return signal_dir / f'{name}.done'


def clear_sentinel(signal_dir, name):
    sentinel(signal_dir, name).unlink(missing_ok=True)


def wait_sentinel(path, timeout, log, label):
    deadline = time.time() + timeout
    while time.time() < deadline:
        if path.exists():
            return True
        time.sleep(3)
    log.error(f'[{label}] timed out after {timeout}s waiting for {path.name}')
    return False


def prompt_with_sentinel(prompt, sentinel_path):
    return (
        f"{prompt}\n\n"
        f"When fully done, signal completion by running exactly:\n"
        f"`touch {sentinel_path}`"
    )


# ── wait helpers ──────────────────────────────────────────────────────────────

def wait_tui_ready(pane, timeout=120):
    deadline = time.time() + timeout
    while time.time() < deadline:
        if any(kw in capture(pane) for kw in ('auto mode', 'bypass permissions')):
            return True
        time.sleep(2)
    return False


# ── per-role logic ────────────────────────────────────────────────────────────

def run_role(idx, workflow, pane_map, signal_dir, feature, log):
    r = workflow['roles'][idx]
    name           = r['name']
    base_prompt    = r['prompt'].replace('${FEATURE}', feature)
    wait_for       = r.get('wait-for', [])
    talks_to       = r.get('talks-to', [])
    approve_signal = r.get('approve-signal', '')
    reject_prompt  = r.get('reject-prompt', '')
    max_rounds     = r.get('max-rounds', 1)
    timeout        = r.get('timeout', DEFAULT_TIMEOUT)
    pane           = pane_map[name]
    my_sentinel    = sentinel(signal_dir, name)

    log.info(f'[{name}] waiting for deps: {wait_for or "none"}')
    for dep in wait_for:
        if not wait_sentinel(sentinel(signal_dir, dep), timeout, log, name):
            return

    if approve_signal:
        for round_num in range(1, max_rounds + 1):
            log.info(f'[{name}] round {round_num}/{max_rounds}')
            clear_sentinel(signal_dir, name)
            send(pane, prompt_with_sentinel(f'{base_prompt} (Round {round_num})', my_sentinel))

            if not wait_sentinel(my_sentinel, timeout, log, name):
                return

            if approve_signal in capture(pane):
                log.info(f'[{name}] approved')
                break

            if round_num < max_rounds and reject_prompt:
                log.info(f'[{name}] rejected — notifying {talks_to}')
                for target in talks_to:
                    clear_sentinel(signal_dir, target)
                    send(pane_map[target], prompt_with_sentinel(reject_prompt, sentinel(signal_dir, target)))
                for target in talks_to:
                    wait_sentinel(sentinel(signal_dir, target), timeout, log, f'{name}→{target}')
    else:
        clear_sentinel(signal_dir, name)
        send(pane, prompt_with_sentinel(base_prompt, my_sentinel))
        if not wait_sentinel(my_sentinel, timeout, log, name):
            return

    log.info(f'[{name}] done')


# ── main ──────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        sys.exit(f'Usage: {sys.argv[0]} "feature description" [workflow.json]')

    feature = sys.argv[1]
    script_dir = Path(sys.argv[0]).resolve().parent
    workflow_path = Path(sys.argv[2]) if len(sys.argv) > 2 else script_dir / 'workflow.json'

    workflow = json.loads(workflow_path.read_text())
    roles = workflow['roles']
    names = [r['name'] for r in roles]
    n = len(roles)

    project    = Path.cwd().name
    signal_dir = Path(f'/tmp/agents-signals-{project}')
    pid_file   = Path(f'/tmp/agents-coord-{project}.pid')
    log_file   = Path(f'/tmp/agents-coord-{project}.log')

    # Kill stale coordinator
    if pid_file.exists():
        try:
            os.kill(int(pid_file.read_text()), signal.SIGTERM)
        except (ProcessLookupError, ValueError):
            pass
        pid_file.unlink(missing_ok=True)

    # Current tmux session
    session = os.environ.get('TMUX_SESSION', 'main')
    if os.environ.get('TMUX'):
        session = tmux('display-message', '-p', '#S')

    # Reset signals
    if signal_dir.exists():
        shutil.rmtree(signal_dir)
    signal_dir.mkdir(parents=True)

    # Kill existing window if present
    tmux('kill-window', '-t', f'{session}:{project}')

    # Create window + panes
    cwd = str(Path.cwd())
    tmux('new-window', '-t', session, '-n', project, '-c', cwd)

    pane_map = {}
    pane_map[names[0]] = tmux('list-panes', '-t', f'{session}:{project}', '-F', '#{pane_id}').splitlines()[0]

    for i in range(1, n):
        pane_id = tmux('split-window', '-h', '-t', pane_map[names[i-1]], '-c', cwd, '-P', '-F', '#{pane_id}')
        pane_map[names[i]] = pane_id

    tmux('select-layout', '-t', f'{session}:{project}', 'even-horizontal' if n <= 3 else 'tiled')

    for name in names:
        tmux('set-option', '-t', pane_map[name], '-p', '@role', f'{name}-agent')

    # Start claude in each pane, staggered
    for name in names:
        send(pane_map[name], 'claude --permission-mode auto')
        time.sleep(3)

    print(f"Window '{project}' added to session '{session}' ({n} panes: {' '.join(names)}).")
    print(f"Coordinator log: tail -f {log_file}")

    # Fork: parent exits, child runs coordinator threads
    pid = os.fork()
    if pid > 0:
        pid_file.write_text(str(pid))
        sys.exit(0)

    # Child — coordinator
    os.setsid()
    log_fd = open(log_file, 'w', buffering=1)
    sys.stdout = log_fd
    sys.stderr = log_fd
    logging.basicConfig(stream=log_fd, level=logging.INFO, format='%(asctime)s %(message)s', datefmt='%H:%M:%S')
    log = logging.getLogger('coord')

    log.info('Waiting for all TUIs...')
    for name in names:
        wait_tui_ready(pane_map[name])
        log.info(f'[{name}] TUI ready')

    threads = [
        threading.Thread(target=run_role, args=(i, workflow, pane_map, signal_dir, feature, log), daemon=False)
        for i in range(n)
    ]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    log.info('All roles complete.')


if __name__ == '__main__':
    main()
