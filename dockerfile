FROM ubuntu:23.10

RUN apt update
RUN apt install -y software-properties-common apt-transport-https wget curl locales
RUN add-apt-repository ppa:neovim-ppa/unstable

RUN apt update
RUN apt install -y zsh git tmux neovim sudo python3-neovim python3-dev python3-pip python3-venv fontconfig unzip ripgrep \
    fzf ripgrep fd-find bat exa htop ncdu tree clang cmake build-essential jq git-lfs axel sshfs clangd snapd

RUN useradd -ms /bin/zsh -d /home/fabrizio fabrizio
RUN echo "fabrizio:test" | chpasswd
RUN usermod -aG sudo fabrizio

RUN echo "fabrizio ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN axel -n8 https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-{{fastfetch_arch}}.deb --output fastfetch.deb
RUN dpkg -i fastfetch.deb

RUN axel -n8 https://go.dev/dl/go1.22.1.linux-arm64.tar.gz --output=go.tar.gz
RUN tar -C /usr/local -xzf go.tar.gz
RUN rm go.tar.gz

USER fabrizio
WORKDIR /home/fabrizio

ENV PATH="${PATH}:/usr/local/go/bin:${HOME}/.local/bin"
RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install golang.org/x/tools/cmd/gorename@latest

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit

RUN if [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then \
    git clone --depth=1 https://github.com/RitchieS/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa; \
    elif command -v apt >/dev/null; then \
    git clone --depth=1 https://github.com/ptavares/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa; \
    fi;

COPY tmux/tmux.conf .config/tmux/tmux.conf
RUN git clone --depth=1 https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

RUN mkdir -p ${HOME}/.local/bin
RUN ln -s /usr/bin/fdfind ${HOME}/.local/bin/fd
RUN ln -s /usr/bin/batcat ${HOME}/.local/bin/bat
RUN ln -s /usr/bin/pwsh ${HOME}/.local/bin/powershell

COPY fzf .config/fzf
COPY fzf/keybindings.sh /usr/share/doc/fzf/examples/key-bindings.zsh
COPY shell .config/shell
RUN echo 'source ${HOME}/.config/shell/aliases.zsh' >${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/shell/exports.zsh' >>${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/shell/zsh.zsh' >>${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/shell/p10k.zsh' >>${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/fzf/completion.sh' >>${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/fzf/keybindings.sh' >>${HOME}/.zshrc
RUN echo 'source ${HOME}/.config/shell/colors.zsh' >>${HOME}/.zshrc

USER root
RUN chown -R fabrizio /home/fabrizio/.config
RUN locale-gen en_US.UTF-8

USER fabrizio
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN ~/.tmux/plugins/tpm/scripts/install_plugins.sh

COPY nvim .config/nvim
RUN nvim --headless +qa
RUN nvim --headless +TSUpdateSync +MasonToolsInstallSync +qa

ENTRYPOINT [ "/bin/zsh", "-c", "tmux" ]



