FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install base packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    wget \
    curl \
    locales \
    lua5.4 \
    luarocks \
    zsh \
    git \
    tmux \
    sudo \
    python3-neovim \
    python3-dev \
    python3-pip \
    python3-venv \
    fontconfig \
    unzip \
    fd-find \
    bat \
    eza \
    ncdu \
    tree \
    clang \
    libc++-dev \
    libc++abi-dev \
    yq \
    jq \
    cmake \
    build-essential \
    net-tools \
    traceroute \
    git-lfs \
    axel \
    clangd \
    virtualenv \
    make \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libpcre2-dev \
    pkg-config \
    python3.12 \
    openjdk-21-jdk \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for fd and bat
RUN mkdir -p /root/.local/bin && \
    ln -s /usr/bin/fdfind /root/.local/bin/fd && \
    ln -s /usr/bin/batcat /root/.local/bin/bat && \
    ln -s /usr/bin/python3.12 /usr/bin/python

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install ripgrep with pcre2 support
RUN cargo install --features 'pcre2' ripgrep && \
    cp /root/.cargo/bin/rg /usr/local/bin/rg

# Install zoxide
RUN cargo install zoxide && \
    cp /root/.cargo/bin/zoxide /usr/local/bin/zoxide

# Install Go
RUN GO_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    wget -q https://go.dev/dl/go1.23.0.linux-${GO_ARCH}.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"
ENV GOPATH="/root/go"

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install golang.org/x/tools/cmd/gorename@latest

# Install lazygit, lazydocker, lazysql, lazyjournal
RUN go install github.com/jesseduffield/lazygit@latest && \
    go install github.com/jesseduffield/lazydocker@latest && \
    go install github.com/jorgerojas26/lazysql@latest && \
    go install github.com/Lifailon/lazyjournal@latest

# Install Neovim
RUN NVIM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") && \
    wget -q https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-${NVIM_ARCH}.tar.gz -O /tmp/nvim.tar.gz && \
    tar -C /usr/local --strip-components=1 -xzf /tmp/nvim.tar.gz && \
    rm /tmp/nvim.tar.gz

# Install tiktoken_core for neovim
RUN luarocks install --lua-version 5.1 tiktoken_core

# Install pynvim
RUN pip3 install --break-system-packages pynvim

# Install fnm and Node.js
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "/root/.fnm" --skip-shell
ENV PATH="/root/.fnm:${PATH}"
RUN eval "$(/root/.fnm/fnm env)" && \
    /root/.fnm/fnm install --lts && \
    /root/.fnm/fnm default lts-latest && \
    echo "eval \"\$(root/.fnm/fnm env)\"" >> /root/.zshrc

# Install neovim and tree-sitter-cli npm packages
RUN eval "$(/root/.fnm/fnm env)" && \
    npm install -g neovim tree-sitter-cli

# Install Claude Code
RUN eval "$(/root/.fnm/fnm env)" && \
    npm install -g @anthropic-ai/claude-code

# Install Zinit for zsh
RUN git clone --depth 1 https://github.com/ryanstreur/zinit.git /root/.zinit/bin && \
    chmod 755 /root/.zinit/bin/zinit.zsh

# Install tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm

# Set default shell
ENV SHELL=/bin/zsh
RUN chsh -s /bin/zsh root

WORKDIR /workspaces
