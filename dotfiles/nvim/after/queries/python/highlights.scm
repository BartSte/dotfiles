; extends

; ("->" @operator (set! conceal "→"))
("->" @operator (set! conceal ""))
("==" @operator (set! conceal "≡"))
("!=" @operator (set! conceal "≠"))
("<=" @operator (set! conceal "≤"))
(">=" @operator (set! conceal "≥"))
("lambda" @keyword.lambda (set! conceal "λ"))

; ((type (identifier) @type) (#eq? @type "float") (set! conceal "ℝ"))
