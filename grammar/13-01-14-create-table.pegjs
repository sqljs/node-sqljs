
// 13.1.14. CREATE TABLE Syntax
// http://dev.mysql.com/doc/refman/5.6/en/create-table.html

CREATE_TABLE
  = ("CREATE"i __)? 
      temp:("TEMP"i "ORARY"i? _)? "TABLE"i __ 
      props1:TABLE_PROPERTIES
      table:TABLE_NAME _ 
      props2:TABLE_PROPERTIES
      '(' columns:CREATE_DEFINITIONS ')' _
      props:TABLE_PROPERTIES 
    { 
      safeMergeObject(props, props1);
      safeMergeObject(props, props2);
      props.statement = "CREATE"; 
      props.what = "TABLE";
      props.schema = table.schema;
      props.table = table.table;
      if(temp) props.temporary = true;
      props.definitions = columns;
      return props;
    }


TABLE_PROPERTIES
  = ("DEFAULT"i __)? "CHAR"i "ACTER"i? (_/"_") "SET"i (_ "=" _ / __)
      charset:ID _
      props:TABLE_PROPERTIES
    {
      props.charset = charset;
      return props;
    }
  / ("DEFAULT"i __)? "COLLAT"i ("E"i/"ION"i) (_ "=" _ / __) 
      collate:COLLATION_NAME _ 
      props:TABLE_PROPERTIES 
    {
      props.collate = collate;
      return props;
    }
  / "COMMENT"i (_ "=" _ / __) comment:(ID/STRING) _ props:TABLE_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / "IF"i _ "NOT"i _ "EXISTS"i _ props:TABLE_PROPERTIES {
      props.ifNotExists = true;
      return props;
    }
  / "ENGINE"i (_ '=' _ / __) name:(ID/STRING) _ props:TABLE_PROPERTIES {
      props.engine = name;
      return props;
    }
  / _ { return {}; }



CREATE_DEFINITIONS
  = _ col:CREATE_DEFINITION _ ',' cols:CREATE_DEFINITIONS { cols.unshift(col); return cols; }
  / _ col:CREATE_DEFINITION _ { return [col]; }
  / _ { return []; }


CREATE_DEFINITION
  = CREATE_DEFINITION_CONSTRAINT
  / name:ID _ props:COLUMN_TYPE_PROPERTIES { props.name = name; return props; }


CREATE_DEFINITION_CONSTRAINT
  = "PRIMARY"i _ ("KEY"i _ )? "(" _ id_list:ID_LIST ")" {
      return { type: "CONSTRAINT", constraint: "PRIMARY KEY", columns: id_list };
    }

ID_LIST
  = id:ID _ rest:(',' _ id2:ID _ { return id2; }) { rest.unshift(id); return rest; }


NUMERIC_TYPE_LENGTH
  = _ "(" _ length:POSITIVE_INTEGER _ "," _ decimals:POSITIVE_INTEGER _ ")" {
      return { length: length, decimals: decimals };
    }
  / _ "(" _ length:POSITIVE_INTEGER _ ")" {
      return { length: length, decimals: 0 };
    }
  / { return {}; }


TYPE_LENGTH
  = _ "(" _ length:POSITIVE_INTEGER _ ")" {
      return length;
    }
  / { return; }


COLUMN_TYPE_PROPERTIES "Column type properties"
  = _ prefix:("TINY"i/"SMALL"i/"MEDIUM"i/"BIG"i)? _ "INT"i "EGER"i? length:TYPE_LENGTH
    props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
      if(length) props.length = length;
      return props;
    }
  / _ ("NUM"i ("ERIC"i/"BER"i)? / "DECIMAL"i) length:NUMERIC_TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'DECIMAL';
      if(length.length) props.length = length.length;
      if(length.decimals) props.decimals = length.decimals;
      return props;
    }
  / _ ("VARCHAR"i/"CHARACTER"i __ "VARYING"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'VARCHAR';
      if(length) props.length = length;
      return props;
    }
  / _ ("CHAR"i/"CHARACTER"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'CHAR';
      if(length) props.length = length;
      return props;
    }
  / _ (prefix:("TINY"i/"MEDIUM"i/"LONG"i) _)? "TEXT"i props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = typeof prefix !== 'undefined' ? prefix.toUpperCase()+'TEXT' : 'TEXT';
      return props;
    }
  / _ type:("DATETIME"i/"DATE"i/"TIME"i/"TIMESTAMP"i/"YEAR"i) props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = type.toUpperCase();
      return props;      
    }
  / _ "NOT"i _ "NULL"i _ props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=true;
      return props; 
    }
  / _ "NULL"i props:COLUMN_TYPE_PROPERTIES {
      if(typeof props.notNull !== 'undefined')
        throw new Error('NULL or NOT NULL?');
      props.notNull=false;
      return props;
    }
  / _ "PRIMARY"i (_ "KEY"i)? _ props:COLUMN_TYPE_PROPERTIES {
      props.primaryKey=true;
      return props;
    }
  / _ "UNIQ"i "UE"i? _ props:COLUMN_TYPE_PROPERTIES {
      props.unique=true;
      return props;
    }
  / _ "AUTO"i ( "_" / _ )"INC"i "REMENT"i? _ props:COLUMN_TYPE_PROPERTIES {
      props.autoIncrement=true;
      return props;
    }
  / _ "DEFAULT"i __ value:CONSTANT_EXPRESSION props:COLUMN_TYPE_PROPERTIES {
      props.default = value;
      return props;
    }
  / _ "DEFAULT"i __ CURRENT_TIMESTAMP props:COLUMN_TYPE_PROPERTIES {
      props.default = 'CURRENT_TIMESTAMP';
      return props;
    }
  / _ "COMMENT"i ( _ "=" _ / __ ) comment:STRING props:COLUMN_TYPE_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / _ { return {}; }

