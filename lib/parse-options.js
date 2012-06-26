
exports = module.exports = ParseOptions;



/**
 * ParseOptions: Controls how SQL is parsed
 * Available boolean options:
 *  ParseOptions#STRING_HEX_ESCAPE;
 *  ParseOptions#STRING_UNICODE_ESCAPE;
 *  ParseOptions#STRING_INVALID_ESCAPE_STRIP_BACKSLASH;
 *  ParseOptions#STRING_STRICT_ESCAPE;
 *  ParseOptions#ALLOW_OCTAL_NOTATION;
 *  ParseOptions#OCTAL_AS_DECIMAL;
 */
function ParseOptions() { }



ParseOptions.prototype.isParseOptions = true;



ParseOptions.prototype.createValueNull = function() {
  return {
    isNull: true,
    valueOf: function() { return null; },
    toString: function() { return "NULL"; },
    toSql: function() { return "NULL"; },
  };
};

ParseOptions.prototype.createValueTrue = function() { 
  return true; 
};

ParseOptions.prototype.createValueFalse = function() { 
  return false; 
};

ParseOptions.prototype.createValueCurrentTimestamp = function() {
  return {
    constant: "CURRENT_TIMESTAMP",
    toString: function() { return "CURRENT_TIMESTAMP"; },
    toSql: function() { return "CURRENT_TIMESTAMP"; },
  };
};



ParseOptions.prototype.isNullValue = function(val) {
  if(val === null)
    return true;

  if(typeof val.isNull !== 'undefined') {
    if(val.isNull === true || val.isNull === false)
      return val.isNull;
    if(typeof val.isNull === 'function')
      return val.isNull();
  }

  if(val && typeof val.valueOf === 'function' && val.valueOf() === null)
    return true;

  return false;
};



ParseOptions.prototype.expression = function(expr) { return expr; };
ParseOptions.prototype.orExpression = function(expr) { return expr; };
ParseOptions.prototype.xorExpression = function(expr) { return expr; };
ParseOptions.prototype.andExpression = function(expr) { return expr; };

// handles both, NOT and '!' operators
// note that this does not same priority in grammar
ParseOptions.prototype.notExpression = function(expr) { return expr; };

ParseOptions.prototype.comparisonExpression = function(expr) { return expr; };
ParseOptions.prototype.bitwiseOrExpression = function(expr) { return expr; };
ParseOptions.prototype.bitwiseAndExpression = function(expr) { return expr; };

// handles << and >> operators
ParseOptions.prototype.bitShiftExpression = function(expr) { return expr; };

// handles binary + (addition) and - (subtraction)
ParseOptions.prototype.addExpression = function(expr) { return expr; };
  
// handles binary operators:
//  - '*' - multiplication
//  - '/' - division
//  - 'DIV' - integer division
//  - '%' or 'MOD' - modulo - integer division remainder
ParseOptions.prototype.mulDivExpression = function(expr) { return expr; };

ParseOptions.prototype.bitwiseXorExpression = function(expr) { return expr; };
ParseOptions.prototype.unaryExpression = function(expr) { return expr; };
  
// hadles IS [NOT] (NULL | TRUE | FALSE | UNKNOWN)
ParseOptions.prototype.isExpression = function(expr) { return expr; };
  
// handles COLLATION 'name'
ParseOptions.prototype.collateExpression = function(expr) { return expr; };

// handles BINARY <expr> modifier
ParseOptions.prototype.modifierBinaryExpression = function(expr) { return expr; };



ParseOptions.prototype.resolveConstantExpressionObject = function(expr) {
  if(this.isNullValue(expr)) {
    return expr;
  } else if(expr.unary) {
    return this.resolveConstantExpressionUnary(expr);
  } else if(expr.operators) {
    return this.resolveConstantExpressionChain(expr);
  } else if(expr.binary) {
    return this.resolveConstantExpressionBinary(expr);
  }

  throw new Error("Cannot resolve expression as a constant");
};


ParseOptions.prototype.resolveConstantExpressionUnary = function(expr) {
  switch(expr.unary) {
    case '+':
      return + this.resolveConstantExpression(expr.expression);
    case '-':
      return - this.resolveConstantExpression(expr.expression);
    default:
      throw new Error("Cannot resolve expression as a constant: unary '"+expr.unary+"' operator");
  }
};


ParseOptions.prototype.resolveConstantExpressionBinary = function(expr) {
  var e1 = this.resolveConstantExpression(expr.expressions[0]);
  var e2 = this.resolveConstantExpression(expr.expressions[1]);
  switch(expr.binary) {
    case '+':
      return e1 + e2;
    case '-':
      return e1 - e2;
    case '*':
      return e1 * e2;
    case '/':
      return e1 / e2;
    case 'DIV':
      return Math.floor(e1 / e2);
    case '%':
    case 'MOD':
      return e1 % e2;
    default:
      throw new Error("Cannot resolve expression as a constant: unary '"+expr.unary+"' operator");
  }
  throw new Error("Cannot resolve expression as a constant: binary '"+expr.binary+"' operator");
};


ParseOptions.prototype.getOperatorsAssociativity = function(operators) {
  if(ParseOptions.prototype.getOperatorsAssociativity.right.indexOf(operators[0]) >= 0)
    return 'right';

  return 'left';
};
ParseOptions.prototype.getOperatorsAssociativity.right = [ ':=' ];



ParseOptions.prototype.resolveConstantExpressionChain = function(expr) {
  if(expr.operators.length === 1) {
    expr.binary = expr.operators[0];
    delete expr.operators;
    return this.resolveConstantExpressionBinary(expr);
  }

  var operators = expr.operators;
  var expressions = expr.expressions;
  if(this.getOperatorsAssociativity(expr.operators) === 'right') {
    operators.reverse();
    expressions.reverse();
  }

  var result, i, l = operators.length;
  result = expressions.shift();
  for(i=0; i<l; i++) {
    result = this.resolveConstantExpressionBinary({
      binary: operators.shift(),
      expressions: [result, expressions.shift()]
    });
  }
  return result;
};



ParseOptions.prototype.resolveConstantExpression = function(expr) {
  switch(typeof expr) {
    case 'number':
      return expr;
    case 'string':
      return expr;
    case 'object':
      return this.resolveConstantExpressionObject(expr);
  }
  throw new Error("Cannot resolve expression as a constant");
};


