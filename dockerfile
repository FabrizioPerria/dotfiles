FROM ubuntu:24.04@sha256:c4a8d5503dfb2a3eb8ab5f807da5bc69a85730fb49b5cfca2330194ebcc41c7b

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm-256color


# ── Base packages ─────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    openjdk-21-jdk maven \
    dos2unix \
    iputils-ping \
    rustup \
    yq jq \
    dotnet-sdk-8.0 dotnet-runtime-8.0 \
    dotnet-sdk-10.0 dotnet-runtime-10.0 \
    clangd-16 \
    lsof \
    && locale-gen en_US.UTF-8

# ── p4 ────────────────────────────────────────────────────────────────────
RUN if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
    wget -qO - https://package.perforce.com/perforce.pubkey \
    | sudo tee /etc/apt/trusted.gpg.d/perforce.asc > /dev/null \
    && echo "deb http://package.perforce.com/apt/ubuntu noble release" \
    | sudo tee /etc/apt/sources.list.d/perforce.list \
    && sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends p4-cli; \
    fi

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# ── Non-root user ─────────────────────────────────────────────────────────────
RUN usermod -l dev -d /home/dev -m ubuntu \
    && groupmod -n dev ubuntu \
    && usermod -s /bin/zsh dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR /home/dev

ENV HOME=/home/dev
ENV PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/go/bin:${HOME}/go/bin:${HOME}/.fnm:${HOME}/.fnm/aliases/default/bin:${HOME}/.sdkman/candidates/gradle/current/bin:${PATH}"
ENV GOROOT=/usr/local/go
ENV GOPATH=${HOME}/go

# ── Symlinks ──────────────────────────────────────────────────────────────────
RUN mkdir -p ${HOME}/.local/bin \
    && ln -s /usr/bin/fdfind ${HOME}/.local/bin/fd \
    && ln -s /usr/bin/batcat ${HOME}/.local/bin/bat \
    && sudo ln -s /usr/bin/python3.12 /usr/bin/python

# ── Java ──────────────────────────────────────────────────────────────────────
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-$(dpkg --print-architecture)" >> ${HOME}/.java_home.sh
RUN curl -s "https://get.sdkman.io?rcupdate=false" | SDKMAN_VERSION=5.22.5 bash \
    && bash -c "source /home/dev/.sdkman/bin/sdkman-init.sh && sdk install gradle 9.5.1"

# ── Rust ──────────────────────────────────────────────────────────────────────
RUN rustup default 1.95.0

# ── Go ────────────────────────────────────────────────────────────────────────
RUN GO_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") \
    && wget -q https://go.dev/dl/go1.24.2.linux-${GO_ARCH}.tar.gz -O /tmp/go.tar.gz \
    && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

RUN GONOSUMCHECK=* GOFLAGS=-mod=mod go install golang.org/x/tools/gopls@v0.17.1 \
    && go install github.com/go-delve/delve/cmd/dlv@v1.24.2 \
    && go install golang.org/x/tools/cmd/goimports@v0.31.0 \
    && go install github.com/jesseduffield/lazygit@v0.61.1 \
    && go install github.com/jesseduffield/lazydocker@v0.25.2 \
    && go install github.com/jorgerojas26/lazysql@v0.4.8 \
    && go install github.com/Lifailon/lazyjournal@0.8.6 \
    && go install github.com/JetBrains/teamcity-cli/tc@v0.7.2

# ── Rust tools ────────────────────────────────────────────────────────────────
RUN cargo install zoxide --version 0.9.9 \
    && cargo install --features 'pcre2' ripgrep --version 14.1.1 \
    && sudo cp ${HOME}/.cargo/bin/rg /usr/local/bin/rg

# ── Zig ───────────────────────────────────────────────────────────────────────
ARG ZIG_VERSION=0.16.0
RUN ZIG_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "x86_64") \
    && wget -q "https://ziglang.org/download/${ZIG_VERSION}/zig-${ZIG_ARCH}-linux-${ZIG_VERSION}.tar.xz" -O /tmp/zig.tar.xz \
    && sudo tar -C /usr/local -xJf /tmp/zig.tar.xz \
    && sudo ln -s /usr/local/zig-${ZIG_ARCH}-linux-${ZIG_VERSION}/zig /usr/local/bin/zig \
    && rm /tmp/zig.tar.xz

# ── tealdeer ──────────────────────────────────────────────────────────────────
RUN cargo install tealdeer \
    && tldr --update

# ── fnm + Node LTS ────────────────────────────────────────────────────────────
RUN FNM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "linux") \
    && curl -fsSL "https://github.com/Schniz/fnm/releases/download/v1.39.0/fnm-${FNM_ARCH}.zip" -o /tmp/fnm.zip \
    && unzip /tmp/fnm.zip -d /tmp/fnm \
    && mkdir -p ${HOME}/.fnm \
    && mv /tmp/fnm/fnm ${HOME}/.fnm/fnm \
    && chmod +x ${HOME}/.fnm/fnm \
    && rm -rf /tmp/fnm /tmp/fnm.zip
