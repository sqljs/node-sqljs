
// 13.7.4. SET Syntax
// http://dev.mysql.com/doc/refman/5.6/en/set-statement.html

// TODO: multiple set assignments

SET_STATEMENT "SET statement"
  = "SET"i __ variable:QUOTED_ID ( _ "=" _ / __) value:QUOTED_ID {
      return {
        statement: "SET",
        variable: variable,
        value: value
      };
    }
  / "SET"i __ variable:QUOTED_ID ( _ "=" _ / __) value:STRING {
      return {
        statement: "SET",
        variable: variable,
        value: value
      };
    }