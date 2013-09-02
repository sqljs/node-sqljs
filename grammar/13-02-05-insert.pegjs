
// 13.2.5. INSERT Syntax
// http://dev.mysql.com/doc/refman/5.6/en/insert.html

// INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
//     [INTO] tbl_name [PARTITION (partition_name,...)] 
//     [(col_name,...)]
//     {VALUES | VALUE} ({expr | DEFAULT},...),(...),...
//     [ ON DUPLICATE KEY UPDATE
//       col_name=expr
//         [, col_name=expr] ... ]
// Or:
// 
// INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
//     [INTO] tbl_name [PARTITION (partition_name,...)]
//     SET col_name={expr | DEFAULT}, ...
//     [ ON DUPLICATE KEY UPDATE
//       col_name=expr
//         [, col_name=expr] ... ]
// Or:
// 
// INSERT [LOW_PRIORITY | HIGH_PRIORITY] [IGNORE]
//     [INTO] tbl_name [PARTITION (partition_name,...)] 
//     [(col_name,...)]
//     SELECT ...
//     [ ON DUPLICATE KEY UPDATE
//       col_name=expr
//         [, col_name=expr] ... ]


INSERT_STATEMENT "INSERT"
  = "INSERT"i priority:INSERT_PRIORITY ignore:INSERT_IGNORE
      (__ "INTO"i )? __ table:TABLE_NAME /* [PARTITION (partition_name,...)] */ _
      columns:INSERT_COLUMN_LIST
      "VALUE"i "S"i? _ rows:INSERT_ROWS
    {
      var insert = {
        statement: "INSERT",
        table: table,
        columns: columns,
        rows: rows
      };

      if(priority)
        insert.priority = priority;

      if(ignore)
        insert.ignore = ignore;

      return insert;
    }

INSERT_PRIORITY
  = __ "LOW"i ( "_" / _ ) "PRIORITY"i { return "LOW"; }
  / __ "DELAYED"i { return "DELAYED"; }
  / __ "HIGH"i ( "_" / _ ) "PRIORITY"i { return "HIGH"; }
  / { return false; }


INSERT_IGNORE
  = __ "IGNORE"i { return true; }
  / { return false; }

INSERT_COLUMN_LIST
  = "(" _ col:(ID/STRING) tail:(_ ',' _ col:(ID/STRING) {return col;})* _ ")" _ {
      tail.unshift(col);
      return tail;
    }
  / { return []; }

INSERT_ROWS
  = first:INSERT_ROW rows:("," _ row:INSERT_ROW { return row; })*
    {
      rows.unshift(first);
      return rows;
    }

INSERT_ROW
  = "(" _ first:EXPRESSION row:("," expr:EXPRESSION { return expr; })* ")" _
    {
      row.unshift(first);
      return row;
    }