# ~/.config/blesh/init.sh — auto-loaded by ble.sh (sourced from bash/.bashrc).
#
# Goal: make ble.sh's completion + highlighting feel like the zsh setup this
# machine's shell was converted from — zsh-autosuggestions,
# zsh-syntax-highlighting, and `zstyle ':completion:*' menu select`.
#
# ble.sh's *behaviour* is already close: auto-complete "ghost text" is on and
# near-instant (complete_auto_delay=1), the completion menu is inline and
# filter-as-you-type, and the suggestion accept keys already match
# zsh-autosuggestions (End / Right / C-e = whole line, M-f / C-Right = word).
#
# Two things are changed below the palette:
#   - TAB shows the menu without selecting/inserting anything; you step into it
#     with a second TAB (zsh `menu select` without MENU_COMPLETE)
#   - the command line keeps its normal colours while the menu is open — no
#     insert-region or filter highlight painted onto the prompt
#
# The rest is a palette remap: ble.sh's defaults use a red/blue/pink scheme
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
bleopt complete_menu_complete=1                  # needed to walk the menu with TAB
ble-face -s menu_complete_selected   'fg=black,bg=blue'   # selected row in the menu

# Omarchy's inputrc sets `menu-complete-display-prefix on`, which makes ble.sh
# print each candidate's full path in the menu. Turn it back off so the menu
# lists only the component being completed: `src/lib/<TAB>` shows `parser.c`,
# not `src/lib/parser.c`.
bind 'set menu-complete-display-prefix off'

# TAB: 1st press shows the menu with nothing selected and nothing inserted;
# 2nd press steps into the menu and selects the first entry; further presses
# cycle. (ble.sh's default inserts the first entry on the press that opens the
# menu — this splits that into two steps, like zsh's `menu select`.)
function ble/widget/tab-complete-menu {
  if [[ $_ble_complete_menu_active ]]; then
    ble/widget/menu-complete
  else
    ble/widget/complete show_menu
  fi
}
ble-bind -f 'C-i' 'tab-complete-menu'
ble-bind -f 'TAB' 'tab-complete-menu'

# Keep the command line looking exactly as it does with no menu open: don't
# paint the inserted entry or the filter text with a highlight.
ble-face -s region_insert     none   # the entry inserted while walking the menu
ble-face -s menu_filter_fixed  none   # the already-matched prefix on the prompt
ble-face -s menu_filter_input  none   # extra characters typed to narrow the menu

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