RUN eval "$(/home/dev/.fnm/fnm env)" \
    && /home/dev/.fnm/fnm install --lts \
    && /home/dev/.fnm/fnm default lts-latest \
    && /home/dev/.fnm/fnm exec --using=default npm install -g neovim tree-sitter-cli \
    && git clone --depth 1 https://github.com/dandaka/ccquota.git /tmp/ccquota \
    && cd /tmp/ccquota \
    && /home/dev/.fnm/fnm exec --using=default npm install -g . \
    && rm -rf /tmp/ccquota

# ── Neovim ────────────────────────────────────────────────────────────────────
RUN NVIM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") \
    && wget -q https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-${NVIM_ARCH}.tar.gz -O /tmp/nvim.tar.gz \
    && sudo tar -C /usr/local --strip-components=1 -xzf /tmp/nvim.tar.gz \
    && rm /tmp/nvim.tar.gz

# ── Claude Code ───────────────────────────────────────────────────────────────
RUN curl -fsSL https://claude.ai/install.sh | bash

# ── tiktoken_core ─────────────────────────────────────────────────────────────
RUN sudo -E env PATH="${HOME}/.cargo/bin:${PATH}" luarocks install --lua-version 5.1 tiktoken_core

# ── powershell ─────────────────────────────────────────────────────────────
RUN PWSH_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x64") \
    && curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.5.5/powershell-7.5.5-linux-${PWSH_ARCH}.tar.gz \
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
RUN git clone --depth 1 https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

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

# ── .zshrc ────────────────────────────────────────────────────────────────────
# bindkey '^?' is the correct zsh binding for DEL (what ghostty sends for backspace)
# No stty needed — zsh handles it in the line editor
RUN cat > ${HOME}/.zshrc << 'ZSHRC'
source ${HOME}/.config/shell/exports.zsh
source ${HOME}/.config/shell/aliases.zsh
source ${HOME}/.java_home.sh
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
RUN rm -rf /home/dev/.local/share/nvim
RUN HOME=/home/dev nvim --headless \
    -c 'autocmd User MasonToolsUpdateCompleted qall!' \
    -c 'TSUpdate' \
    -c 'lua require("mason-tool-installer").check_install(true)' 2>&1 || true

# ── Claude config ─────────────────────────────────────────────────────────────
RUN mkdir -p /home/dev/.claude
COPY --chown=dev:dev claude/CLAUDE.md             /home/dev/.claude/CLAUDE.md
COPY --chown=dev:dev claude/settings.json         /home/dev/.claude/settings.json
COPY --chown=dev:dev claude/statusline-command.sh /home/dev/.claude/statusline-command.sh
RUN touch /home/dev/.claude/.caveman-active

# ── Caveman plugin (SHA: c2ed24b3e5d412cd0c25197b2bc9af587621fd99) ───────────────────────────────
RUN mkdir -p /home/dev/.claude/plugins \
    && git clone https://github.com/JuliusBrussee/caveman "/home/dev/.claude/plugins/cache/caveman/caveman/c2ed24b3e5d4" \
    && git -C "/home/dev/.claude/plugins/cache/caveman/caveman/c2ed24b3e5d4" checkout "c2ed24b3e5d412cd0c25197b2bc9af587621fd99" \
    && echo '{ \
    "version": 2, \
    "plugins": { \
    "caveman@caveman": [ \
    { \
    "scope": "user", \
    "installPath": "/home/dev/.claude/plugins/cache/caveman/caveman/c2ed24b3e5d4", \
    "version": "c2ed24b3e5d4", \
    "installedAt": "2026-01-01T00:00:00.000Z", \
    "lastUpdated": "2026-01-01T00:00:00.000Z", \
    "gitCommitSha": "c2ed24b3e5d412cd0c25197b2bc9af587621fd99" \
    } \
    ] \
    } \
    }' > /home/dev/.claude/plugins/installed_plugins.json

RUN touch /home/dev/.claude.json
RUN mkdir -p /home/dev/.config/tc

RUN printf '#!/bin/sh\nbuf=$(cat)\nencoded=$(printf "%%s" "$buf" | base64 | tr -d "\\n")\nprintf "\\033]52;c;%%s\\a" "$encoded" > /dev/tty\n' \
    > ${HOME}/.local/bin/osc52copy \
    && chmod +x ${HOME}/.local/bin/osc52copy

# ── clangd (arm64 only — mason can't install it on arm64) ─────────────────────
RUN if [ "$TARGETARCH" = "arm64" ]; then \
    mkdir -p ${HOME}/.local/share/nvim/mason/bin \
    && mkdir -p ${HOME}/.local/share/nvim/mason/packages/clangd \
    && ln -s /usr/bin/clangd-16 ${HOME}/.local/share/nvim/mason/bin/clangd; \
    fi

# ── Fix ownership of everything written during build ─────────────────────────
RUN sudo chown -R dev:dev /home/dev/.local /home/dev/.config

# ── Workdir ───────────────────────────────────────────────────────────────────
RUN sudo mkdir -p /workspaces && sudo chown dev:dev /workspaces
WORKDIR /workspaces

ENTRYPOINT ["/bin/zsh", "-c", "tmux -u new-session -A -s main"]
