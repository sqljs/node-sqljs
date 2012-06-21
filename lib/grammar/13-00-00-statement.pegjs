
// Chapter 13. SQL Statement Syntax
// http://dev.mysql.com/doc/refman/5.6/en/sql-syntax.html */


STATEMENTS
  = _ statement:STATEMENT _ ';' statements:STATEMENTS {
      if(statement) statements.unshift(statement); return statements;
    }
  / _ statement:STATEMENT _ { return [statement]; }
  / _ { return []; }


STATEMENT
  = DATA_DEFINITION_STATEMENT
  / DATA_MANIPULATION_STATEMENT

