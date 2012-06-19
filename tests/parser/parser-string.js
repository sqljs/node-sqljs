
var rule_yields = require('./common/helper-rule-yields');



exports['Grammar: STRING "String": valid input'] = rule_yields.bind(null, 
  'STRING', [
    ['""', ''],
    ['"A"', 'A'],
    ["''", ''],
    ["'A'", 'A'],
    ['"ěščřžýáíé"', 'ěščřžýáíé'],
    ['"\\\\ \\r \\n "', '\\ \r \n '],
  ]
);
