
/* === STATEMENTS === */

STATEMENTS
  = _ statement:STATEMENT _ ';' statements:STATEMENTS {
      if(statement) statements.unshift(statement); return statements;
    }
  / _ statement:STATEMENT _ { return [statement]; }
  / _ { return []; }


STATEMENT
  = DDL

DDL 
  = USE_STATEMENT
  / SET_STATEMENT
  / CREATE_STATEMENT
  / DROP_STATEMENT

USE_STATEMENT "USE statement"
  = "USE"i __ ("DATABASE"i __)? name:QUOTED_ID {
      return { statement: "USE", datatbase: name };
    }