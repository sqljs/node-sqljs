
// 13.2.1. CALL Syntax
// http://dev.mysql.com/doc/refman/5.6/en/call.html

CALL_STATEMENT "CALL"
  = "CALL"i __ name:QUOTED_ID _ "(" params:CALL_PARAMETER_LIST ")" {
      return {
        statement: "CALL",
        name: name,
        params: params
      };
    }
  / "CALL"i __ name:QUOTED_ID {
      return {
        statement: "CALL",
        name: name,
        params: []
      };
    }


CALL_PARAMETER_LIST
  = _ param:CALL_PARAMETER _ (',' _)? list:CALL_PARAMETER_LIST {
      list.unshift(param);
      return list;
    }
  / _ { return []; }


CALL_PARAMETER
  = CONSTANT_EXPRESSION
