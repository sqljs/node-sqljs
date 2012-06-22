/* === Comments and whitespaces === */

comment 
  = singleLineComment
  / multiLineComment

singleLineComment
  = "--" (!eolChar .)*
  / "#" (!eolChar .)*
  / "//" (!eolChar .)*

multiLineComment
  = "/*" (!"*/" .)* "*/"

_ "whitespace"
  = (whitespace / eol / comment)*

__ "whitespace"
  = (whitespace / eol / comment)+

eol 
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

eolChar
  = [\n\r\u2028\u2029]

whitespace "whitespace"
  = [ \t\v\f\r\n\u00A0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]
