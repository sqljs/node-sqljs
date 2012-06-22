
// 9.5. Expression Syntax
// http://dev.mysql.com/doc/refman/5.6/en/expressions.html

// 12.3.1. Operator Precedence
// http://dev.mysql.com/doc/refman/5.6/en/operator-precedence.html

EXPRESSION
  = ASSIGN_EXPR

ASSIGN_EXPR // := assignment, can be simly '=' but here i avoid it
  = left:LOGICALOR_EXPR tail:( _ ':=' _ expr:LOGICALOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "ASSIGN",
        expressions: tail
      };
    }
  / LOGICALOR_EXPR

LOGICALOR_EXPR // ||, OR
  = left:LOGICALXOR_EXPR tail:( _ ('||'/'OR'i) _ expr:LOGICALXOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "OR",
        expressions: tail
      };
    }
  / LOGICALXOR_EXPR

LOGICALXOR_EXPR // XOR
  = left:LOGICALAND_EXPR tail:( _ 'XOR'i _ expr:LOGICALXOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "XOR",
        expressions: tail
      };
    }
  / LOGICALAND_EXPR

LOGICALAND_EXPR // &&, AND
  = left:LOGICALNOT_EXPR tail:( _ ('&&'/'AND'i) _ expr:LOGICALNOT_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "AND",
        expressions: tail
      };
    }
  / LOGICALNOT_EXPR

LOGICALNOT_EXPR // NOT
  = "NOT"i __ expr:COND_EXPR {
      return {
        operator: "NOT",
        expression: expr
      };
    }
  / COND_EXPR 

COND_EXPR // BETWEEN, CASE, WHEN, THEN, ELSE
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = COMPARISON_EXPR

COMPARISON_EXPR // = (comparison), <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP, IN
  = left:BITOR_EXPR tail:( _ 
      op:('='/'<=>'/'>='/'>'/'<='/'<'/'<>'/'!='/'IS'i/'LIKE'i/'REGEXP'i/'IN'i) _ 
      val:BITOR_EXPR { return [op, val]; })+
    {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        exprs.push(val[0]); // operator
        operators.push(val[1]); // expression
      });
      return {
        operators: operators,
        expressions: exprs
      };
    }
  / BITOR_EXPR

BITOR_EXPR // |
  = left:BITAND_EXPR tail:( _ '|' _ expr:BITAND_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "|",
        expressions: tail
      };
    }
  / BITAND_EXPR

BITAND_EXPR // &
  = left:BITSHIFT_EXPR tail:( _ '&' _ expr:BITSHIFT_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "&",
        expressions: tail
      };
    }
  / BITSHIFT_EXPR

BITSHIFT_EXPR // <<, >>
  = left:ADD_EXPR tail:( _ op:('<<'/'>>') _ val:ADD_EXPR { return [op, val]; } )+ {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        exprs.push(val[0]); // operator
        operators.push(val[1]); // expression
      });
      return {
        operators: operators,
        expressions: exprs
      };
    }
  / ADD_EXPR

ADD_EXPR // +, -
  = left:MULT_EXPR tail:( _ op:('+'/'-') _ val:MULT_EXPR { return [op, val]; } )+ {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        exprs.push(val[0]); // operator
        operators.push(val[1]); // expression
      });
      return {
        operators: operators,
        expressions: exprs
      };
    }
  / MULT_EXPR

MULT_EXPR // *, /, DIV, %, MOD
  = left:BITXOR_EXPR tail:( _ 
      op:('*'/'/'/'DIV'i/'%'/'MOD'i) _ 
      val:BITXOR_EXPR { return [op, val]; } )+ 
    {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        exprs.push(val[0]); // operator
        operators.push(val[1]); // expression
      });
      return {
        operators: operators,
        expressions: exprs
      };
    }
  / BITXOR_EXPR

BITXOR_EXPR // ^
  = left:UNARY_EXPR tail:( _ '^' _ expr:UNARY_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "^",
        expressions: tail
      };
    }
  / UNARY_EXPR

UNARY_EXPR // - (unary minus), ~ (unary bit inversion)
  = op:('-'/'~'/'+') _ expr:UNARY_EXPR {
      return {
        unary: op,
        expression: expr
      };
    } 
  / HIGH_NOT_EXPR

HIGH_NOT_EXPR // !
  = '!' _ expr:HIGH_NOT_EXPR {
      return {
        unary: '!',
        expression: expr
      };
    } 
  / STRING_COLLATE_EXPR

STRING_COLLATE_EXPR // COLLATE
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = STRING_BINARY_EXPR

STRING_BINARY_EXPR // BINARY MODIFIER
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = INTERVAL_EXPR

INTERVAL_EXPR
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = PRIMARY_EXPR

PRIMARY_EXPR
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = CONSTANT_VALUE
  / "(" expr:EXPRESSION ")" { return expr; }

/*
    expr OR expr
  | expr || expr
  | expr XOR expr
  | expr AND expr
  | expr && expr
  | NOT expr
  | ! expr
  | boolean_primary IS [NOT] {TRUE | FALSE | UNKNOWN}
  | boolean_primary

boolean_primary:
    boolean_primary IS [NOT] NULL
  | boolean_primary <=> predicate
  | boolean_primary comparison_operator predicate
  | boolean_primary comparison_operator {ALL | ANY} (subquery)
  | predicate

comparison_operator: = | >= | > | <= | < | <> | !=

predicate:
    bit_expr [NOT] IN (subquery)
  | bit_expr [NOT] IN (expr [, expr] ...)
  | bit_expr [NOT] BETWEEN bit_expr AND predicate
  | bit_expr SOUNDS LIKE bit_expr
  | bit_expr [NOT] LIKE simple_expr [ESCAPE simple_expr]
  | bit_expr [NOT] REGEXP bit_expr
  | bit_expr

bit_expr:
    bit_expr | bit_expr
  | bit_expr & bit_expr
  | bit_expr << bit_expr
  | bit_expr >> bit_expr
  | bit_expr + bit_expr
  | bit_expr - bit_expr
  | bit_expr * bit_expr
  | bit_expr / bit_expr
  | bit_expr DIV bit_expr
  | bit_expr MOD bit_expr
  | bit_expr % bit_expr
  | bit_expr ^ bit_expr
  | bit_expr + interval_expr
  | bit_expr - interval_expr
  | simple_expr

simple_expr:
    literal
  | identifier
  | function_call
  | simple_expr COLLATE collation_name
  | param_marker
  | variable
  | simple_expr || simple_expr
  | + simple_expr
  | - simple_expr
  | ~ simple_expr
  | ! simple_expr
  | BINARY simple_expr
  | (expr [, expr] ...)
  | ROW (expr, expr [, expr] ...)
  | (subquery)
  | EXISTS (subquery)
  | {identifier expr}
  | match_expr
  | case_expr
  | interval_expr

*/