
// 14.2.2.5. FOREIGN KEY Constraints
// http://dev.mysql.com/doc/refman/5.6/en/innodb-foreign-key-constraints.html


REFERENCE_DEFINITION
  = ("REFERENCES"i/"TO"i) __ 
      table:TABLE_NAME _ 
      cols:( "(" _ cols:ID_LIST ")" _ { return cols; })? _
      actions:REFERENCE_DEFINITION_ACTIONS
    {
      return {
        schema: table.schema,
        table: table.table,
        columns: cols,
        actions: actions
      };
    }

REFERENCE_DEFINITION_ACTIONS
  = "ON"i __ 
      type:("DELETE"i/"UPDATE"i) __ 
      action:REFERENCE_DEFINITION_ACTION_OPTION _ 
      actions:REFERENCE_DEFINITION_ACTIONS
    {
      var name = "ON "+type.toUpperCase();
      if(actions[name])
        throw new Error('Trying to redefine reference action "'+name+'"');
      actions[name] = action;
      return actions;
    }
  / { return {}; }

REFERENCE_DEFINITION_ACTION_OPTION
  = "RESTRICT"i   { return 'RESTRICT'; }
  / "CASCADE"i    { return 'CASCADE'; }
  / "SET NULL"i   { return 'SET NULL'; }
  / "NO ACTION"i  { return 'NO ACTION'; }

