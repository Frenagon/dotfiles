# ~/.config/blesh/init.sh — auto-loaded by ble.sh (sourced from bash/.bashrc).
#
# Goal: make ble.sh's completion + highlighting feel like the zsh setup this
# machine's shell was converted from — zsh-autosuggestions,
# zsh-syntax-highlighting, and `zstyle ':completion:*' menu select`.
#
# ble.sh's *behaviour* already matches zsh out of the box, so nothing to do
# there:
#   - auto-complete "ghost text" is on and near-instant (complete_auto_delay=1)
#   - TAB shows an inline, filter-as-you-type menu and cycles through it with
#     the current entry highlighted (complete_menu_complete=1,
#     complete_menu_filter=1, menu_complete_selected=reverse)
#   - suggestion accept keys already match zsh-autosuggestions: End / Right /
#     C-e take the whole line, M-f / C-Right take one word
#
# What's left is a palette remap: ble.sh's defaults use a red/blue/pink scheme
# that reads very differently from zsh-syntax-highlighting's green/yellow one,
# and the autosuggestion is drawn as a grey box rather than dim ghost text.
#
# Colours are given as palette names / indices (0-15, 'green', 'red', …) rather
# than fixed 256-colour values so they follow the terminal theme — same
# approach as tmux/.tmux.conf.

## ── Autosuggestions (zsh-autosuggestions) ─────────────────────────────────
# Default is bg=254,fg=238 — a light-grey box. zsh shows dim ghost text with
# no background; fg=8 is bright-black, zsh-autosuggestions' own default.
ble-face -s auto_complete            'fg=8'

## ── Completion menu (zsh menu-select) ─────────────────────────────────────
bleopt complete_menu_maxlines=20                 # cap height; default is uncapped
ble-face -s menu_complete_selected   'fg=black,bg=blue'   # like complist's ma=
ble-face -s menu_filter_input        'fg=black,bg=blue'   # the typed filter

## ── Syntax highlighting (zsh-syntax-highlighting palette) ─────────────────
# Command words: all green — builtin / function / alias / external / `.`.
ble-face -s command_builtin          'fg=green'
ble-face -s command_builtin_dot      'fg=green,bold'
ble-face -s command_function         'fg=green'
ble-face -s command_alias            'fg=green'
ble-face -s command_file             'fg=green'
ble-face -s command_directory        'fg=green,underline'
ble-face -s command_keyword          'fg=yellow'          # reserved words: if / for / …
ble-face -s command_jobs             'fg=red,bold'

# Unknown command / parse error: red text, not a red background block.
ble-face -s syntax_error             'fg=red,bold'

# Strings: yellow, matching zsh's *-quoted-argument.
ble-face -s syntax_quoted            'fg=yellow'
ble-face -s syntax_quotation         'fg=yellow,bold'     # the quote marks
ble-face -s syntax_escape            'fg=cyan'

# Globs and parameter/history expansion.
ble-face -s syntax_glob              'fg=blue,bold'
ble-face -s syntax_param_expansion   'fg=magenta'
ble-face -s syntax_history_expansion 'fg=magenta,bold'

# Comments: dim grey.
ble-face -s syntax_comment           'fg=8'

# Options (-x, --long): cyan, like zsh-syntax-highlighting's newer default.
ble-face -s argument_option          'fg=cyan'
