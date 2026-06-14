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
entry/                    # container entrypoint + egress firewall, baked into the image:
  devenv-entry            #   runs the firewall as root, then drops to the dev user
  init-firewall.sh        #   default-deny iptables/ipset egress allowlist
  allowlist.local.example #   template for gitignored, site-local allowlist additions
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

> The container is launched with `--user root` and the `NET_ADMIN`/`NET_RAW` capabilities so it can install its own egress firewall at boot (see below), then it drops to the unprivileged `dev` user. Those capabilities can't be baked into an image, so any launcher that starts the container must grant them — the provided runners do.

## Container & agent sandbox

`devenv:latest` is an `ubuntu:24.04` image running as a non-root `dev` user, with the full shared toolchain and a firewall-then-`tmux` entrypoint (see *Egress firewall* below). It also supports **nested Podman** — `container_run.sh` adds the device and security flags (`/dev/fuse`, seccomp/userns adjustments) needed to run containers inside the dev container, regardless of whether the outer engine is Docker or Podman.

The container doubles as a sandbox for running Claude Code in isolation. Key properties:

- **Read-only policy.** The agent's guardrails (`settings.json`, `policy-limits.json`, `hooks/`) are mounted **read-only** from a host policy directory, so the agent can't edit its own policy from inside.
- **Separated state.** Container state is kept separate from the host: its own `.zsh_history`, its own `.ssh`, and named volumes for Neovim data, Claude data, and the nested Podman store.
- **Scoped mounts.** Only the directories you pass to `container_run.sh` (plus a fixed set of workspaces) are mounted in.
- **Locked-down egress** — see below.

Before first use, stage the policy directory the script expects (it aborts if missing). See the header comment in `container_run.sh` for the exact commands; the gist is copying the files from `claude/` into a root-owned directory and pointing `AGENT_POLICY` at it.

> Several paths in `container_run.sh` are personal (the default `AGENT_POLICY` location and the fixed workspace mounts). Adjust those to your own machine if you fork this.

### Egress firewall

The sandbox doesn't just restrict the filesystem — it restricts the network. On boot the container runs `entry/init-firewall.sh` (as root, before any session starts) to install an `iptables` + `ipset` **default-deny** egress allowlist. Only an explicit set of destinations is reachable; everything else is rejected:

- the Anthropic API,
- GitHub (pinned by its published CIDR ranges, so per-host IP rotation — e.g. `codeload` — doesn't slip out),

Once the rules are in place, `entry/devenv-entry` permanently drops from root to the `dev` user. Two things make the leash hold: the image build **removes `sudo` entirely**, and dropping uid 0 → `dev` sheds `NET_ADMIN` — so nothing in the session, the agent included, can widen or flush the rules. It is also **fail-closed**: if the firewall can't be built and verified at boot, the container exits before handing over a shell.

**Site-local additions.** Hosts specific to one environment that shouldn't be public (a work Perforce IP, an internal CI/TeamCity host, etc.) go in `entry/allowlist.local` — one entry per line, hostnames or raw IPs/CIDRs. That file is **gitignored**; at image build time its entries are spliced directly into the firewall script and baked into the image, so they never reach the repo and there's no extra file to mount or tamper with. Copy `entry/allowlist.local.example` to get started. To change the allowlist, edit the file and rebuild.

### Knowing which environment you're in

tmux colors the pane border by environment so a shell's *location* is obvious at a glance — host panes render in blue, devenv-container panes in green. When you launch the container from inside tmux, the runner tags that pane with a `@devenv` flag, so a green container pane stands out from the blue host panes around it (handy when a container shell is nested inside your host session). The colors live in `tmux/`.

## Notes

- Tool versions are pinned (Go, Zig, Neovim, Rust, fnm, plugins) for reproducible rebuilds; bumping a version is a deliberate edit.
- The native path and the container are two implementations of the same environment, so a tool added to one needs adding to the other to stay in parity.
- The egress allowlist in `entry/init-firewall.sh` is the one knob to maintain as your work hits new hosts — public entries in the script, private ones in `entry/allowlist.local`.
- Requires `git` and `make`; the rest is bootstrapped by `make ansible` (native) or a container engine (container).
