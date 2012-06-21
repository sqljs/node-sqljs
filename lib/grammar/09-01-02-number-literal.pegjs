
// 9.1.2. Number Literals
// http://dev.mysql.com/doc/refman/5.6/en/number-literals.html


SIGNED_NUMBER "number"
  = _ sign:NUMBER_SIGN _ val:POSITIVE_NUMBER _ { return val*sign; }


NUMBER_SIGN
  = "-" { return -1; }
  / "+"? { return 1; }


POSITIVE_NUMBER "number"
  = FLOAT
  / POSITIVE_INTEGER


FLOAT
  = decimal:[0-9]* "." frac:[0-9]* "e"i 


DecimalLiteral
  = [0]+ { return "0"; }
  / first:[1-9] decimal:[0-9]* { return first+decimal.join(''); }


POSITIVE_INTEGER "PositiveInteger"
  = & { return options.ALLOW_OCTAL_NOTATION || options.OCTAL_AS_DECIMAL; } 
    "0" octal:[0-7]+ { return parseInt('0'+octal.join(''), options.OCTAL_AS_DECIMAL ? 10 : 8); }
  / "0x"i hex:[0-9A-Fa-f]+ { return parseInt(hex.join(''), 16); }
  / "0b"i bin:[01]+ { return parseInt(bin.join(''), 2); }
  / dec:DecimalLiteral { return parseInt(dec, 10); }
