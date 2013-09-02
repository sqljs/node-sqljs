
// 13.1.8. CREATE DATABASE Syntax
// http://dev.mysql.com/doc/refman/5.7/en/create-database.html


CREATE_DATABASE "CREATE DATABASE"
  = "CREATE"i __ what:("SCHEMA"i/"DATABASE"i) __ name:ID _ props:SCHEMA_PROPERTIES {
      props.statement = 'CREATE';
      props.what = what.toUpperCase();
      props.database = name;
      return props;
    }


SCHEMA_PROPERTIES "schema properties"
  = ("DEFAULT"i __)? "CHAR"i "ACTER"i? (_/"_") "SET"i (_ "="? _ / __)
      charset:ID
      _ props:SCHEMA_PROPERTIES
    {
      props.charset = charset;
      return props;
    }
  / ("DEFAULT"i __)? "COLLAT"i ("E"i/"ION"i) (_ "=" _ / __) 
      collate:COLLATION_NAME 
      _ props:SCHEMA_PROPERTIES 
    {
      props.collate = collate;
      return props;
    }
  / "COMMENT"i (_ "=" _ / __) comment:(ID/STRING) _ props:SCHEMA_PROPERTIES {
      props.comment = comment;
      return props;
    }
  / "IF"i _ "NOT"i _ "EXIST"i "S"i? _ props:SCHEMA_PROPERTIES {
      props.ifNotExists = true;
      return props;
    }
  / _ { return {}; }

