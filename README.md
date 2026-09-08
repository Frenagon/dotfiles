# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package**. Inside a package, the file
structure mirrors your home directory. Stow symlinks the contents into `~`.

```
~/.dotfiles/
├── zsh/
│   └── .zshrc            -> ~/.zshrc
├── git/
│   └── .gitconfig        -> ~/.gitconfig
└── nvim/
    └── .config/
        └── nvim/
            └── init.lua  -> ~/.config/nvim/init.lua
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

## Adding a new config

1. Create a package dir mirroring the path relative to `~`.
   e.g. for `~/.config/foo/config`, make `foo/.config/foo/config`.
2. Move your real file into it.
3. `stow foo`
