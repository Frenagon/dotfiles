# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package**. Inside a package, the file
structure mirrors your home directory. Stow symlinks the contents into `~`.

```
~/.dotfiles/
├── bash/
│   └── .bashrc                  -> ~/.bashrc
├── git/
│   └── .config/
│       └── git/
│           └── config           -> ~/.config/git/config
├── ssh/
│   └── .ssh/
│       └── config               -> ~/.ssh/config
├── nvim/
│   └── .config/
│       └── nvim/                -> ~/.config/nvim
│           ├── init.lua
│           ├── lazy-lock.json
│           ├── after/queries/...
│           └── lua/
│               ├── config/...
│               └── plugins/...
├── hypr/
│   └── .config/
│       └── hypr/                -> ~/.config/hypr
│           ├── hyprland.lua
│           ├── monitors.lua, input.lua, bindings.lua, rules.lua
│           ├── autostart.lua, variables.lua
│           └── programs/obsidian.lua
└── scripts/
    └── .local/
        └── scripts/
            └── run_if_closed    -> ~/.local/scripts/run_if_closed
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
| `nvim` | `nvim` | yes | the editor itself |
| `nvim` | `git` | yes | lazy.nvim and mason.nvim both shell out to it |
| `nvim` | a C compiler / `make` | yes | `:TSUpdate` treesitter parser builds, telescope-fzf-native's native build |
| `nvim` | `cargo`/`rustc` | yes | blink.cmp's `cargo build --release` |
| `nvim` | Node.js/npm | yes | most mason-installed LSP servers are npm packages |
| `nvim` | Python3 + pip | yes | the `black` formatter, installed by mason |
| `nvim` | `curl`/`wget`, `unzip`, `tar`, `gzip` | yes | mason's own download prerequisites (present on a base Arch/Omarchy install) |
| `scripts` | `jq` | yes | used by `run_if_closed` to query `hyprctl clients -j` |

Everything else nvim needs (LSP servers, remaining formatters) is self-installed by
mason.nvim on first launch — see `lua/plugins/mason.lua`. Theming follows Omarchy's
system theme automatically when present (`lua/plugins/theme.lua`); it falls back to a
bundled catppuccin colorscheme when it isn't (e.g. on a non-Omarchy machine).

**hypr note:** targets Omarchy's "Quattro" (v4.0.0+) Hyprland setup, where
`~/.config/hypr/{hyprland,bindings,monitors,input,looknfeel,autostart}.lua`
are Omarchy's own blessed user-override files — loaded *after* Omarchy's real
defaults, so this package only adds personal config (monitor layout, input
devices, app autostart, window-placement rules, one workspace-launch keybind
pattern) on top. It deliberately does not touch or reimplement anything
Omarchy's own shell already provides (volume/brightness/screenshot/
clipboard/launcher/powermenu/lock/kb-layout/bluetooth), and ships no
`looknfeel.lua`, leaving Omarchy's default look-and-feel untouched. Untested
against a real Omarchy install — smoke test with `hyprctl reload` and watch
for Lua errors after stowing.

**ssh note:** this repo only tracks `~/.ssh/config` — never the private keys
themselves. After stowing, `ssh` will refuse to use `~/.ssh` or its keys if
permissions are too open; on a fresh machine run:

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519   # or whichever key(s) you generate/copy over
```

## Adding a new config

1. Create a package dir mirroring the path relative to `~`.
   e.g. for `~/.config/foo/config`, make `foo/.config/foo/config`.
2. Move your real file into it.
3. `stow foo`
