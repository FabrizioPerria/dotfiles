# devenv.zsh — inside the dev container, stamp the terminal title so the host
# tmux can tell this pane apart from a native one (see pane-border-format in
# tmux.conf). The title rides the terminal stream, so it survives the
# make -> container_run.sh -> docker launch chain that hides the engine from
# #{pane_current_command}. No-op outside the container.
#
# Must be sourced AFTER zinit loads powerlevel10k, so our title write runs
# after p10k's and wins (sourced last in .zshrc, both native and in the
# Dockerfile's .zshrc heredoc).

if [[ -n "$DEVENV" ]]; then
  autoload -Uz add-zsh-hook

  # OSC 2 sets the pane title; tmux captures it into #{pane_title}.
  # DEVENV_MODE (e.g. "agent"), if set by container_run.sh, is appended.
  _devenv_set_title()   { print -Pn "\e]2;devenv${DEVENV_MODE:+:${DEVENV_MODE}}\a"; }

  # Reset the title when this shell exits, so the host pane doesn't stay
  # stuck on "devenv" (and amber) after you leave the container.
  _devenv_clear_title() { print -Pn "\e]2;\a"; }

  add-zsh-hook precmd  _devenv_set_title
  add-zsh-hook preexec _devenv_set_title
  add-zsh-hook zshexit _devenv_clear_title
fi
