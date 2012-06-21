
// 13.8.4. USE Syntax
// http://dev.mysql.com/doc/refman/5.6/en/use.html

USE_STATEMENT "USE"
  = "USE"i __ ("DATABASE"i __)? name:QUOTED_ID {
      return { statement: "USE", datatbase: name };
    }
