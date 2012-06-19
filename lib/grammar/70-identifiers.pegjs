/* === Identifiers === */

TABLE_NAME "table name"
  = schema:QUOTED_ID '.' name:QUOTED_ID {
      return { schema: schema, table: name };
    }
  / name:QUOTED_ID { return { table: name }; }


/* === QUOTED ID === */

QUOTED_ID "Identifier"
  = start:[A-Za-z$_] rest:[0-9A-Za-z$_]* { return start + rest.join(''); }
  / '`' name:([^`]/double_backtick_escape)+ '`' { return name.join(''); }

