FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color

# ── Base packages ─────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    software-properties-common apt-transport-https wget curl \
    locales sudo git git-lfs \
    zsh tmux \
    lua5.4 luarocks \
    python3.12 python3-neovim python3-dev python3-pip python3-venv \
    fontconfig unzip \
    fd-find bat eza ncdu tree axel socat \
    clang clangd cmake build-essential libc++-dev libc++abi-dev \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libpcre2-dev pkg-config \
    net-tools traceroute \
    openjdk-21-jdk \
    rustup \
    yq jq \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ── Non-root user ─────────────────────────────────────────────────────────────
RUN usermod -l dev -d /home/dev -m ubuntu \
    && groupmod -n dev ubuntu \
    && usermod -s /bin/zsh dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR /home/dev

ENV HOME=/home/dev
ENV PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/go/bin:${HOME}/go/bin:${HOME}/.fnm:${PATH}"
ENV GOROOT=/usr/local/go
ENV GOPATH=${HOME}/go

# ── Symlinks ──────────────────────────────────────────────────────────────────
RUN mkdir -p ${HOME}/.local/bin \
    && ln -s /usr/bin/fdfind ${HOME}/.local/bin/fd \
    && ln -s /usr/bin/batcat ${HOME}/.local/bin/bat \
    && sudo ln -s /usr/bin/python3.12 /usr/bin/python

# ── p4 CLI ───────────────────────────────────────────────────────────────────
# Install the real p4 binary (used for syntax awareness by tools like ansiblels)
# At runtime on Windows, the p4 wrapper delegates to the Windows host via SSH.
# RUN P4_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86-64") \
#     && wget -q "https://www.perforce.com/downloads/perforce/r24.2/bin.linux26${P4_ARCH}/p4" \
#     -O /tmp/p4 \
#     && sudo install -m 755 /tmp/p4 /usr/local/bin/p4-real \
#     && rm /tmp/p4

# ── JAVA_HOME ─────────────────────────────────────────────────────────────────
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-$(dpkg --print-architecture)" >> ${HOME}/.java_home.sh

# ── Rust ──────────────────────────────────────────────────────────────────────
RUN rustup default stable

# ── Go ────────────────────────────────────────────────────────────────────────
RUN GO_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") \
    && wget -q https://go.dev/dl/go1.24.2.linux-${GO_ARCH}.tar.gz -O /tmp/go.tar.gz \
    && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# ── Go tools ──────────────────────────────────────────────────────────────────
RUN GONOSUMCHECK=* GOFLAGS=-mod=mod go install golang.org/x/tools/gopls@v0.17.1 \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install github.com/jesseduffield/lazygit@latest \
    && go install github.com/jesseduffield/lazydocker@latest \
    && go install github.com/jorgerojas26/lazysql@latest \
    && go install github.com/Lifailon/lazyjournal@latest

# ── Rust tools ────────────────────────────────────────────────────────────────
RUN cargo install zoxide \
    && cargo install --features 'pcre2' ripgrep \
    && sudo cp ${HOME}/.cargo/bin/rg /usr/local/bin/rg

# ── fnm + Node LTS ────────────────────────────────────────────────────────────
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "${HOME}/.fnm" --skip-shell
RUN eval "$(/home/dev/.fnm/fnm env)" \
    && /home/dev/.fnm/fnm install --lts \
    && /home/dev/.fnm/fnm default lts-latest \
    && /home/dev/.fnm/fnm exec --using=default npm install -g neovim tree-sitter-cli @anthropic-ai/claude-code

# ── Neovim ────────────────────────────────────────────────────────────────────
RUN NVIM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") \
    && wget -q https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-${NVIM_ARCH}.tar.gz -O /tmp/nvim.tar.gz \
    && sudo tar -C /usr/local --strip-components=1 -xzf /tmp/nvim.tar.gz \
    && rm /tmp/nvim.tar.gz

# ── tiktoken_core ─────────────────────────────────────────────────────────────
RUN sudo -E env PATH="${HOME}/.cargo/bin:${PATH}" luarocks install --lua-version 5.1 tiktoken_core


# RUN curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.5.5/powershell-7.5.5-linux-x64.tar.gz \
RUN curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.5.5/powershell-7.5.5-linux-arm64.tar.gz \
    && sudo mkdir -p /opt/microsoft/powershell/7 \
    && sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && sudo chmod +x /opt/microsoft/powershell/7/pwsh \
    && sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# ── pynvim ────────────────────────────────────────────────────────────────────
RUN pip3 install --break-system-packages pynvim

# ── NerdFonts ─────────────────────────────────────────────────────────────────
COPY --chown=dev:dev NerdFonts/ /usr/local/share/fonts/NerdFonts/
RUN fc-cache -f

# ── Zinit ─────────────────────────────────────────────────────────────────────
RUN git clone --depth 1 https://github.com/zdharma-continuum/zinit.git ${HOME}/.zinit/bin

# ── TPM ───────────────────────────────────────────────────────────────────────
RUN git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

