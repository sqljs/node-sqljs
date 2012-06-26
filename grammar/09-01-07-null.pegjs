
// 9.1.7. NULL Value
// http://dev.mysql.com/doc/refman/5.6/en/null-values.html

NULL "NULL"
  = ("NULL"i / "\N") _ { return options.createValueNull(); }

