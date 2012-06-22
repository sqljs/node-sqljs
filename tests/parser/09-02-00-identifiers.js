
var rule_yields = require('./common/helper-rule-yields');



exports['Grammar: ID "Identifier": valid input'] = rule_yields.bind(null, 
  'ID', [
    'a', 'aa', 'aaa',
    'a1', '_1',
    '_$aaa', '$_aaa',
    ['`x-x-x`', 'x-x-x'],
    ['`ěščřžýáíé`', 'ěščřžýáíé'],
    ['`_``_`', '_`_'],
  ]
);
