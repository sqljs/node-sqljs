
/* === STATEMENTS === */

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

