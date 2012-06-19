/* === Identifiers === */

TABLE_NAME "table name"
  = schema:QUOTED_ID '.' name:QUOTED_ID {
      return { schema: schema, table: name };
    }
  / name:QUOTED_ID { return { table: name }; }


/* === QUOTED ID === */

QUOTED_ID "Identifier"
  = start:[A-Za-z_] rest:[A-Za-z0-9_]* { return start + rest.join(''); }
  / '`' name:[^`]+ '`' { return name.join(''); }

