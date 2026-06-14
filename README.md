# dotfiles

One development environment, on every machine I touch.

This repo provisions the same editor, shell, tooling, and terminal experience three ways:

- **macOS, natively** — via Homebrew + Ansible (my personal machine).
- **Ubuntu, natively** — via apt + Ansible (a full desktop setup).
- **Anywhere, in a container** — a `devenv` image that reproduces the environment headlessly, with no native installs. This is how I get my setup onto a locked-down work machine without touching the host, and how I sandbox coding agents (Claude Code) so they run isolated from the real system.

The guiding principle: it should feel identical whether I'm on my Mac, on a Linux box, or shelled into the container.

## Layout

```
ansible/
  playbook.yml            # selects the macos or ubuntu role by OS family
  roles/
    macos/                # Homebrew packages, casks, Colima/Docker, then shared roles
    ubuntu/               # apt packages, desktop apps (Zen, Ghostty, GNOME), then shared roles
    common/shared/        # cross-platform installs reused by BOTH platforms:
                          #   fnm go zig nvim zsh ripgrep zoxide tpm
                          #   lazygit lazydocker lazysql lazyjournal
    common/linux/         # Linux-only: docker fastfetch fonts ghostty
dockerfile                # builds devenv:latest (headless mirror of the same toolchain)
container_run.sh          # runs the container (docker/podman) + agent sandbox mounts
container_run.ps1         # Windows equivalent
ansible_install.sh        # bootstrap: installs Ansible, then runs the playbook
Makefile                  # entry points (see Usage)
nvim/  mini/              # Neovim config; `mini` is a stripped-down profile (the `vi` alias)
shell/ tmux/ ghostty/     # config copied into ~/.config
fastfetch/ lazygit/ lazydocker/ lazysql/ powershell/
NerdFonts/                # fonts installed during provisioning
claude/                   # Claude Code agent policy, hooks, and MCP config
.screenlayout/            # xrandr layouts (Linux)
```

The two platform roles (`macos`, `ubuntu`) carry only the package-manager-specific bits; everything portable lives in `common/shared` and is included by both. The Dockerfile is a separate build that reproduces the same shared toolchain headlessly — so native and container parity is currently maintained side by side.

## What you get

Neovim (with Mason/LSP and a minimal `mini` profile), zsh (zinit + powerlevel10k), tmux (tpm), and a terminal toolchain of ripgrep, fd, bat, eza, zoxide, fzf, ncdu, bottom, jq/yq, plus the lazy-suite (lazygit, lazydocker, lazysql, lazyjournal). Language toolchains: Go, Zig, Rust (rustup), Node (fnm). On the desktop platforms it also sets up Ghostty, fonts, and GUI apps.

## Usage

### Native setup (macOS or Ubuntu)

```sh
make ansible
```

This runs `ansible_install.sh`, which installs Ansible (Homebrew on macOS, apt on Ubuntu) and then runs the playbook. The playbook auto-detects the OS and applies the right role; pass `--ask-become-pass` is already wired in. To re-run against an existing Ansible install, `./ansible_install.sh --skip-install`.

> The Ubuntu role is a full desktop provision — it sets the timezone, installs GUI apps, and prompts for a root password.

### Refresh just the configs

When only the dotfiles changed (not the tooling):

```sh
make nvim     # copies nvim/  -> ~/.config/nvim
make shell    # copies shell/ -> ~/.config/shell  (then reload zsh)
make tmux     # copies tmux/  -> ~/.config/tmux    (then reload tmux)
```

### Container

Build the image, then run it:

```sh
make build_docker          # docker build -> devenv:latest
make build_podman          # podman equivalent (auto-detects arch)

make run_docker            # build + run, drops you into tmux
make run_docker_notmux     # build + run, bare zsh (used for the agent sandbox)
make run_podman            # run with podman
```

Or run directly, mounting working directories into `/workspaces/<name>`:

```sh
./container_run.sh ~/projects/my-app ~/projects/other
```

On Windows the Makefile automatically uses `pwsh -File container_run.ps1`. The container itself only needs a container engine with a Linux backend underneath — Colima on macOS (installed by the macOS role), Docker Desktop or Podman on WSL2 for Windows.

## Container & agent sandbox

`devenv:latest` is an `ubuntu:24.04` image running as a non-root `dev` user, with the full shared toolchain and a `zsh` + `tmux` entrypoint. It also supports **nested Podman** — `container_run.sh` adds the device and security flags (`/dev/fuse`, seccomp/userns adjustments) needed to run containers inside the dev container, regardless of whether the outer engine is Docker or Podman.

The container doubles as a sandbox for running Claude Code in isolation. Key properties:

- The agent's guardrails (`settings.json`, `policy-limits.json`, `hooks/`) are mounted **read-only** from a host policy directory, so the agent can't edit its own policy from inside.
- Container state is kept separate from the host: its own `.zsh_history`, its own `.ssh`, and named volumes for Neovim data, Claude data, and the nested Podman store.
- Only the directories you pass to `container_run.sh` (plus a fixed set of workspaces) are mounted in.

Before first use, stage the policy directory the script expects (it aborts if missing). See the header comment in `container_run.sh` for the exact commands; the gist is copying the files from `claude/` into a root-owned directory and pointing `AGENT_POLICY` at it.

> Several paths in `container_run.sh` are personal (the default `AGENT_POLICY` location and the fixed workspace mounts). Adjust those to your own machine if you fork this.

## Notes

- Tool versions are pinned (Go, Zig, Neovim, Rust, fnm, plugins) for reproducible rebuilds; bumping a version is a deliberate edit.
- The native path and the container are two implementations of the same environment, so a tool added to one needs adding to the other to stay in parity.
- Requires `git` and `make`; the rest is bootstrapped by `make ansible` (native) or a container engine (container).
