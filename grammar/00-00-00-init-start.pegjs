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
}


START
  = STATEMENTS

