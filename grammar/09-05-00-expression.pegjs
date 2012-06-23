
// 9.5. Expression Syntax
// http://dev.mysql.com/doc/refman/5.6/en/expressions.html

// 12.3.1. Operator Precedence
// http://dev.mysql.com/doc/refman/5.6/en/operator-precedence.html

EXPRESSION
  = _ expr:ASSIGN_EXPR { return options.onExpression(expr); }

ASSIGN_EXPR // := assignment, can be simly '=' in some cases but here i avoid it
  = left:LOGICALOR_EXPR tail:( ':=' _ expr:LOGICALOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return {
        operator: "ASSIGN",
        expressions: tail
      };
    }
  / LOGICALOR_EXPR

LOGICALOR_EXPR // ||, OR
  = left:LOGICALXOR_EXPR tail:( ('||'/'OR'i) _ expr:LOGICALXOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onOrExpression({
        operator: "OR",
        expressions: tail
      });
    }
  / LOGICALXOR_EXPR

LOGICALXOR_EXPR // XOR
  = left:LOGICALAND_EXPR tail:( 'XOR'i _ expr:LOGICALXOR_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onXorExpression({
        operator: "XOR",
        expressions: tail
      });
    }
  / LOGICALAND_EXPR

LOGICALAND_EXPR // &&, AND
  = left:LOGICALNOT_EXPR tail:( ('&&'/'AND'i) _ expr:LOGICALNOT_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onAndExpression({
        operator: "AND",
        expressions: tail
      });
    }
  / LOGICALNOT_EXPR

LOGICALNOT_EXPR // NOT
  = "NOT"i __ expr:COND_EXPR {
      return options.onNotExpression({
        operator: "NOT",
        expression: expr
      });
    }
  / COND_EXPR 

COND_EXPR // BETWEEN, CASE, WHEN, THEN, ELSE
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = COMPARISON_EXPR

COMPARISON_EXPR // = (comparison), <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP, IN
  = expr:BITOR_EXPR "IS" _ 
      not:"NOT"i? _ 
      val:("TRUE"i / "FALSE"i / "UNKNOWN"i / "NULL"i) _
    {
      return options.onIsExpression({
        unary: 'IS',
        not: !!not,
        value: val.toUpperCase(),
        expression: expr
      });
    }
  / left:BITOR_EXPR tail:(
      op:('='/'<=>'/'>='/'>'/'<='/'<'/'<>'/'!='/'LIKE'i/'REGEXP'i/'IN'i) _ 
      val:BITOR_EXPR { return [op, val]; })+
    {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        operators.push(val[0]); // operator
        exprs.push(val[1]); // expression
      });
      return options.onComparisonExpression({
        operators: operators,
        expressions: exprs
      });
    }
  / BITOR_EXPR

BITOR_EXPR // |
  = left:BITAND_EXPR tail:( '|' _ expr:BITAND_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onBitwiseOrExpression({
        operator: "|",
        expressions: tail
      });
    }
  / BITAND_EXPR

BITAND_EXPR // &
  = left:BITSHIFT_EXPR tail:( '&' _ expr:BITSHIFT_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onBitwiseAndExpression({
        operator: "&",
        expressions: tail
      });
    }
  / BITSHIFT_EXPR

BITSHIFT_EXPR // <<, >>
  = left:ADD_EXPR tail:( op:('<<'/'>>') _ val:ADD_EXPR { return [op, val]; } )+ {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        operators.push(val[0]); // operator
        exprs.push(val[1]); // expression
      });
      return options.onBitShiftExpression({
        operators: operators,
        expressions: exprs
      });
    }
  / ADD_EXPR

ADD_EXPR // +, -
  = left:MULT_EXPR tail:( op:('+'/'-') _ val:MULT_EXPR { return [op, val]; } )+ {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        operators.push(val[0]); // operator
        exprs.push(val[1]); // expression
      });
      return options.onAddExpression({
        operators: operators,
        expressions: exprs
      });
    }
  / MULT_EXPR

MULT_EXPR // *, /, DIV, %, MOD
  = left:BITXOR_EXPR tail:( 
      op:('*' / '/' / 'DIV'i / '%' / 'MOD'i) _ 
      val:BITXOR_EXPR { return [op, val]; } )+ 
    {
      var exprs = [left];
      var operators = [];
      tail.forEach(function(val){
        operators.push(val[0]); // operator
        exprs.push(val[1]); // expression
      });
      return options.onMulDivExpression({
        operators: operators,
        expressions: exprs
      });
    }
  / BITXOR_EXPR

BITXOR_EXPR // ^
  = left:UNARY_EXPR tail:( '^' _ expr:UNARY_EXPR { return expr; } )+ {
      tail.unshift(left);
      return options.onBitwiseXorExpression({
        operator: "^",
        expressions: tail
      });
    }
  / UNARY_EXPR

UNARY_EXPR // - (unary minus), ~ (unary bit inversion), + (unary plus)
  = op:('~' / '+' / '-') _ expr:UNARY_EXPR {
      return options.onUnaryExpression({
        unary: op,
        expression: expr
      });
    } 
  / HIGH_NOT_EXPR

HIGH_NOT_EXPR // !
  = '!' _ expr:HIGH_NOT_EXPR {
      return options.onNotExpression({
        unary: '!',
        expression: expr
      });
    } 
  / STRING_COLLATE_EXPR

STRING_COLLATE_EXPR // COLLATE
  = expr:STRING_BINARY_EXPR "COLLATE"i _ collation:COLLATION_NAME {
      return options.onCollateExpression({
        unary: 'COLLATE',
        collation: collation,
        expression: expr
      });
    }
  / STRING_BINARY_EXPR


COLLATION_NAME "collation name"
  = ID
  / STRING


STRING_BINARY_EXPR // BINARY MODIFIER
  = "BINARY"i __ expr:INTERVAL_EXPR {
      return options.onModifierBinaryExpression({
        unary: 'BINARY',
        expression: expr
      });
    }
  / INTERVAL_EXPR

INTERVAL_EXPR
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  = PRIMARY_EXPR

PRIMARY_EXPR
  = CONSTANT_VALUE
  / "(" expr:EXPRESSION ")" { return expr; }


CONSTANT_EXPRESSION "constant expression"
  // TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
  // this is helper for evaluating expressions from constant values to constant value
  = CONSTANT_VALUE