# ── Dotfiles ──────────────────────────────────────────────────────────────────
RUN mkdir -p ${HOME}/.config
COPY --chown=dev:dev shell/      ${HOME}/.config/shell/
COPY --chown=dev:dev tmux/       ${HOME}/.config/tmux/
COPY --chown=dev:dev nvim/       ${HOME}/.config/nvim/
COPY --chown=dev:dev mini/       ${HOME}/.config/mini/
COPY --chown=dev:dev lazygit/    ${HOME}/.config/lazygit/
COPY --chown=dev:dev lazydocker/ ${HOME}/.config/lazydocker/
COPY --chown=dev:dev lazysql/    ${HOME}/.config/lazysql/
COPY --chown=dev:dev fastfetch/  ${HOME}/.config/fastfetch/

# ── SSH client config ────────────────────────────────────────────────────────
# ~/.ssh is a named volume — key is generated on first run via setup-ssh.sh
RUN mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
RUN cat > ${HOME}/.ssh/config << 'SSHCONF'
Host windows-host
HostName host-gateway
User dev
StrictHostKeyChecking no
IdentityFile ~/.ssh/id_devenv
SSHCONF
RUN chmod 600 ${HOME}/.ssh/config

# ── p4 wrapper ────────────────────────────────────────────────────────────────
# Forwards all p4 commands to the Windows host over SSH.
# Falls back to p4-real if SSH key not yet set up or host unreachable.
RUN sudo tee /usr/local/bin/p4 > /dev/null << 'P4WRAPPER'
#!/usr/bin/env zsh
if [[ -f "${HOME}/.ssh/id_devenv" ]] && ssh -q -o ConnectTimeout=1 windows-host exit 2>/dev/null; then
exec ssh windows-host p4 "$@"
else
exec p4-real "$@"
fi
P4WRAPPER
RUN sudo chmod 755 /usr/local/bin/p4

# ── .zshrc ────────────────────────────────────────────────────────────────────
# bindkey '^?' is the correct zsh binding for DEL (what ghostty sends for backspace)
# No stty needed — zsh handles it in the line editor
RUN cat > ${HOME}/.zshrc << 'ZSHRC'
source ${HOME}/.java_home.sh
source ${HOME}/.config/shell/exports.zsh
source ${HOME}/.config/shell/aliases.zsh
source ${HOME}/.config/shell/colors.zsh
source ${HOME}/.config/shell/zinit.zsh
[[ ! -f ${HOME}/.config/shell/p10k.zsh ]] || source ${HOME}/.config/shell/p10k.zsh
bindkey '^?' backward-delete-char
eval "$(/home/dev/.fnm/fnm env)"
ZSHRC

# ── Pre-install zinit plugins ─────────────────────────────────────────────────
# Run twice: first pass downloads+registers, second pass confirms state is written
RUN HOME=/home/dev zsh -i -c '    source /home/dev/.zinit/bin/zinit.zsh &&     zinit load zsh-users/zsh-completions &&     zinit load zsh-users/zsh-history-substring-search &&     zinit load zsh-users/zsh-syntax-highlighting &&     zinit load zsh-users/zsh-autosuggestions &&     zinit load Aloxaf/fzf-tab &&     zinit load fabrizioperria/zsh-venv-autoswitch &&     zinit ice depth=1 &&     zinit load romkatv/powerlevel10k &&     zinit report --all ' 2>&1 || true
RUN HOME=/home/dev zsh -i -c '    source /home/dev/.zinit/bin/zinit.zsh &&     zinit load zsh-users/zsh-completions &&     zinit load zsh-users/zsh-history-substring-search &&     zinit load zsh-users/zsh-syntax-highlighting &&     zinit load zsh-users/zsh-autosuggestions &&     zinit load Aloxaf/fzf-tab &&     zinit load fabrizioperria/zsh-venv-autoswitch &&     zinit ice depth=1 &&     zinit load romkatv/powerlevel10k ' 2>&1 || true

# ── tmux plugins ──────────────────────────────────────────────────────────────
RUN ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh

# ── Source zshrc to initialize full environment before nvim bootstrap ───────
RUN zsh -i -c 'source ~/.zshrc' 2>&1 || true

# ── Neovim bootstrap ──────────────────────────────────────────────────────────
# HOME must be explicit — ENV HOME in Dockerfile doesn't always reach subprocesses
# Step 1: bootstrap lazy.nvim (init.lua clones it if missing)
RUN HOME=/home/dev nvim --headless --noplugin -c 'quit'

# Step 2: install all plugins via lazy
RUN HOME=/home/dev nvim --headless -c 'lua require("lazy").sync({wait=true})' -c 'quit'

# Step 3: treesitter + mason
RUN HOME=/home/dev eval "$(/home/dev/.fnm/fnm env)" \
    && HOME=/home/dev nvim --headless \
    -c 'lua require("lazy").sync({wait=true})' \
    -c 'TSUpdateSync' \
    # -c 'MasonToolsInstallSync' \
    -c 'quit'

# ── Fix ownership of everything written during build ─────────────────────────
RUN sudo chown -R dev:dev /home/dev/.local /home/dev/.config

# ── Workdir ───────────────────────────────────────────────────────────────────
RUN sudo mkdir -p /workspaces && sudo chown dev:dev /workspaces
WORKDIR /workspaces

ENTRYPOINT ["/bin/zsh", "-c", "tmux -u new-session -A -s main"]
