
STATEMENTS
  = _ statement:STATEMENT _ ';' statements:STATEMENTS {
      if(statement) statements.unshift(statement); return statements;
    }
  / _ statement:STATEMENT _ { return [statement]; }
  / _ { return []; }


STATEMENT
  = ddl:DDL { return ddl; }

DDL
  = create_table_statement:CREATE_TABLE_STATEMENT {
      return create_table_statement;
    }

CREATE_TABLE_STATEMENT "CREATE TABLE statement"
  = ("CREATE"i __)? "TABLE"i __ table:TABLE_NAME _ '(' columns:COLUMN_DEFINITIONS ')' { 
      return {
        statement: "CREATE TABLE",
        schema: table.schema,
        table: table.table,
        columns: columns
      }; 
    }


COLUMN_DEFINITIONS "Column definitions"
  = _ col:COLUMN_DEFINITION _ ',' cols:COLUMN_DEFINITIONS { cols.unshift(col); return cols; }
  / _ col:COLUMN_DEFINITION _ { return [col]; }
  / _ { return []; }


COLUMN_DEFINITION "Column definition"
  = name:QUOTED_ID props:COLUMN_TYPE_PROPERTIES { props.name = name; return props; }


COLUMN_TYPE_PROPERTIES "Column type properties"
  = __ prefix:("TINY"i/"SMALL"i/"MEDIUM"i/"BIG"i)? _ "INT"i "EGER"i? props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
      return props;
    }
  / __ "NUM"i ("ERIC"i/"BER"i)? (_ "(" _ ) props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'NUMERIC';
      return props;
    }
  / __ "NOT"i _ "NULL"i props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=true;
      return props; 
    }
  / __ "NULL"i props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=false;
      return props;
    }
  / __ "DEFAULT"i __ CURRENT_TIMESTAMP props:COLUMN_TYPE_PROPERTIES {
      props.default = Date.now;
      return props;
    }
  / _ { return {}; }


/* === INT literal === */

PositiveInt
  = "0" octal:[0-7]+ { return parseInt('0'+octal.join(''), 8); }
  / "0x"i hex:[0-9A-Fa-f]+ { return parseInt(hex.join(''), 16); }
  / "0b"i bin:[01]+ { return parseInt(bin.join(''), 2); }
  / decimal:[0-9]+ { return parseInt(decimal.join(''), 10); }

/* === CURRENT_TIMESTAMP === */
CURRENT_TIMESTAMP
  = "CURRENT_TIMESTAMP"i
  / "CURRENT"i _ "TIMESTAMP"i
  / "NOW()"i
  / "NOW()"i


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
