
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



ParseOptions.prototype.createValueTrue = function() { 
  return true; 
}

ParseOptions.prototype.createValueFalse = function() { 
  return false; 
}

ParseOptions.prototype.createValueNull = function() {
  return {
    isNull: true,
    valueOf: function() { return null; },
    toString: function() { return "NULL"; }
  };
}



ParseOptions.prototype.expression = function(expr) { return expr; }
ParseOptions.prototype.orExpression = function(expr) { return expr; }
ParseOptions.prototype.xorExpression = function(expr) { return expr; }
ParseOptions.prototype.andExpression = function(expr) { return expr; }

// handles both, NOT and '!' operators
// note that this does not same priority in grammar
ParseOptions.prototype.notExpression = function(expr) { return expr; }

ParseOptions.prototype.comparisonExpression = function(expr) { return expr; }
ParseOptions.prototype.bitwiseOrExpression = function(expr) { return expr; }
ParseOptions.prototype.bitwiseAndExpression = function(expr) { return expr; }

// handles << and >> operators
ParseOptions.prototype.bitShiftExpression = function(expr) { return expr; }

// handles binary + (addition) and - (subtraction)
ParseOptions.prototype.addExpression = function(expr) { return expr; }
  
// handles binary operators:
//  - '*' - multiplication
//  - '/' - division
//  - 'DIV' - integer division
//  - '%' or 'MOD' - modulo - integer division remainder
ParseOptions.prototype.mulDivExpression = function(expr) { return expr; }

ParseOptions.prototype.bitwiseXorExpression = function(expr) { return expr; }
ParseOptions.prototype.unaryExpression = function(expr) { return expr; }
  
// hadles IS [NOT] (NULL | TRUE | FALSE | UNKNOWN)
ParseOptions.prototype.isExpression = function(expr) { return expr; }
  
// handles COLLATION 'name'
ParseOptions.prototype.collateExpression = function(expr) { return expr; }

// handles BINARY <expr> modifier
ParseOptions.prototype.modifierBinaryExpression = function(expr) { return expr; }



ParseOptions.prototype.resolveConstantExpressionObject = function(expr) {
  if(expr.unary) switch(expr.unary) {
    case '+':
      return + this.resolveConstantExpression(expr.expression);
    case '-':
      return - this.resolveConstantExpression(expr.expression);
    default:
      throw new Error("Cannot resolve expression as a constant: unary '"+expr.unary+"' operator");
  }
  else if(expr.operators) {
  
  }

  if(expr.binary) {
    throw new Error("Cannot resolve expression as a constant: binary '"+expr.binary+"' operator");
  }
  throw new Error("Cannot resolve expression as a constant");
};



ParseOptions.prototype.resolveConstantExpression = function(expr)
{
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


