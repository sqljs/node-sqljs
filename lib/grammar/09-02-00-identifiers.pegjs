
// 9.2. Schema Object Names
// http://dev.mysql.com/doc/refman/5.6/en/identifiers.html


TABLE_NAME "table name"
  = schema:ID '.' name:ID {
      return { schema: schema, table: name };
    }
  / name:ID { return { table: name }; }


ID "Identifier"
  = start:[A-Za-z$_] rest:[0-9A-Za-z$_]* { return start + rest.join(''); }
  / '`' name:([^`]/double_backtick_escape)+ '`' { return name.join(''); }


double_backtick_escape
  = "``" { return "`"; }

