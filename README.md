# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package**. Inside a package, the file
structure mirrors your home directory. Stow symlinks the contents into `~`.

```
~/.dotfiles/
├── bash/
│   └── .bashrc                  -> ~/.bashrc
└── git/
    └── .config/
        └── git/
            └── config           -> ~/.config/git/config
```

## Usage

Run from inside this directory (`~/.dotfiles`), with `~` as the target:

```sh
# Symlink a package into ~
stow zsh

# Symlink everything
stow */

# Remove a package's symlinks
stow -D zsh

# Re-stow after adding/removing files
stow -R zsh
```

`stow` uses the parent of the current directory as the target by default, so
keeping this repo at `~/.dotfiles` makes `~` the target automatically. To be
explicit:

```sh
stow --target="$HOME" zsh
```

## Dependencies

These configs assume certain tools are installed on the target machine. Most
are guarded (`command -v`) so a missing tool just disables that feature
rather than breaking the shell, but a few (git's `delta`/`nvim`) will error
loudly until installed.

| Package | Tool | Required? | Purpose |
| --- | --- | --- | --- |
| `bash` | `bash` | yes | the shell itself |
| `bash` | `tmux` | optional | auto-attached on interactive shell start |
| `bash` | `starship` | optional | prompt |
| `bash` | `zoxide` | optional | smarter `cd` |
| `bash` | `direnv` | optional | per-directory env loading |
| `bash` | `lazygit` | optional | used by the `lg` function |
| `bash` | `eza` | optional | powers the `ls`/`la`/`ll`/`lla`/`lt` aliases |
| `bash` | `nvim` | optional | powers the `vi`/`vim` aliases |
| `bash` | `claude` (Claude Code CLI) | optional | powers the `ai` alias |
| `bash` | [ble.sh](https://github.com/akinomyoga/ble.sh) | optional | autosuggestions + syntax highlighting |
| `git` | `nvim` | yes | `core.editor`, `diff.tool`, `merge.tool` |
| `git` | [`delta`](https://github.com/dandavison/delta) | yes | `pager.*` and `interactive.diffFilter` |

## Adding a new config

1. Create a package dir mirroring the path relative to `~`.
   e.g. for `~/.config/foo/config`, make `foo/.config/foo/config`.
2. Move your real file into it.
3. `stow foo`
