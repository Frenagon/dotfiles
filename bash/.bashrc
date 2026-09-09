# ~/.bashrc
#
# Omarchy's stock .bashrc (env-bootstrap + the default rc chain) is the source
# of truth for history, prompt, zoxide, completions, and the default alias/
# function set. Everything under "Personal additions" is config Omarchy does
# not provide — with one deliberate exception: the eza aliases below override
# Omarchy's own `ls`/`lt` with this machine's preferred flags.

# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# Auto-attach tmux for interactive shells. Done before sourcing Omarchy's rc so
# the rc chain isn't loaded twice when we re-exec into tmux (panes re-enter this
# file with $TMUX set and fall through to the rc source below).
if [ -z "$TMUX" ] && [ -n "$PS1" ] && command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s 0-terminal
fi

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them below!)
source "$OMARCHY_PATH/default/bash/rc"

######################## Personal additions ########################

### Personal helper scripts (see ~/.dotfiles/scripts) ###
export PATH="$HOME/.local/scripts:$PATH"

### History: share immediately across sessions/tmux panes. Omarchy only sets
### histappend (write on exit); this appends after every command and reloads. ###
shopt -s cmdhist
PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

### direnv (per-directory env loading) ###
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
alias vi=nvim
alias vim=nvim

# eza — deliberately overrides Omarchy's `ls`/`lt`. `ls`/`lt` expand through the
# `eza` alias so the base flags apply to both, and Omarchy's own `lsa`/`lta`
# (defined as `ls -a` / `lt -a`) inherit them too.
alias eza='eza --icons auto --git --sort=ext --group-directories-first'
alias ls=eza
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias lt='eza --tree'

### ble.sh: bash equivalent of zsh-autosuggestions + zsh-syntax-highlighting ###
# https://github.com/akinomyoga/ble.sh — must be sourced last in .bashrc.
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh
