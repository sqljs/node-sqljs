
// 13.1.14. CREATE TABLE Syntax
// http://dev.mysql.com/doc/refman/5.7/en/create-table.html

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
  / "IF"i _ "NOT"i _ "EXIST"i "S"i? _ props:TABLE_PROPERTIES {
      props.ifNotExists = true;
      return props;
    }
  / "ENGINE"i (_ '=' _ / __) name:(ID/STRING) _ props:TABLE_PROPERTIES {
      props.engine = name;
      return props;
    }
  / "AUTO"i ("_"/_)? "INC"i "REMENT"i _ (_ '=' _ / __) value:CONSTANT_EXPRESSION _ props:TABLE_PROPERTIES {
      props.autoIncrement = value;
      return props;
    }
  / _ { return {}; }



CREATE_DEFINITIONS
  = _ col:CREATE_DEFINITION cols:(_ ',' _ col:CREATE_DEFINITION { return col; })* _ (',' _)*
    { cols.unshift(col); return cols; }
  / _ { return []; }


CREATE_DEFINITION "column create definition"
  = CREATE_DEFINITION_CONSTRAINT
  / name:ID_OR_STR _ props:COLUMN_TYPE_PROPERTIES { props.name = name; return props; }


CREATE_DEFINITION_CONSTRAINT
  = constraint_name:CONSTRAINT_NAME_OPT "PRIMARY"i _ ("KEY"i _ )?
      "(" _ idlist:ID_LIST ")" _
    {
      return {
        type: "CONSTRAINT",
        constraint: "PRIMARY KEY",
        constraintName:constraint_name,
        columns: idlist
      };
    }
  / constraint_name:CONSTRAINT_NAME_OPT "FOREIGN"i _ ("KEY"i _ )?
      idx_name:(name:(ID/STRING) _ )?
      "(" _ idlist:ID_LIST ")" _
      ref:REFERENCE_DEFINITION
    {
      return {
        type: "CONSTRAINT",
        constraint: "FOREIGN KEY",
        constraintName:constraint_name,
        indexName:idx_name,
        columns: idlist,
        references: ref
      };
    }
  / "UNIQUE"i _ type:("KEY"i/"INDEX"i)?
      name:(_ name:(ID/STRING) {return name;})? _ "(" _ idlist:INDEX_COL_NAME_LIST ")" _
    {
      if(!key && name && name.match(/KEY|INDEX/i)) {
        key = name
        name = undefined
      }
      var key = {
        type: "CONSTRAINT",
        constraint: (type ? type.toUpperCase() : 'INDEX'),
        unique: true,
        columns: idlist
      };
      if(name)
        key.name = name;
      return key;
    }
  / unique:("UNIQUE"i __)? type:("KEY"i/"INDEX"i)
      name:(__ name:(ID/STRING) {return name;})? _ "(" _ idlist:INDEX_COL_NAME_LIST ")" _
    {
      var key = {
        type: "CONSTRAINT",
        constraint: type.toUpperCase(),
        unique: !!unique,
        columns: idlist
      };
      if(name)
        key.name = name;
      return key;
    }

CONSTRAINT_NAME_OPT
  = "CONSTRAINT"i __ !("PRIMARY"i/"FOREIGN"i/"KEY"i/"INDEX"i/"UNIQUE"i) name:(ID/STRING) _ { return name; }
  / "CONSTRAINT"i __ { return true; }
  / { }

/*
  | [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (index_col_name,...)
      [index_option] ...
  | {INDEX|KEY} [index_name] [index_type] (index_col_name,...)
      [index_option] ...
  | [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY]
      [index_name] [index_type] (index_col_name,...)
      [index_option] ...
  | {FULLTEXT|SPATIAL} [INDEX|KEY] [index_name] (index_col_name,...)
      [index_option] ...
  | [CONSTRAINT [symbol]] FOREIGN KEY
      [index_name] (index_col_name,...) reference_definition
  | CHECK (expr)
*/


