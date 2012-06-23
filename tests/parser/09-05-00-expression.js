
var rule_yields = require('./common/helper-rule-yields');



exports['Grammar: Expression: literals: integer'] = rule_yields.bind(null, 
  'EXPRESSION', [
    ['0', 0], 
    ['1', 1], 
    ['123', 123], 
  ],
  'deepEqual'
);



exports['Grammar: Expression: literals: float'] = rule_yields.bind(null, 
  'EXPRESSION', [
    ['0.0', 0.0], 
    ['1.1', 1.1], 
    ['.1', .1], 
  ],
  'deepEqual'
);



exports['Grammar: Expression: add'] = rule_yields.bind(null, 
  'EXPRESSION', [
    ['1+2', { operators: [ '+' ], expressions: [ 1, 2 ] }], 
    ['1-2', { operators: [ '-' ], expressions: [ 1, 2 ] }], 
    ['1+2+3+4', { operators: [ '+', '+', '+' ], expressions: [ 1, 2, 3, 4 ] }], 
    ['1+2-3+4-5', { operators: [ '+', '-', '+', '-' ], expressions: [ 1, 2, 3, 4, 5 ] }], 
    ['1+-2', { operators: [ '+' ], expressions: [ 1, { unary: '-', expression: 2 } ] }], 
    ['1-+2', { operators: [ '-' ], expressions: [ 1, { unary: '+', expression: 2 } ] }], 
    //['1++2', { operators: [ '+' ], expressions: [ 1, { unary: '+', expression: 2 } ] }], 
    //['1--2', { operators: [ '-' ], expressions: [ 1, { unary: '-', expression: 2 } ] }], 
  ],
  'deepEqual'
);
