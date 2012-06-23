
// 9.1. Literal Values
// http://dev.mysql.com/doc/refman/5.6/en/literals.html


CONSTANT_VALUE
  = val:NULL                    { return val; }
  / val:BOOLEAN                 { return val; }
  / val:STRING                  { return val; }
  / val:POSITIVE_NUMBER         { return val; }
