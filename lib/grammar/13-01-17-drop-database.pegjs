
// 13.1.17. DROP DATABASE Syntax
// http://dev.mysql.com/doc/refman/5.6/en/drop-database.html

DROP_STATEMENT "DROP"
  = "DROP"i __ ("DATABASE"i/"SCHEMA"i) __ name:QUOTED_ID {
      return {
        statement: "DROP DATABASE",
        database: name
      };
    }
  / "DROP"i __ "TABLE"i __ name:TABLE_NAME {
      return {
        statement: "DROP TABLE",
        schema: name.schema,
        table: name.name
      };
    }

