
// 13.2.5. INSERT Syntax
// http://dev.mysql.com/doc/refman/5.6/en/insert.html


INSERT_STATEMENT
  = "INSERT"i /* priority:INSERT_PRIORITY */ ignore:INSERT_IGNORE
    __ ("INTO"i __ )? name:TABLE_NAME /* [PARTITION (partition_name,...)] */
/*    
    [(col_name,...)]
    {VALUES | VALUE} ({expr | DEFAULT},...),(...),...
    [ ON DUPLICATE KEY UPDATE
      col_name=expr
        [, col_name=expr] ... ]
*/

/*
INSERT_PRIORITY
  = __ "LOW"i ( "_" / _ ) "PRIORITY"i { return "LOW"; }
  / __ "DELAYED"i { return "DELAYED"; }
  / __ "HIGH"i ( "_" / _ ) "PRIORITY"i { return "HIGH"; }
  / { return false; }
*/


INSERT_IGNORE
  = __ "IGNORE"i { return true; }
  / { return false; }