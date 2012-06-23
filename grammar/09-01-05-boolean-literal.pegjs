
// 9.1.5. Boolean Literals
// http://dev.mysql.com/doc/refman/5.6/en/boolean-literals.html


BOOLEAN
  = 'TRUE'i _ { return options.BOOLEAN_VALUE_TRUE; }
  / 'FALSE'i _ { return options.BOOLEAN_VALUE_FALSE; }

