
// 13.1.1. ALTER DATABASE Syntax
// http://dev.mysql.com/doc/refman/5.7/en/alter-database.html


ALTER_DATABASE
  = "ALTER"i __ what:("DATABASE"i / "SCHEMA"i) __ name:DATABASE_NAME {
      return {
        statement: "ALTER",
        what: what.toUpperCase()
      };
    }

