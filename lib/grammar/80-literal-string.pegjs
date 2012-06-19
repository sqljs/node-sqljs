/* === STRING === */

STRING "string"
  = '"' '"' _              { return "";    }
  / "'" "'" _              { return "";    }
  / '"' chars:chars_no_quot '"' _ { return chars; }
  / "'" chars:chars_no_apos "'" _ { return chars; }

