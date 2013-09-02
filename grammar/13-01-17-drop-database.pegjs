
// 13.1.17. DROP DATABASE Syntax
// http://dev.mysql.com/doc/refman/5.7/en/drop-database.html

DROP_STATEMENT "DROP"
  = "DROP"i __ ("DATABASE"i/"SCHEMA"i) __ name:ID {
      return {
        statement: "DROP DATABASE",
        database: name
      };
    }
  / "DROP"i __ ("PROCEDURE"i) __ ifExists:IF_EXISTS_OPT _ name:ID {
      return {
        statement: "DROP PROCEDURE",
        database: name,
        ifExists: ifExists
      };
    }
  / "DROP"i __ "TABLE"i __ name:TABLE_NAME {
      return {
        statement: "DROP TABLE",
        schema: name.schema,
        table: name.name
      };
    }

IF_EXISTS_OPT
  = "IF"i _ "EXIST"i "S"i? { return true; }
  / { return false; }