
// 13.1. Data Definition Statements
// http://dev.mysql.com/doc/refman/5.7/en/sql-syntax-data-definition.html

DATA_DEFINITION_STATEMENT
  = SET_STATEMENT
  / CREATE_STATEMENT
  / ALTER_STATEMENT
  / DROP_STATEMENT


/* === CREATE statement === */

CREATE_STATEMENT "CREATE"
  = CREATE_DATABASE
  / CREATE_TABLE


ALTER_STATEMENT "ALTER"
  = ALTER_DATABASE
  / ALTER_TABLE
