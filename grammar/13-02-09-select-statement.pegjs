
// 13.2.9. SELECT Syntax
// http://dev.mysql.com/doc/refman/5.7/en/select.html

// SELECT
//     [ALL | DISTINCT | DISTINCTROW ]
//       [HIGH_PRIORITY]
//       [STRAIGHT_JOIN]
//       [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
//       [SQL_CACHE | SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
//     select_expr [, select_expr ...]
//     [FROM table_references
//       [PARTITION partition_list]
//     [WHERE where_condition]
//     [GROUP BY {col_name | expr | position}
//       [ASC | DESC], ... [WITH ROLLUP]]
//     [HAVING where_condition]
//     [ORDER BY {col_name | expr | position}
//       [ASC | DESC], ...]
//     [LIMIT {[offset,] row_count | row_count OFFSET offset}]
//     [PROCEDURE procedure_name(argument_list)]
//     [INTO OUTFILE 'file_name'
//         [CHARACTER SET charset_name]
//         export_options
//       | INTO DUMPFILE 'file_name'
//       | INTO var_name [, var_name]]
//     [FOR UPDATE | LOCK IN SHARE MODE]]

SELECT_STATEMENT "SELECT"
  = "SELECT"i __
        (("ALL"i / "DISTINCTROW"i / "DISTINCT"i) __ )?
        ("HIGH_PRIORITY"i __)?
        ("STRAIGHT_JOIN"i __)?
        ("SQL_SMALL_RESULT"i __)?
        ("SQL_BIG_RESULT"i __)?
        ("SQL_BUFFER_RESULT"i __)?
        (("SQL_CACHE"i / "SQL_NO_CACHE"i) __)?
        "SQL_CALC_FOUND_ROWS"i?

        SELECT_EXPRESSION_LIST

        ("FROM"i __ FROM_TABLE_REFERENCES
          ("PARTITION"i __ ID (_ "," _ ID)?)?

        ("WHERE"i _ WHERE_CONDITION)?

        ("GROUP"i _ "BY"i ( ","? COLUMN_NAME
          ("ASC"i / "DESC"i)? )+ ("WITH"i ("_" / _) "ROLLUP"i)?)?

        ("HAVING"i _ WHERE_CONDITION)?

        ("ORDER"i _ "BY"i _ EXPRESSION)?

        ("LIMIT"i _ ((offset:POSITIVE_NUMBER)? / POSITIVE_NUMBER "OFFSET"i POSITIVE_NUMBER))?

        ("PROCEDURE"i ID(EXPRESSION))?

        ("INTO"i __ "OUTFILE"i outfile:(ID/STRING)
            ("CHARACTER"i __ "SET"i ID)?
//            export_options
          / "INTO"i "DUMPFILE"i 'file_name'
          / "INTO"i ID (_ "," _ ID)?)?

        ("FOR"i _ "UPDATE"i / "LOCK"i _ "IN"i _ "SHARE"i _ "MODE"i)?)?


SELECT_EXPRESSION_LIST
  = "(" _ col:(ID/STRING) tail:(_ ',' _ col:(ID/STRING) {return col;})* _ ")" _ {
      tail.unshift(col);
      return tail;
    }
  / { return []; }


FROM_TABLE_REFERENCES
  = "(" _ col:(ID/STRING) tail:(_ ',' _ col:(ID/STRING) {return col;})* _ ")" _ {
      tail.unshift(col);
      return tail;
    }

WHERE_CONDITION
  = EXPRESSION