
var rule_yields = require('./common/helper-rule-yields');



exports['Grammar: PositiveInt: valid input'] = rule_yields.bind(null, 
  'PositiveInt', [
    ['0', 0],
    ['00', 0],
    ['000', 0],
    ['1', 1],
    ['10', 10],
    ['010', 8],
    ['0xa', 10],
    ['0x10', 16],
    ['0xff', 255],
    ['0xFF', 255],
    ['0xfF', 255],
    ['0xabcdef', 0xabcdef],
    ['0xABCDEF', 0xabcdef],
    ['0b10', 2],
    ['0b00010000', 16],
    ['0b10000000000000000000000000000000000000000000000000000000000000000', 0x10000000000000000],
  ]
);



exports['Grammar: PositiveInt: invalid input'] = rule_yields.bind(null, 
  'PositiveInt', [
    ['08', Error],
    ['0x', Error],
    ['0b', Error],
  ]
);