ID_LIST
  = id:ID _ rest:(',' _ id2:ID _ { return id2; })* { rest.unshift(id); return rest; }

STRING_ID_LIST
  = id:(STRING/ID) _ rest:(',' _ id2:(STRING/ID) _ { return id2; })* { rest.unshift(id); return rest; }

INDEX_COL_NAME_LIST
  = index_col_name:INDEX_COL_NAME _ rest:(',' _ index_col_name2:INDEX_COL_NAME _ { return index_col_name2; })* { rest.unshift(index_col_name); return rest; }

INDEX_COL_NAME
  = id:ID length:TYPE_LENGTH {
    var key = {
      id: id,
    }
    if(length)
      key.length = length
    return key
  }


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
      props:COLUMN_TYPE_PROPERTIES
    {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
      if(length) props.length = length;
      return props;
    }
  / _ ("NUM"i ("ERIC"i/"BER"i)? / "DEC"i "IMAL"i?) length:NUMERIC_TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'DECIMAL';
      if(length.length) props.length = length.length;
      if(length.decimals) props.decimals = length.decimals;
      return props;
    }
  / _ type:("DOUBLE"i / "FLOAT"i / "REAL"i) length:NUMERIC_TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = type.toUpperCase();
      if(length.length) props.length = length.length;
      if(length.decimals) props.decimals = length.decimals;
      return props;
    }
  / _ ("CHAR"i __ "BINARY"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'BINARY';
      if(length) props.length = length;
      return props;
    }
  / _ ("VARBINARY"i/"VARCHAR"i __ "BINARY"i) length:TYPE_LENGTH props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'VARBINARY';
      if(length) props.length = length;
      return props;
    }
  / _ ("VARBINARY"i/"VARCHAR"i) length:TYPE_LENGTH _ "BINARY"i _ props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'VARBINARY';
      if(length) props.length = length;
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
  / _ (prefix:("TINY"i/"MEDIUM"i/"LONG"i)? _) "TEXT"i props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = typeof prefix !== 'undefined' ? prefix.toUpperCase()+'TEXT' : 'TEXT';
      return props;
    }
  / _ (prefix:("TINY"i/"MEDIUM"i/"LONG"i)? _) "BLOB"i props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = typeof prefix !== 'undefined' ? prefix.toUpperCase()+'BLOB' : 'BLOB';
      return props;
    }
  / _ type:("DATETIME"i/"DATE"i/"TIMESTAMP"i/"TIME"i/"YEAR"i) length:TYPE_LENGTH _
        props:COLUMN_TYPE_PROPERTIES
    {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = type.toUpperCase();
      if(length) props.length = length;
      return props;
    }
  / _ "BOOLEAN"i _ props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'BOOLEAN';
      return props;
    }
  / _ "ENUM"i _ "(" values:STRING_ID_LIST ")" _ props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'ENUM';
      props.values = values;
      return props;
    }
  / _ "SET"i _ "(" values:STRING_ID_LIST ")" _ props:COLUMN_TYPE_PROPERTIES {
      if(props.type)
        throw new SyntaxError("Ambiguous type");
      props.type = 'SET';
      props.values = values;
      return props;
    }
  / _ "UNSIGNED"i _ props:COLUMN_TYPE_PROPERTIES {
        props.unsigned=true;
        return props;
      }
  / _ "SIGNED"i _ props:COLUMN_TYPE_PROPERTIES {
        props.signed=true;
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
  / _ "COLLAT"i ("E"i/"ION"i) (_ "=" _ / __)
      collate:COLLATION_NAME _ props:COLUMN_TYPE_PROPERTIES
    {
      props.collate = collate;
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
  / _ "ON"i _ "UPDATE"i _ val:CURRENT_TIMESTAMP _ props:COLUMN_TYPE_PROPERTIES {
      props.onUpdate = val;
      return props;
    }
  / _ "COMMENT"i ( _ "=" _ / __ ) comment:STRING props:COLUMN_TYPE_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / _ { return {}; }
