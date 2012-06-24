
var rule_yields = require('./common/helper-rule-yields');


var result1 = [
  {
    statement: 'CREATE TABLE',
    schema: undefined,
    table: 'table',
    definitions: []
  }
];

var result2 = [
  {
    statement: 'CREATE TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { name: 'col1' } ]
  }
];

var result3 = [
  {
    statement: 'CREATE TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: false, name: 'col1' } ]
  }
];

var result4 = [
  {
    statement: 'CREATE TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: true, name: 'col1' } ]
  }
];

var result5 = [
  {
    statement: 'CREATE TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: true, type: 'INT', name: 'col1' } ]
  }
];

var result6 = [
  {
    statement: 'CREATE TABLE',
    schema: 'schema',
    table: 'table',
    temporary: true,
    definitions: []
  }
];

exports['Grammar: CREATE TABLE: valid input'] = rule_yields.bind(null, 
  undefined, [
    [
      'CREATE TABLE table ()', 
      result1
    ], [
      'CREATE TABLE table ();', 
      result1
    ], [
      'CREATE TABLE table()', 
      result1
    ], [
      'CREATE TABLE `table`()', 
      result1
    ], [
      'CREATE TABLE table(  )', 
      result1
    ], [
      'CREATE TABLE table(col1)', 
      result2
    ], [
      'CREATE TABLE table( col1)', 
      result2
    ], [
      'CREATE TABLE table(col1 )', 
      result2
    ], [
      'CREATE TABLE table( col1, )', 
      result2
    ], [
      'CREATE TABLE table( col1 , )', 
      result2
    ], [
      'CREATE TABLE table( col1 null, )', 
      result3
    ], [
      'CREATE TABLE table( col1 null , )', 
      result3
    ], [
      'CREATE TABLE table( col1 not null, )', 
      result4
    ], [
      'CREATE TABLE table( col1 noTnUll, )', 
      result4
    ], [
      'CREATE TABLE table( col1 int not null, )', 
      result5
    ], [
      'CREATE TABLE table( col1 not null int, )', 
      result5
    ], [
      'CREATE TEMP TABLE schema.table ()', 
      result6
    ], [
      'CREATE TEMP TABLE schema.table IF NOT EXISTS ()', 
      [{
        statement: 'CREATE TABLE',
        schema: 'schema',
        table: 'table',
        temporary: true,
        definitions: [],
        ifNotExists: true
      }]
    ]
  ], 'deepEqual'
);
