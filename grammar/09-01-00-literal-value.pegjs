
// 9.1. Literal Values
// http://dev.mysql.com/doc/refman/5.6/en/literals.html


CONSTANT_VALUE
  = val:NULL _                  { return val; }
  / val:BOOLEAN _               { return val; }
  / val:STRING _                { return val; }
  / val:POSITIVE_NUMBER _       { return val; }
