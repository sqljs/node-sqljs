
// Chapter 13. SQL Statement Syntax
// http://dev.mysql.com/doc/refman/5.6/en/sql-syntax.html */


STATEMENTS
  = _ first:STATEMENT _ statements:((';' _)+ stmt:STATEMENT { return stmt; })* _ (';' _)* {
      statements.unshift(first); return statements;
    }
  / _ { return []; }


STATEMENT
  = DATA_DEFINITION_STATEMENT
  / DATA_MANIPULATION_STATEMENT
  / USE_STATEMENT
