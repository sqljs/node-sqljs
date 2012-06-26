
// 13.1.6. ALTER TABLE Syntax
// http://dev.mysql.com/doc/refman/5.6/en/alter-table.html

ALTER_TABLE
  = "ALTER"i __ ignore:("IGNORE"i __)? "TABLE"i _ name:TABLE_NAME _ specifications:ALTER_TABLE_SPECIFICATIONS
    {
      return {
        statement: "ALTER",
        what: "TABLE",
        ignore: !!ignore,
        specifications:specifications
      };
    }

ALTER_TABLE_SPECIFICATIONS
  = first:ALTER_TABLE_SPECIFICATION _ tail:(',' _ spec:ALTER_TABLE_SPECIFICATION { return spec; })* 
    {
      tail.unshift(first);
      return tail;
    }

ALTER_TABLE_SPECIFICATION
  = "ADD"i _ column:CREATE_DEFINITION {
      column.alter_type = "ADD"
      return column;
    }
