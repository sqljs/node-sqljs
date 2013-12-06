var rule_yields = require('./common/helper-rule-yields');

var result1 = [
  {
    statement: 'CREATE',
    what: 'DATABASE',
    database: 'db'
  }
];

var result2 = [
  {
    statement: 'CREATE',
    what: 'DATABASE',
    database: 'db',
    ifNotExists: true
  }
];

exports['Grammar: CREATE DATABASE: valid input'] = rule_yields.bind(null, 
  undefined, [
    [
      'CREATE DATABASE db', 
      result1
    ], [
      'CREATE DATABASE db;', 
      result1
    ], [
      'CREATE DATABASE IF NOT EXISTS db', 
      result2
    ], [
      'CREATE DATABASE IF NOT EXISTS db;', 
      result2
    ]
  ], 'deepEqual'
);
