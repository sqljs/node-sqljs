
/* === CREATE statement === */

CREATE_TABLE_STATEMENT "CREATE TABLE statement"
  = ("CREATE"i __)? "TABLE"i __ table:TABLE_NAME _ '(' columns:COLUMN_DEFINITIONS ')' { 
      return {
        statement: "CREATE TABLE",
        schema: table.schema,
        table: table.table,
        columns: columns
      }; 
    }


COLUMN_DEFINITIONS "Column definitions"
  = _ col:COLUMN_DEFINITION _ ',' cols:COLUMN_DEFINITIONS { cols.unshift(col); return cols; }
  / _ col:COLUMN_DEFINITION _ { return [col]; }
  / _ { return []; }


COLUMN_DEFINITION "Column definition"
  = name:QUOTED_ID props:COLUMN_TYPE_PROPERTIES { props.name = name; return props; }


COLUMN_TYPE_PROPERTIES "Column type properties"
  = __ prefix:("TINY"i/"SMALL"i/"MEDIUM"i/"BIG"i)? _ "INT"i "EGER"i? props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
      return props;
    }
  / __ "NUM"i ("ERIC"i/"BER"i)? (_ "(" _ ) props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'NUMERIC';
      return props;
    }
  / __ "NOT"i _ "NULL"i props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=true;
      return props; 
    }
  / __ "NULL"i props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=false;
      return props;
    }
  / __ "DEFAULT"i __ CURRENT_TIMESTAMP props:COLUMN_TYPE_PROPERTIES {
      props.default = Date.now;
      return props;
    }
  / _ { return {}; }

