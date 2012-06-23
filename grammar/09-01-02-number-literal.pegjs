
// 9.1.2. Number Literals
// http://dev.mysql.com/doc/refman/5.6/en/number-literals.html


SIGNED_NUMBER "number"
  = sign:NUMBER_SIGN val:POSITIVE_NUMBER { return val*sign; }


NUMBER_SIGN
  = "-" _ { return -1; }
  / "+"? _ { return 1; }


POSITIVE_NUMBER "number"
  = POSITIVE_FLOAT
  / POSITIVE_INTEGER


POSITIVE_FLOAT "float"
  = val:FloatLiteral _ { return parseFloat(val); }


POSITIVE_INTEGER "integer"
  = & { return options.ALLOW_OCTAL_NOTATION || options.OCTAL_AS_DECIMAL; } 
    "0" octal:[0-7]+ _ { return parseInt('0'+octal.join(''), options.OCTAL_AS_DECIMAL ? 10 : 8); }
  / "0x"i hex:[0-9A-Fa-f]+ _ { return parseInt(hex.join(''), 16); }
  / "0b"i bin:[01]+ _ { return parseInt(bin.join(''), 2); }
  / dec:DecimalLiteral _ { return parseInt(dec, 10); }


FloatLiteral
  = base:[0-9]+ 
      frac:([\.] frac:[0-9]* {return '.'+ frac.join('')})?
      exp:([eE] sign:[+-]? exp:[0-9]+ { return 'e' + sign + exp.join(''); })
    {
      return base.join('') + frac + exp; 
    }
  / base:[0-9]+
      [\.] frac:(frac:[0-9]* {return frac.join('')})?
      exp:([eE] sign:[+-]? exp:[0-9]+ { return 'e' + sign + exp.join(''); })?
    {
      return base.join('') + '.' + frac + exp; 
    }
  / [\.] frac:[0-9]+ 
      exp:([eE] sign:[+-]? exp:[0-9]+ { return 'e' + sign + exp.join(''); })? 
    {
      return '0.' + frac.join('') + exp; 
    }


DecimalLiteral
  = first:[1-9] decimal:[0-9]* { return first+decimal.join(''); }
  / [0]+ { return "0"; }

