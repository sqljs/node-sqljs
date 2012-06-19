
/* === INT literal === */

PositiveInt
  = "0" octal:[0-7]+ { return parseInt('0'+octal.join(''), 8); }
  / "0x"i hex:[0-9A-Fa-f]+ { return parseInt(hex.join(''), 16); }
  / "0b"i bin:[01]+ { return parseInt(bin.join(''), 2); }
  / first:[1-9] decimal:[0-9]* { return parseInt(first+decimal.join(''), 10); }
  / "0"+ { return 0; }
