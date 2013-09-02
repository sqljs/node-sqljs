
// 13.2. Data Manipulation Statements
// http://dev.mysql.com/doc/refman/5.7/en/sql-syntax-data-manipulation.html

DATA_MANIPULATION_STATEMENT
  = CALL_STATEMENT
  / INSERT_STATEMENT

//  / DO_STATEMENT // 13.2.3. DO Syntax
//  / HANDLER_STATEMENT // 13.2.4. HANDLER Syntax
//  / INSERT_STATEMENT // 13.2.5. INSERT Syntax
//  / LOAD_DATA_INFILE_STATEMENT // 13.2.6. LOAD DATA INFILE Syntax
//  / LOAD_XML_STATEMENT // 13.2.7. LOAD XML Syntax
//  / REPLACE_STATEMENT // 13.2.8. REPLACE Syntax
  / SELECT_STATEMENT // 13.2.9. SELECT Syntax
//  / Subquery_STATEMENT // 13.2.10. Subquery Syntax
//  / UPDATE_STATEMENT // 13.2.11. UPDATE Syntax