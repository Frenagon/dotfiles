# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package**. Inside a package, the file
structure mirrors your home directory. Stow symlinks the contents into `~`.

```
~/.dotfiles/
├── bash/
│   └── .bashrc                  -> ~/.bashrc
├── blesh/
│   └── .config/
│       └── blesh/
│           └── init.sh          -> ~/.config/blesh/init.sh
├── starship/
│   └── .config/
│       └── starship.toml        -> ~/.config/starship.toml
├── tmux/
│   └── .config/
│       └── tmux/
│           └── tmux.conf        -> ~/.config/tmux/tmux.conf
├── bat/
│   └── .config/
│       └── bat/
│           └── config           -> ~/.config/bat/config
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
│           ├── autostart.lua, variables.lua, looknfeel.lua
│           ├── hyprsunset.conf, xdph.conf, .luarc.json
│           └── programs/obsidian.lua
├── scripts/
│   └── .local/
│       └── scripts/
│           └── run_if_closed    -> ~/.local/scripts/run_if_closed
├── foot/
│   └── .config/
│       └── foot/
│           └── foot.ini         -> ~/.config/foot/foot.ini
└── omarchy/
    └── .config/
        └── omarchy/
            └── themes/          -> ~/.config/omarchy/themes
                ├── plastik-genesis/colors.toml
                ├── plastik-retro/colors.toml
                └── plastik-odyssey/colors.toml
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
| `tmux` | `tmux` | yes | 3.x, for the XDG config path |
| `tmux` | [TPM](https://github.com/tmux-plugins/tpm) | yes | plugin manager — clone to `~/.config/tmux/plugins/tpm`; see the note at the top of `tmux/.config/tmux/tmux.conf` |
| `bat` | `bat` | yes | the tool itself |
| `bash` | `starship` | optional | prompt (Omarchy's `default/bash/init` runs `starship init`) |
| `starship` | `starship` | yes | the prompt config is inert without it |
| `starship` | a Nerd Font | yes | the git-branch glyph (Omarchy's default font has one) |
| `bash` | `zoxide` | optional | smarter `cd` |
| `bash` | `direnv` | optional | per-directory env loading |
| `bash` | `lazygit` | optional | used by the `lg` function |
| `bash` | `eza` | optional | powers the `l`/`ls`/`la`/`ll`/`lla`/`lt` aliases |
| `bash` | `nvim` | optional | powers the `vi`/`vim` aliases |
| `bash` | `claude` (Claude Code CLI) | optional | powers the `ai` alias |
| `bash` | [ble.sh](https://github.com/akinomyoga/ble.sh) | optional | autosuggestions + syntax highlighting; tuned by the `blesh` package |
| `blesh` | [ble.sh](https://github.com/akinomyoga/ble.sh) | yes | `init.sh` is a no-op without it |
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
| `foot` | `foot` | yes | the terminal itself |
| `hypr` | [`ytmdesktop`](https://aur.archlinux.org/packages/ytmdesktop) (AUR) | yes | installs as `youtube-music-desktop-app`; autostarted on workspace 5 and bound to `SUPER+5` |
| `hypr` | `godot` | yes | bound to `SUPER+6`, workspace 6 |

Everything else nvim needs (LSP servers, remaining formatters) is self-installed by
mason.nvim on first launch — see `lua/plugins/mason.lua`. Theming follows Omarchy's
system theme automatically when present (`lua/plugins/theme.lua`); it falls back to a
bundled catppuccin colorscheme when it isn't (e.g. on a non-Omarchy machine).

**hypr note:** targets Omarchy's "Quattro" (v4.0.0+) Hyprland setup, where
`~/.config/hypr/{hyprland,bindings,monitors,input,looknfeel,autostart}.lua`
are Omarchy's own blessed user-override files — loaded *after* Omarchy's real
defaults, so this package only adds personal config (monitor layout, keyboard
layout, app autostart, window-placement rules, one workspace-launch keybind
pattern) on top. It deliberately does not touch or reimplement anything
Omarchy's own shell already provides (volume/brightness/screenshot/
clipboard/launcher/powermenu/lock/kb-layout/bluetooth). `looknfeel.lua`,
`hyprsunset.conf`, `xdph.conf`, and `.luarc.json` are tracked as Omarchy
ships them (all-comment stub / stock defaults) so `stow hypr` covers the
whole directory — customize `looknfeel.lua` in place when wanted. Since these
four are stock, this package now shadows Omarchy's copies of them, so an
Omarchy update to those specific templates won't reach this machine until
re-synced by hand. Smoke-tested on this machine with `hyprctl reload` —
`hyprctl configerrors` came back clean and `hyprctl monitors`/`binds`
reflected the new config.

**omarchy note:** three custom Omarchy themes ("Plastik" family) ported from
this machine's caelestia "crimson" color scheme
(`~/.nixos-config/home/window-managers/caelestia/schemes/crimson/`) —
`plastik-genesis` (dark, from `crimson/dark.txt`), `plastik-odyssey` (light,
from `crimson/light.txt`), and `plastik-retro` (a mid warm-gray variant not
in the source scheme, built around the same four accent hues). Each carries a
`colors.toml` (Omarchy's templates generate every themed app config —
terminal, Hyprland borders, btop, etc. — from it; see
[docs/theming.md](https://github.com/omacom/omarchy/blob/quattro/docs/theming.md)),
a `backgrounds/` wallpaper, and a small `hyprland.lua` that rounds the window
corners (`rounding = 6, rounding_power = 3`, matching Omarchy's Solitude
theme — the stock default is square). Shipping that `hyprland.lua` makes
theme-set skip the generated one, so it re-sets the accent border colours
too. Activate with `omarchy-theme-set plastik-genesis` (or `-retro`/`-odyssey`)
after stowing. Untested against a real Omarchy install.

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
