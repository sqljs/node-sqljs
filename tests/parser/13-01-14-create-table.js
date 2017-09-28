
var rule_yields = require('./common/helper-rule-yields');


var result1 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: []
  }
];

var result2 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { name: 'col1' } ]
  }
];

var result3 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: false, name: 'col1' } ]
  }
];

var result4 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: true, name: 'col1' } ]
  }
];

var result5 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { notNull: true, type: 'INT', name: 'col1' } ]
  }
];

var result6 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: 'schema',
    table: 'table',
    temporary: true,
    definitions: []
  }
];

var result7 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { type: 'INT', name: 'col1' } ]
  }
];

var result8 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'table',
    definitions: [ { type: 'INT', name: 'col1' } ]
  }
];

var result9 = [
  {
    statement: 'CREATE',
    what: 'TABLE',
    schema: undefined,
    table: 'a b c',
    definitions: [ { type: 'INT', name: 'x y z' } ]
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
        statement: 'CREATE',
        what: 'TABLE',
        schema: 'schema',
        table: 'table',
        temporary: true,
        definitions: [],
        ifNotExists: true
      }]
    ], [
      'CREATE TABLE table ("col1" integer);',
      result7
    ], [
      'CREATE TABLE "table" (col1 integer)',
      result8
    ], [
      'CREATE TABLE "table" (col1 varbinary(16))',
      [{
          statement: 'CREATE',
          what: 'TABLE',
          schema: undefined,
          table: 'table',
          definitions: [ { type: 'VARBINARY', length: 16, name: 'col1' } ]
      }]
    ], [
      'CREATE TABLE "table" (col1 char binary(16))',
      [{
          statement: 'CREATE',
          what: 'TABLE',
          schema: undefined,
          table: 'table',
          definitions: [ { type: 'BINARY', length: 16, name: 'col1' } ]
      }]
    ], [
      'CREATE TABLE "table" (col1 mediumblob)',
      [{
          statement: 'CREATE',
          what: 'TABLE',
          schema: undefined,
          table: 'table',
          definitions: [ { type: 'MEDIUMBLOB', name: 'col1' } ]
      }]
    ], [
      'CREATE TABLE "table" (col1 long text)',
      [{
          statement: 'CREATE',
          what: 'TABLE',
          schema: undefined,
          table: 'table',
          definitions: [ { type: 'LONGTEXT', name: 'col1' } ]
      }]
    ], [
      'CREATE TABLE "table" (col1 text)',
      [{
          statement: 'CREATE',
          what: 'TABLE',
          schema: undefined,
          table: 'table',
          definitions: [ { type: 'TEXT', name: 'col1' } ]
      }]
    ], [
      'ALTER TABLE `t` ADD PRIMARY KEY (`type`,`id`)',
      [{
          statement: 'ALTER',
          what: 'TABLE',
          table: 't',
          ignore: false,
          specifications: [{
            type: 'CONSTRAINT',
            constraint: 'PRIMARY KEY',
            constraintName: undefined,
            columns: [ 'type', 'id' ],
            alter_type: 'ADD'
          }]
      }]
    ], [
      'CREATE TABLE "a b c" ("x y z" integer)',
      result9
    ], [
        'CREATE TABLE a (id integer, UNIQUE(id))',
        [{
            statement: 'CREATE',
            what: 'TABLE',
            schema: undefined,
            table: 'a',
            definitions: [ { type: 'INT', name: 'id' },
                           { type: 'CONSTRAINT', constraint: 'INDEX', unique: true, columns: [ {id: 'id'} ] },
                         ]
        }]
    ], [
        'CREATE TABLE a (id integer, UNIQUE INDEX(id))',
        [{
            statement: 'CREATE',
            what: 'TABLE',
            schema: undefined,
            table: 'a',
            definitions: [ { type: 'INT', name: 'id' },
                           { type: 'CONSTRAINT', constraint: 'INDEX', unique: true, columns: [ {id: 'id'} ] },
                         ]
        }]
    ], [
        'CREATE TABLE a (name varchar(255), UNIQUE INDEX(name(10)))',
        [{
            statement: 'CREATE',
            what: 'TABLE',
            schema: undefined,
            table: 'a',
            definitions: [ { type: 'VARCHAR', name: 'name', length: 255 },
                           { type: 'CONSTRAINT', constraint: 'INDEX', unique: true, columns: [ {id: 'name', length: 10, } ] },
                         ]
        }]
    ], [
        'CREATE TABLE a (opts SET("blue", "red", "yellow"))',
        [{
            statement: 'CREATE',
            what: 'TABLE',
            schema: undefined,
            table: 'a',
            definitions: [ { type: 'SET', name: 'opts', values: [ 'blue', 'red', 'yellow', ] },
                         ]
        }]
    ], [
        'CREATE TABLE a (name VARCHAR(255) BINARY NOT NULL)',
        [{
            statement: 'CREATE',
            what: 'TABLE',
            schema: undefined,
            table: 'a',
            definitions: [ { type: 'VARBINARY', name: 'name', length: 255, notNull: true },
                         ]
        }]
    ]
  ], 'deepEqual'
);
