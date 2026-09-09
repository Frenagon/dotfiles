# ~/.bashrc
#
# Converted from a NixOS home-manager-generated .zshrc for use on non-Nix
# systems (targeting a plain Omarchy install running foot). Dropped entirely:
# Nix store paths, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting (no
# direct bash equivalent short of installing ble.sh — see note at bottom),
# the NixOS-only aliases (ndev/nfu/nrs/nrt), the caelestia OSC colour-sequence
# loading, and kitty/ghostty shell integration (not used with foot).

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

### History ###
HISTSIZE=10000
HISTFILESIZE=10000
HISTFILE="$HOME/.bash_history"
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s cmdhist
# Share history across sessions/tmux panes: append after each command, then
# reload, rather than only on shell exit.
PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

### Personal helper scripts (see ~/.dotfiles/scripts) ###
export PATH="$HOME/.local/scripts:$PATH"

### Auto-attach tmux for interactive shells ###
if [ -z "$TMUX" ] && [ -n "$PS1" ] && command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s 0-terminal
fi

### Prompt ###
if [[ $TERM != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

### zoxide (smarter cd) ###
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash --cmd cd)"
fi

### direnv ###
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

### lazygit helper: cd into whatever directory lazygit left you in ###
lg() {
  export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
  command lazygit "$@"
  if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
    cd "$(cat "$LAZYGIT_NEW_DIR_FILE")" || return
    rm -f "$LAZYGIT_NEW_DIR_FILE"
  fi
}

### Aliases ###
alias ai=claude
alias eza='eza --icons auto --sort=ext --sort=name --group-directories-first'
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias ls=eza
alias lt='eza --tree'
alias vi=nvim
alias vim=nvim

### ble.sh: bash equivalent of zsh-autosuggestions + zsh-syntax-highlighting ###
# https://github.com/akinomyoga/ble.sh — must be sourced last in .bashrc.
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh
