
STATEMENTS
  = _ statement:STATEMENT ';' statements:STATEMENTS {
      if(statement) statements.unshift(statement); return statements;
    }
  / _ statement:STATEMENT { return [statement]; }
  / _ { return []; }


STATEMENT
  = ddl:DDL { return ddl; }

DDL
  = create_table_statement:CREATE_TABLE_STATEMENT {
      return create_table_statement;
    }

CREATE_TABLE_STATEMENT "CREATE TABLE statement"
  = ("CREATE"i __)? "TABLE"i __ table:TABLE_NAME _ '(' columns:COLUMN_DEFINITIONS ')' _ { 
      return {
        statement: "CREATE TABLE",
        schema: table.schema,
        table: table.table,
        columns: columns
      }; 
    }


COLUMN_DEFINITIONS
  = _ col:COLUMN_DEFINITION ',' cols:COLUMN_DEFINITIONS { cols.unshift(col); return cols; }
  / _ col:COLUMN_DEFINITION { return [col]; }
  / _ { return []; }


COLUMN_DEFINITION
  = name:QUOTED_ID __ type:COLUMN_TYPE { return { name:name, type:type }; }
  / name:QUOTED_ID { return { name:name }; }


COLUMN_TYPE
  = type:TYPE { return type; }


TYPE
  = "INT"i "EGER"i? { return { name: "INT" }; }


/* === TABLE NAME === */

TABLE_NAME "table name"
  = schema:QUOTED_ID '.' name:QUOTED_ID {
      return { schema: schema, table: name };
    }
  / name:QUOTED_ID { return { table: name }; }

/* === QUOTED ID === */

QUOTED_ID "Identifier"
  = start:[A-Za-z_] rest:[A-Za-z0-9_]* { return start + rest.join(''); }
  / '`' name:[^`]+ '`' { return name.join(''); }

/* === STRING === */

STRING "string"
  = '"' '"' _              { return "";    }
  / "'" "'" _              { return "";    }
  / '"' chars:chars1 '"' _ { return chars; }
  / "'" chars:chars2 "'" _ { return chars; }

chars1
  = chars:char1+ { return chars.join(""); }

char1
  // In the original JSON grammar: "any-Unicode-character-except-"-or-\-or-control-character"
  = [^"\\\0-\x1F\x7f]
  / "\\'"  { return "'";  }
  / '\\"'  { return '"';  }
  / "\\\\" { return "\\"; }
  / "\\/"  { return "/";  }
  / "\\b"  { return "\b"; }
  / "\\f"  { return "\f"; }
  / "\\n"  { return "\n"; }
  / "\\r"  { return "\r"; }
  / "\\t"  { return "\t"; }
  / "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
    }

chars2
  = chars:char2+ { return chars.join(""); }

char2
  // In the original JSON grammar: "any-Unicode-character-except-"-or-\-or-control-character"
  = [^'\\\0-\x1F\x7f]
  / "\\'"  { return "'";  }
  / '\\"'  { return '"';  }
  / "\\\\" { return "\\"; }
  / "\\/"  { return "/";  }
  / "\\b"  { return "\b"; }
  / "\\f"  { return "\f"; }
  / "\\n"  { return "\n"; }
  / "\\r"  { return "\r"; }
  / "\\t"  { return "\t"; }
  / "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
    }

hexDigit
  = [0-9a-fA-F]

/* === Comments and whitespaces === */

comment "comment"
  = singleLineComment
  / multiLineComment

singleLineComment
  = "--" (!eolChar .)*
  / "#" (!eolChar .)*
  / "//" (!eolChar .)*

multiLineComment
  = "/*" (!"*/" .)* "*/"

_ = (whitespace / eol / comment)*

__ = (whitespace / eol / comment)+

eol "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

eolChar
  = [\n\r\u2028\u2029]

whitespace "whitespace"
  = [ \t\v\f\r\n\u00A0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]
