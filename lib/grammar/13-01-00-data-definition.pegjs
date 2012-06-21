
// 13.1. Data Definition Statements
// http://dev.mysql.com/doc/refman/5.6/en/sql-syntax-data-definition.html

DATA_DEFINITION_STATEMENT
  = SET_STATEMENT
  / CREATE_STATEMENT
  / DROP_STATEMENT


/* === CREATE statement === */

CREATE_STATEMENT "CREATE"
  = CREATE_DATABASE
  / CREATE_TABLE_STATEMENT


CREATE_DATABASE "CREATE DATABASE"
  = "CREATE"i __ "DATABASE"i __ name:QUOTED_ID props:SCHEMA_PROPERTIES {
      props.statement = 'CREATE DATABASE';
      props.database = name;
      return props;
    }


SCHEMA_PROPERTIES "schema properties"
  = __ ("DEFAULT"i __)? "CHAR"i "ACTER"i? (_/"_") "SET"i (_ "=" _ / __) charset:QUOTED_ID props:SCHEMA_PROPERTIES {
      props.charset = charset;
      return props;
    }
  / __ ("DEFAULT"i __)? "COLLAT"i ("E"i/"ION"i) (_ "=" _ / __) collate:QUOTED_ID props:SCHEMA_PROPERTIES {
      props.collate = collate;
      return props;
    }
  / __ "COMMENT"i (_ "=" _ / __) comment:(QUOTED_ID/STRING) props:SCHEMA_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / _ { return {}; }


CREATE_TABLE_STATEMENT "CREATE TABLE"
  = ("CREATE"i __)? temp:("TEMP"i "ORARY"i? __)? "TABLE"i __ table:TABLE_NAME _ '(' columns:COLUMN_DEFINITIONS ')' props:SCHEMA_PROPERTIES { 
      props.statement = "CREATE TABLE";
      props.schema = table.schema;
      props.table = table.table;
      if(temp) props.temporary = true;
      props.columns = columns;
      return props;
    }


COLUMN_DEFINITIONS "Column definitions"
  = _ col:COLUMN_DEFINITION _ ',' cols:COLUMN_DEFINITIONS { cols.unshift(col); return cols; }
  / _ col:COLUMN_DEFINITION _ { return [col]; }
  / _ { return []; }


COLUMN_DEFINITION "Column definition"
  = name:QUOTED_ID props:COLUMN_TYPE_PROPERTIES { props.name = name; return props; }



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
  = __ prefix:("TINY"i/"SMALL"i/"MEDIUM"i/"BIG"i)? _ "INT"i "EGER"i? length:TYPE_LENGTH
    props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
      if(length) props.length = length;
      return props;
    }
  / __ ("NUM"i ("ERIC"i/"BER"i)? / "DECIMAL"i) length:NUMERIC_TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'DECIMAL';
      if(length.length) props.length = length.length;
      if(length.decimals) props.decimals = length.decimals;
      return props;
    }
  / __ ("VARCHAR"i/"CHARACTER"i __ "VARYING"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'VARCHAR';
      if(length) props.length = length;
      return props;
    }
  / __ ("CHAR"i/"CHARACTER"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'CHAR';
      if(length) props.length = length;
      return props;
    }
  / __ (prefix:("TINY"i/"MEDIUM"i/"LONG"i) _)? "TEXT"i props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = typeof prefix !== 'undefined' ? prefix.toUpperCase()+'TEXT' : 'TEXT';
      return props;
    }
  / __ type:("DATETIME"i/"DATE"i/"TIME"i/"TIMESTAMP"i/"YEAR"i) props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = type.toUpperCase();
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
  / __ "PRIMARY"i (_ "KEY"i)? props:COLUMN_TYPE_PROPERTIES {
      props.primaryKey=true;
      return props;
    }
  / __ "UNIQ"i "UE"i? props:COLUMN_TYPE_PROPERTIES {
      props.unique=true;
      return props;
    }
  / __ "AUTO"i ( "_" / _ )"INC"i "REMENT"i? props:COLUMN_TYPE_PROPERTIES {
      props.autoIncrement=true;
      return props;
    }
  / __ "DEFAULT"i __ value:CONSTANT_EXPRESSION props:COLUMN_TYPE_PROPERTIES {
      props.default = value;
      return props;
    }
  / __ "DEFAULT"i __ CURRENT_TIMESTAMP props:COLUMN_TYPE_PROPERTIES {
      props.default = 'CURRENT_TIMESTAMP';
      return props;
    }
  / __ "COMMENT"i ( _ "=" _ / __ )  comment:STRING props:COLUMN_TYPE_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / _ { return {}; }

