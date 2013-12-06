
// 9.2. Schema Object Names
// http://dev.mysql.com/doc/refman/5.6/en/identifiers.html


ID_OR_STR "ID or STR"
  = ID
  / STRING


DATABASE_NAME "database name"
  = schema:ID { return schema }


TABLE_NAME "table name"
  = schema:ID_OR_STR '.' name:ID_OR_STR {
      return { schema: schema, table: name };
    }
  / name:ID_OR_STR { return { table: name }; }


COLUMN_NAME "column name"
  = schema:ID_OR_STR '.' table:ID_OR_STR '.' column:ID_OR_STR {
      return { schema: schema, table: table, column: column };
    }
  / table:ID_OR_STR '.' column:ID_OR_STR {
      return { table: table, column: column };
    }
  / column:ID_OR_STR {
      return { column: column };
    }


ID "identifier"
  = start:[A-Za-z$_] rest:[0-9A-Za-z$_]* { return start + rest.join(''); }
  / '`' name:([^`]/double_backtick_escape)+ '`' { return name.join(''); }


double_backtick_escape
  = "``" { return "`"; }

