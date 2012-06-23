{
  var options = this.options || arguments[2] || {};

  options.STRING_HEX_ESCAPE = !!options.STRING_HEX_ESCAPE;
  options.STRING_UNICODE_ESCAPE = !!options.STRING_UNICODE_ESCAPE;
  options.STRING_INVALID_ESCAPE_STRIP_BACKSLASH = !!options.STRING_INVALID_ESCAPE_STRIP_BACKSLASH;
  options.STRING_STRICT_ESCAPE = !!options.STRING_STRICT_ESCAPE;

  options.ALLOW_OCTAL_NOTATION = !!options.ALLOW_OCTAL_NOTATION;
  options.OCTAL_AS_DECIMAL = !!options.OCTAL_AS_DECIMAL;

  if(typeof options.BOOLEAN_VALUE_TRUE === 'undefined')
    options.BOOLEAN_VALUE_TRUE = true;

  if(typeof options.BOOLEAN_VALUE_FALSE === 'undefined')
    options.BOOLEAN_VALUE_FALSE = false;

  if(typeof options.NULL_VALUE === 'undefined') {
    options.NULL_VALUE = {
      isNull: true,
      valueOf: function() { return null; },
      toString: function() { return "NULL"; }
    }
  }

  function defineExpressionEvent(name) {
    if(options[name]) return;
    options[name] = function(expr) { return expr; }
  }

  defineExpressionEvent('onExpression');
  defineExpressionEvent('onOrExpression');
  defineExpressionEvent('onXorExpression');
  defineExpressionEvent('onAndExpression');

  // handles both, NOT and '!' operators
  // note that this does not same priority in grammar
  defineExpressionEvent('onNotExpression');

  defineExpressionEvent('onComparisonExpression');
  defineExpressionEvent('onBitwiseOrExpression');
  defineExpressionEvent('onBitwiseAndExpression');

  // handles << and >> operators
  defineExpressionEvent('onBitShiftExpression');

  // handles binary + (addition) and - (subtraction)
  defineExpressionEvent('onAddExpression'); 
  
  // handles binary operators:
  //  - '*' - multiplication
  //  - '/' - division
  //  - 'DIV' - integer division
  //  - '%' or 'MOD' - modulo - integer division remainder
  defineExpressionEvent('onMulDivExpression');

  defineExpressionEvent('onBitwiseXorExpression');
  defineExpressionEvent('onUnaryExpression');
  
  // hadles IS [NOT] (NULL | TRUE | FALSE | UNKNOWN)
  defineExpressionEvent('onIsExpression');
  
  // handles COLLATION 'name'
  defineExpressionEvent('onCollateExpression');

  // handles BINARY <expr> modifier
  defineExpressionEvent('onModifierBinaryExpression');

}


START
  = STATEMENTS

