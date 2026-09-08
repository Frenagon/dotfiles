; extends

; The ecma grammar lumps `const`/`let`/`var` into the generic @keyword bucket
; (alongside `break`, `with`, `debugger`, ...). Re-tag just the declaration
; keywords so the colorscheme can render them as declarations while every other
; reserved word stays @keyword. `function` is already @keyword.function and
; `class` is @keyword.type.
[
  "const"
  "let"
  "var"
] @keyword.modifier
