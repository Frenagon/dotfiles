; extends

; See after/queries/javascript/highlights.scm — split declaration keywords out
; of the generic @keyword bucket so they render as declarations.
[
  "const"
  "let"
  "var"
] @keyword.modifier
