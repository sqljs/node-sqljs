
// 9.1.1. String Literals
// http://dev.mysql.com/doc/refman/5.6/en/string-literals.html


STRING "string"
  = str:SINGLE_STRING+ { return str.join(''); }


SINGLE_STRING "string"
  = '"' chars:chars_no_quot '"' _ { return chars; }
  / "'" chars:chars_no_apos "'" _ { return chars; }


chars_no_quot
  = chars:char_no_quot* { return chars.join(""); }

chars_no_apos
  = chars:char_no_apos* { return chars.join(""); }

char_no_quot
  = char_escape_sequence
  / '""' { return '"'; }
  / [^"]          // originally [^"\\\0-\x1F\x7f]

char_no_apos
  = char_escape_sequence
  / "''" { return "'"; }
  / [^']


char_escape_sequence
  = "\\\\"  { return "\\"; }
  / "\\'"   { return "'";  }
  / '\\"'   { return '"';  }
  / "\\0"   { return "\x00"; }
  / "\\/"   { return "/";  }
  / "\\b"  { return "\b"; }
  / "\\n"  { return "\n"; }
  / "\\f"  { return "\f"; }
  / "\\r"  { return "\r"; }
  / "\\t"  { return "\t"; }
  / "\\Z"  { return "\x1a"; }
  / & { return options.STRING_HEX_ESCAPE }
    "\\x" h1:hexDigit h2:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2));
    }
  / & { return options.STRING_UNICODE_ESCAPE }
    "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
    }
  / "\\" char:. {
      if(options.STRING_STRICT_ESCAPE)
        throw new SyntaxError("Unknown escape sequence: '\\"+char+"'");

      if(options.STRING_INVALID_ESCAPE_STRIP_BACKSLASH)
        return char;

      return '\\'+char;
    }


hexDigit
  = [0-9a-fA-F]

