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