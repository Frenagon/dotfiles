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

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them below!)
source "$OMARCHY_PATH/default/bash/rc"

######################## Personal additions ########################

### Personal helper scripts (see ~/.dotfiles/scripts) ###
export PATH="$HOME/.local/scripts:$PATH"

### History: share immediately across sessions/tmux panes. Omarchy only sets
### histappend (write on exit); this appends after every command and reloads.
### Wrapped in a function that restores $? so it doesn't clobber the exit
### status the rest of PROMPT_COMMAND (starship's prompt character) reads. ###
shopt -s cmdhist
__share_history() { local __e=$?; history -a; history -c; history -r; return $__e; }
PROMPT_COMMAND="__share_history${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

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
alias eza='eza --icons auto --git --sort=name --group-directories-first'
alias ls=eza
alias l='ls -lah'
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias lt='eza --tree'

### oh-my-zsh "git" plugin parity ###
# The NixOS .zshrc used oh-my-zsh's git plugin, which supplies ~200 git
# aliases plus a few helper functions the aliases call into
# ($(git_current_branch)/$(git_main_branch)/$(git_develop_branch), etc).
# Reimplemented here in plain bash (source: oh-my-zsh lib/git.zsh and
# plugins/git/git.plugin.zsh) since there's no oh-my-zsh on Omarchy/bash.
git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2>/dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return
  fi
  echo "${ref#refs/heads/}"
}

git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify "refs/heads/$branch"; then
      echo "$branch"
      return 0
    fi
  done
  echo develop
  return 1
}

git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local remote ref
  for ref in refs/heads/{main,trunk,mainline,default,stable,master} \
             refs/remotes/origin/{main,trunk,mainline,default,stable,master} \
             refs/remotes/upstream/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return 0
    fi
  done
  for remote in origin upstream; do
    ref=$(command git rev-parse --abbrev-ref "$remote/HEAD" 2>/dev/null)
    if [[ $ref == "$remote"/* ]]; then
      echo "${ref#"$remote"/}"
      return 0
    fi
  done
  echo master
  return 1
}

_git_log_prettily() {
  [[ -z "$1" ]] || git log --pretty="$1"
}

ggu() {
  local b
  [[ $# != 1 ]] && b="$(git_current_branch)"
  git pull --rebase origin "${b:-$1}"
}

# add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'

# am
alias gam='git am'
alias gama='git am --abort'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gamscp='git am --show-current-patch'

# apply
alias gap='git apply'
alias gapt='git apply --3way'

# branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbg='LANG=C git branch -vv | grep ": gone\]"'
alias gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -d'
alias gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -D'

# bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsn='git bisect new'
alias gbso='git bisect old'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# blame / config
alias gbl='git blame -w'
alias gcf='git config --list'

# commit
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcam='git commit --all --message'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcann!='git commit --verbose --all --date=now --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcb='git checkout -b'
alias gcB='git checkout -B'
alias gcfu='git commit --fixup'
alias gcmsg='git commit --message'
alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gcs='git commit --gpg-sign'
alias gcsm='git commit --signoff --message'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'

# checkout
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcd='git checkout $(git_develop_branch)'
alias gcm='git checkout $(git_main_branch)'

# cherry-pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# clean / clone
alias gclean='git clean --interactive -d'
alias gcl='git clone --recurse-submodules'
alias gclf='git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules'

# diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'

# fetch
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gfo='git fetch origin'
alias gfg='git ls-files | grep'

# gui
alias gg='git gui citool'
alias gga='git gui citool --amend'

# pull / push
alias g=git
alias gl='git pull'
alias ggpull='git pull origin "$(git_current_branch)"'
alias gluc='git pull upstream $(git_current_branch)'
alias glum='git pull upstream $(git_main_branch)'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias ggpush='git push origin "$(git_current_branch)"'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'
alias gprv='git pull --rebase -v'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gprom='git pull --rebase origin $(git_main_branch)'
alias gpromi='git pull --rebase=interactive origin $(git_main_branch)'
alias gprum='git pull --rebase upstream $(git_main_branch)'
alias gprumi='git pull --rebase=interactive upstream $(git_main_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes'
alias gpu='git push upstream'
alias gpv='git push --verbose'
alias ggpur=ggu

# help / gitk
alias ghh='git help'
gk() { command gitk --all --branches "$@" &>/dev/null & disown; }
gke() { command gitk --all $(git log --walk-reflogs --pretty=%h) &>/dev/null & disown; }

# ignore
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

# log
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat --patch'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glp=_git_log_prettily
alias gcount='git shortlog --summary --numbered'

# merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmff='git merge --ff-only'
alias gms='git merge --squash'
alias gmom='git merge origin/$(git_main_branch)'
alias gmum='git merge upstream/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'

# rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase --interactive'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbs='git rebase --skip'
alias grbum='git rebase upstream/$(git_main_branch)'

# remote
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote --verbose'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grf='git reflog'

# reset / restore / revert
alias grh='git reset'
alias grhh='git reset --hard'
alias grhk='git reset --keep'
alias grhs='git reset --soft'
alias gru='git reset --'
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

# rm / root
alias grm='git rm'
alias grmc='git rm --cached'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# show / status
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'
alias gst='git status'
alias gsb='git status --short --branch'
alias gss='git status --short'

# stash
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --patch'
alias gstu='gsta --include-untracked'

# submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# svn
alias gsd='git svn dcommit'
alias gsr='git svn rebase'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

# switch
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'

# tag
alias gta='git tag --annotate'
gtl() { git tag --sort=-v:refname -n --list "${1}*"; }
alias gts='git tag --sign'
alias gtv='git tag | sort -V'

# worktree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# wip / misc
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gwipe='git reset --hard && git clean --force -df'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gwch='git log --patch --abbrev-commit --pretty=medium --raw'

### ble.sh: bash equivalent of zsh-autosuggestions + zsh-syntax-highlighting ###
# https://github.com/akinomyoga/ble.sh — must be sourced last in .bashrc.
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh
