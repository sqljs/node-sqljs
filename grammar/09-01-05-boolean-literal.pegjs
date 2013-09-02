
// 9.1.5. Boolean Literals
// http://dev.mysql.com/doc/refman/5.7/en/boolean-literals.html


BOOLEAN "boolean"
  = 'TRUE'i _ { return options.createValueTrue(); }
  / 'FALSE'i _ { return options.createValueFalse(); }

