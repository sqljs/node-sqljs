
var rule_yields = require('./common/helper-rule-yields');



exports['Grammar: STRING "String": valid input'] = rule_yields.bind(null, 
  'STRING', [
    ['""', ''],
    ['"A"', 'A'],
    ["''", ''],
    ["'A'", 'A'],
    ['"ěščřžýáíé"', 'ěščřžýáíé'],
    ['"\\\\ \\r \\n "', '\\ \r \n '],
    ['"A" \'B\'    "C"\'D\'   ', 'ABCD'],
    ['"\\%\\_"', '\\%\\_'],
    
    ['""""', '"'],
    ["''''", "'"],
    ["'I''m lucky'", "I'm lucky"],

    ["'\\x20'", ' ', {'STRING_HEX_ESCAPE': true}],
    ["'\\u0020'", ' ', {'STRING_UNICODE_ESCAPE': true}],
    ["'\\Q'", '\\Q', {'STRING_STRICT_ESCAPE': false, STRING_INVALID_ESCAPE_STRIP_BACKSLASH: false}],
    ["'\\Q'", 'Q', {'STRING_STRICT_ESCAPE': false, STRING_INVALID_ESCAPE_STRIP_BACKSLASH: true}],
  ]
);



exports['Grammar: STRING "String": invalid input'] = rule_yields.bind(null, 
  'STRING', [
    ["'\\Q'", Error, {'STRING_STRICT_ESCAPE': true}],
    ["'\\x20'", Error, {'STRING_STRICT_ESCAPE': true}],
    ["'\\u0020'", Error, {'STRING_STRICT_ESCAPE': true}],
  ]
);
