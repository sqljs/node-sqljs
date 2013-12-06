;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var sqljs = window.sqljs = require('../../lib/sqljs');

var options = new sqljs.ParseOptions;

function parseText(text) {
  try {
    var result = sqljs.parse(text, undefined, options);
    console && console.log && console.log(result);
    return result;
  } catch(err) {
    console && console.error && console.error(err);
    return err;
  }
}


function parseClick() {
  var text = document.getElementById('editor').value;
  var result = window.parseResult = parseText(text);
  document.getElementById('output').innerText = JSON.stringify(result, null, 2);
};


window.onload = function() {
  console.log('Loaded!');
  document.getElementById('parseButton').onclick = parseClick;
};

},{"../../lib/sqljs":5}],2:[function(require,module,exports){

var colors = require('colors');



// pretty print error
module.exports = function(err, source_code, useColors) {

  var output = [];

  var k = function(a) { return a; };
  var bold = k
    , yellow_bold = k
    , red_bold = k
    , underline = k
    , green = k
    ;

  if(useColors) {
    bold = function(str) { return colors.bold(str); }
    red_bold = function(str) { return colors.bold(colors.red(str)); }
    yellow_bold = function(str) { return colors.bold(colors.yellow(str)); }
    underline = function(str) { return colors.underline(str); }
    green = function(str) { return colors.green(str); }
  }

  output.push(red_bold(err.toString()));

  if(err.line) {
    output.push([
      "At line ", bold(err.line),
      " column ", bold(err.column),
      " offset ", bold(err.offset),
      ].join(''));
  }
  if(err.expected)
    output.push("Expected one of:", yellow_bold(err.expected.join('  ')));

  if(source_code && err.line) {
    output.push(underline("Source listing:"));
    var lines = source_code.split('\n');
    var start = Math.max(err.line-6, 0);
    lines = lines.slice(start, err.line+25);
    for(var i=0,l=lines.length; i<l; i++) {
      if(start+i+1 === err.line && err.column) {
        var line = lines[i];
        output.push(green(start+i+1) + '\t' +
          line.slice(0, err.column-1) + red_bold(line.slice(err.column-1)));
      } else {
        output.push(green(start+i+1) + '\t' +
          lines[i]);
      }
    }
  }

  return output.join('\n');
}


},{"colors":6}],3:[function(require,module,exports){

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
  if(expr.constant) {
    return expr;
  } if(this.isNullValue(expr)) {
    return expr;
  } else if(expr.unary) {
    return this.resolveConstantExpressionUnary(expr);
  } else if(expr.operators) {
    return this.resolveConstantExpressionChain(expr);
  } else if(expr.binary) {
    return this.resolveConstantExpressionBinary(expr);
  }

  throw new Error("Cannot resolve expression as a constant: " + expr);
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



},{}],4:[function(require,module,exports){
module.exports = (function(){
  /*
   * Generated by PEG.js 0.7.0.
   *
   * http://pegjs.majda.cz/
   */
  
  function quote(s) {
    /*
     * ECMA-262, 5th ed., 7.8.4: All characters may appear literally in a
     * string literal except for the closing quote character, backslash,
     * carriage return, line separator, paragraph separator, and line feed.
     * Any character may appear in the form of an escape sequence.
     *
     * For portability, we also escape escape all control and non-ASCII
     * characters. Note that "\0" and "\v" escape sequences are not used
     * because JSHint does not like the first and IE the second.
     */
     return '"' + s
      .replace(/\\/g, '\\\\')  // backslash
      .replace(/"/g, '\\"')    // closing quote character
      .replace(/\x08/g, '\\b') // backspace
      .replace(/\t/g, '\\t')   // horizontal tab
      .replace(/\n/g, '\\n')   // line feed
      .replace(/\f/g, '\\f')   // form feed
      .replace(/\r/g, '\\r')   // carriage return
      .replace(/[\x00-\x07\x0B\x0E-\x1F\x80-\uFFFF]/g, escape)
      + '"';
  }
  
  var result = {
    /*
     * Parses the input with a generated parser. If the parsing is successfull,
     * returns a value explicitly or implicitly specified by the grammar from
     * which the parser was generated (see |PEG.buildParser|). If the parsing is
     * unsuccessful, throws |PEG.parser.SyntaxError| describing the error.
     */
    parse: function(input, startRule) {
      var parseFunctions = {
        "STRING": parse_STRING,
        "SINGLE_STRING": parse_SINGLE_STRING,
        "chars_no_quot": parse_chars_no_quot,
        "chars_no_apos": parse_chars_no_apos,
        "char_no_quot": parse_char_no_quot,
        "char_no_apos": parse_char_no_apos,
        "char_escape_sequence": parse_char_escape_sequence,
        "hexDigit": parse_hexDigit,
        "SIGNED_NUMBER": parse_SIGNED_NUMBER,
        "NUMBER_SIGN": parse_NUMBER_SIGN,
        "POSITIVE_NUMBER": parse_POSITIVE_NUMBER,
        "POSITIVE_FLOAT": parse_POSITIVE_FLOAT,
        "POSITIVE_INTEGER": parse_POSITIVE_INTEGER,
        "FloatLiteral": parse_FloatLiteral,
        "DecimalLiteral": parse_DecimalLiteral,
        "BOOLEAN": parse_BOOLEAN,
        "NULL": parse_NULL,
        "ID_OR_STR": parse_ID_OR_STR,
        "DATABASE_NAME": parse_DATABASE_NAME,
        "TABLE_NAME": parse_TABLE_NAME,
        "COLUMN_NAME": parse_COLUMN_NAME,
        "ID": parse_ID,
        "double_backtick_escape": parse_double_backtick_escape,
        "CONSTANT_EXPRESSION": parse_CONSTANT_EXPRESSION,
        "EXPRESSION": parse_EXPRESSION,
        "ASSIGN_EXPR": parse_ASSIGN_EXPR,
        "LOGICALOR_EXPR": parse_LOGICALOR_EXPR,
        "LOGICALXOR_EXPR": parse_LOGICALXOR_EXPR,
        "LOGICALAND_EXPR": parse_LOGICALAND_EXPR,
        "LOGICALNOT_EXPR": parse_LOGICALNOT_EXPR,
        "COMPARISON_EXPR": parse_COMPARISON_EXPR,
        "BITOR_EXPR": parse_BITOR_EXPR,
        "BITAND_EXPR": parse_BITAND_EXPR,
        "BITSHIFT_EXPR": parse_BITSHIFT_EXPR,
        "ADD_EXPR": parse_ADD_EXPR,
        "MULT_EXPR": parse_MULT_EXPR,
        "BITXOR_EXPR": parse_BITXOR_EXPR,
        "UNARY_EXPR": parse_UNARY_EXPR,
        "HIGH_NOT_EXPR": parse_HIGH_NOT_EXPR,
        "STRING_COLLATE_EXPR": parse_STRING_COLLATE_EXPR,
        "COLLATION_NAME": parse_COLLATION_NAME,
        "STRING_BINARY_EXPR": parse_STRING_BINARY_EXPR,
        "PRIMARY_EXPR": parse_PRIMARY_EXPR,
        "CONSTANT_VALUE": parse_CONSTANT_VALUE,
        "STATEMENTS": parse_STATEMENTS,
        "STATEMENT": parse_STATEMENT,
        "DATA_DEFINITION_STATEMENT": parse_DATA_DEFINITION_STATEMENT,
        "CREATE_STATEMENT": parse_CREATE_STATEMENT,
        "ALTER_STATEMENT": parse_ALTER_STATEMENT,
        "ALTER_DATABASE": parse_ALTER_DATABASE,
        "ALTER_TABLE": parse_ALTER_TABLE,
        "ALTER_TABLE_SPECIFICATIONS": parse_ALTER_TABLE_SPECIFICATIONS,
        "ALTER_TABLE_SPECIFICATION": parse_ALTER_TABLE_SPECIFICATION,
        "CREATE_DATABASE": parse_CREATE_DATABASE,
        "SCHEMA_PROPERTIES": parse_SCHEMA_PROPERTIES,
        "CREATE_TABLE": parse_CREATE_TABLE,
        "TABLE_PROPERTIES": parse_TABLE_PROPERTIES,
        "CREATE_DEFINITIONS": parse_CREATE_DEFINITIONS,
        "CREATE_DEFINITION": parse_CREATE_DEFINITION,
        "CREATE_DEFINITION_CONSTRAINT": parse_CREATE_DEFINITION_CONSTRAINT,
        "CONSTRAINT_NAME_OPT": parse_CONSTRAINT_NAME_OPT,
        "ID_LIST": parse_ID_LIST,
        "STRING_ID_LIST": parse_STRING_ID_LIST,
        "NUMERIC_TYPE_LENGTH": parse_NUMERIC_TYPE_LENGTH,
        "TYPE_LENGTH": parse_TYPE_LENGTH,
        "COLUMN_TYPE_PROPERTIES": parse_COLUMN_TYPE_PROPERTIES,
        "DROP_STATEMENT": parse_DROP_STATEMENT,
        "IF_EXISTS_OPT": parse_IF_EXISTS_OPT,
        "DATA_MANIPULATION_STATEMENT": parse_DATA_MANIPULATION_STATEMENT,
        "CALL_STATEMENT": parse_CALL_STATEMENT,
        "CALL_PARAMETER_LIST": parse_CALL_PARAMETER_LIST,
        "INSERT_STATEMENT": parse_INSERT_STATEMENT,
        "INSERT_PRIORITY": parse_INSERT_PRIORITY,
        "INSERT_IGNORE": parse_INSERT_IGNORE,
        "INSERT_COLUMN_LIST": parse_INSERT_COLUMN_LIST,
        "INSERT_ROWS": parse_INSERT_ROWS,
        "INSERT_ROW": parse_INSERT_ROW,
        "SELECT_STATEMENT": parse_SELECT_STATEMENT,
        "SELECT_EXPRESSION_LIST": parse_SELECT_EXPRESSION_LIST,
        "SELECT_EXPRESSION": parse_SELECT_EXPRESSION,
        "AGGREGATION_FUNCTION_NAME": parse_AGGREGATION_FUNCTION_NAME,
        "AGGREGATED_SOURCE": parse_AGGREGATED_SOURCE,
        "SELECT_COLUMN_SOURCE": parse_SELECT_COLUMN_SOURCE,
        "FROM_TABLE_REFERENCES": parse_FROM_TABLE_REFERENCES,
        "SET_STATEMENT": parse_SET_STATEMENT,
        "USE_STATEMENT": parse_USE_STATEMENT,
        "REFERENCE_DEFINITION": parse_REFERENCE_DEFINITION,
        "REFERENCE_DEFINITION_ACTIONS": parse_REFERENCE_DEFINITION_ACTIONS,
        "REFERENCE_DEFINITION_ACTION_OPTION": parse_REFERENCE_DEFINITION_ACTION_OPTION,
        "CURRENT_TIMESTAMP": parse_CURRENT_TIMESTAMP,
        "comment": parse_comment,
        "singleLineComment": parse_singleLineComment,
        "multiLineComment": parse_multiLineComment,
        "_": parse__,
        "__": parse___,
        "eol": parse_eol,
        "eolChar": parse_eolChar,
        "whitespace": parse_whitespace
      };
      
      if (startRule !== undefined) {
        if (parseFunctions[startRule] === undefined) {
          throw new Error("Invalid rule name: " + quote(startRule) + ".");
        }
      } else {
        startRule = "STATEMENTS";
      }
      
      var pos = 0;
      var reportFailures = 0;
      var rightmostFailuresPos = 0;
      var rightmostFailuresExpected = [];
      var cache = {};
      
      function padLeft(input, padding, length) {
        var result = input;
        
        var padLength = length - input.length;
        for (var i = 0; i < padLength; i++) {
          result = padding + result;
        }
        
        return result;
      }
      
      function escape(ch) {
        var charCode = ch.charCodeAt(0);
        var escapeChar;
        var length;
        
        if (charCode <= 0xFF) {
          escapeChar = 'x';
          length = 2;
        } else {
          escapeChar = 'u';
          length = 4;
        }
        
        return '\\' + escapeChar + padLeft(charCode.toString(16).toUpperCase(), '0', length);
      }
      
      function matchFailed(failure) {
        if (pos < rightmostFailuresPos) {
          return;
        }
        
        if (pos > rightmostFailuresPos) {
          rightmostFailuresPos = pos;
          rightmostFailuresExpected = [];
        }
        
        rightmostFailuresExpected.push(failure);
      }
      
      function parse_STRING() {
        var cacheKey = "STRING@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0;
        
        reportFailures++;
        pos0 = pos;
        result1 = parse_SINGLE_STRING();
        if (result1 !== null) {
          result0 = [];
          while (result1 !== null) {
            result0.push(result1);
            result1 = parse_SINGLE_STRING();
          }
        } else {
          result0 = null;
        }
        if (result0 !== null) {
          result0 = (function(offset, str) { return str.join(''); })(pos0, result0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("string");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SINGLE_STRING() {
        var cacheKey = "SINGLE_STRING@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 34) {
          result0 = "\"";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"\\\"\"");
          }
        }
        if (result0 !== null) {
          result1 = parse_chars_no_quot();
          if (result1 !== null) {
            if (input.charCodeAt(pos) === 34) {
              result2 = "\"";
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"\\\"\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, chars) { return chars; })(pos0, result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.charCodeAt(pos) === 39) {
            result0 = "'";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"'\"");
            }
          }
          if (result0 !== null) {
            result1 = parse_chars_no_apos();
            if (result1 !== null) {
              if (input.charCodeAt(pos) === 39) {
                result2 = "'";
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"'\"");
                }
              }
              if (result2 !== null) {
                result3 = parse__();
                if (result3 !== null) {
                  result0 = [result0, result1, result2, result3];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, chars) { return chars; })(pos0, result0[1]);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("string");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_chars_no_quot() {
        var cacheKey = "chars_no_quot@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0;
        
        pos0 = pos;
        result0 = [];
        result1 = parse_char_no_quot();
        while (result1 !== null) {
          result0.push(result1);
          result1 = parse_char_no_quot();
        }
        if (result0 !== null) {
          result0 = (function(offset, chars) { return chars.join(""); })(pos0, result0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_chars_no_apos() {
        var cacheKey = "chars_no_apos@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0;
        
        pos0 = pos;
        result0 = [];
        result1 = parse_char_no_apos();
        while (result1 !== null) {
          result0.push(result1);
          result1 = parse_char_no_apos();
        }
        if (result0 !== null) {
          result0 = (function(offset, chars) { return chars.join(""); })(pos0, result0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_char_no_quot() {
        var cacheKey = "char_no_quot@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        result0 = parse_char_escape_sequence();
        if (result0 === null) {
          pos0 = pos;
          if (input.substr(pos, 2) === "\"\"") {
            result0 = "\"\"";
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"\\\"\\\"\"");
            }
          }
          if (result0 !== null) {
            result0 = (function(offset) { return '"'; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            if (/^[^"]/.test(input.charAt(pos))) {
              result0 = input.charAt(pos);
              pos++;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("[^\"]");
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_char_no_apos() {
        var cacheKey = "char_no_apos@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        result0 = parse_char_escape_sequence();
        if (result0 === null) {
          pos0 = pos;
          if (input.substr(pos, 2) === "''") {
            result0 = "''";
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"''\"");
            }
          }
          if (result0 !== null) {
            result0 = (function(offset) { return "'"; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            if (/^[^']/.test(input.charAt(pos))) {
              result0 = input.charAt(pos);
              pos++;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("[^']");
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_char_escape_sequence() {
        var cacheKey = "char_escape_sequence@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1;
        
        pos0 = pos;
        if (input.substr(pos, 2) === "\\\\") {
          result0 = "\\\\";
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"\\\\\\\\\"");
          }
        }
        if (result0 !== null) {
          result0 = (function(offset) { return "\\"; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          if (input.substr(pos, 2) === "\\'") {
            result0 = "\\'";
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"\\\\'\"");
            }
          }
          if (result0 !== null) {
            result0 = (function(offset) { return "'";  })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            if (input.substr(pos, 2) === "\\\"") {
              result0 = "\\\"";
              pos += 2;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"\\\\\\\"\"");
              }
            }
            if (result0 !== null) {
              result0 = (function(offset) { return '"';  })(pos0);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              if (input.substr(pos, 2) === "\\0") {
                result0 = "\\0";
                pos += 2;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"\\\\0\"");
                }
              }
              if (result0 !== null) {
                result0 = (function(offset) { return "\x00"; })(pos0);
              }
              if (result0 === null) {
                pos = pos0;
              }
              if (result0 === null) {
                pos0 = pos;
                if (input.substr(pos, 2) === "\\/") {
                  result0 = "\\/";
                  pos += 2;
                } else {
                  result0 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"\\\\/\"");
                  }
                }
                if (result0 !== null) {
                  result0 = (function(offset) { return "/";  })(pos0);
                }
                if (result0 === null) {
                  pos = pos0;
                }
                if (result0 === null) {
                  pos0 = pos;
                  if (input.substr(pos, 2) === "\\b") {
                    result0 = "\\b";
                    pos += 2;
                  } else {
                    result0 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"\\\\b\"");
                    }
                  }
                  if (result0 !== null) {
                    result0 = (function(offset) { return "\b"; })(pos0);
                  }
                  if (result0 === null) {
                    pos = pos0;
                  }
                  if (result0 === null) {
                    pos0 = pos;
                    if (input.substr(pos, 2) === "\\n") {
                      result0 = "\\n";
                      pos += 2;
                    } else {
                      result0 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"\\\\n\"");
                      }
                    }
                    if (result0 !== null) {
                      result0 = (function(offset) { return "\n"; })(pos0);
                    }
                    if (result0 === null) {
                      pos = pos0;
                    }
                    if (result0 === null) {
                      pos0 = pos;
                      if (input.substr(pos, 2) === "\\f") {
                        result0 = "\\f";
                        pos += 2;
                      } else {
                        result0 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"\\\\f\"");
                        }
                      }
                      if (result0 !== null) {
                        result0 = (function(offset) { return "\f"; })(pos0);
                      }
                      if (result0 === null) {
                        pos = pos0;
                      }
                      if (result0 === null) {
                        pos0 = pos;
                        if (input.substr(pos, 2) === "\\r") {
                          result0 = "\\r";
                          pos += 2;
                        } else {
                          result0 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"\\\\r\"");
                          }
                        }
                        if (result0 !== null) {
                          result0 = (function(offset) { return "\r"; })(pos0);
                        }
                        if (result0 === null) {
                          pos = pos0;
                        }
                        if (result0 === null) {
                          pos0 = pos;
                          if (input.substr(pos, 2) === "\\t") {
                            result0 = "\\t";
                            pos += 2;
                          } else {
                            result0 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"\\\\t\"");
                            }
                          }
                          if (result0 !== null) {
                            result0 = (function(offset) { return "\t"; })(pos0);
                          }
                          if (result0 === null) {
                            pos = pos0;
                          }
                          if (result0 === null) {
                            pos0 = pos;
                            if (input.substr(pos, 2) === "\\Z") {
                              result0 = "\\Z";
                              pos += 2;
                            } else {
                              result0 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"\\\\Z\"");
                              }
                            }
                            if (result0 !== null) {
                              result0 = (function(offset) { return "\x1a"; })(pos0);
                            }
                            if (result0 === null) {
                              pos = pos0;
                            }
                            if (result0 === null) {
                              pos0 = pos;
                              pos1 = pos;
                              result0 = (function(offset) { return options.STRING_HEX_ESCAPE })(pos) ? "" : null;
                              if (result0 !== null) {
                                if (input.substr(pos, 2) === "\\x") {
                                  result1 = "\\x";
                                  pos += 2;
                                } else {
                                  result1 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\"\\\\x\"");
                                  }
                                }
                                if (result1 !== null) {
                                  result2 = parse_hexDigit();
                                  if (result2 !== null) {
                                    result3 = parse_hexDigit();
                                    if (result3 !== null) {
                                      result0 = [result0, result1, result2, result3];
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                              if (result0 !== null) {
                                result0 = (function(offset, h1, h2) {
                                    return String.fromCharCode(parseInt("0x" + h1 + h2));
                                  })(pos0, result0[2], result0[3]);
                              }
                              if (result0 === null) {
                                pos = pos0;
                              }
                              if (result0 === null) {
                                pos0 = pos;
                                pos1 = pos;
                                result0 = (function(offset) { return options.STRING_UNICODE_ESCAPE })(pos) ? "" : null;
                                if (result0 !== null) {
                                  if (input.substr(pos, 2) === "\\u") {
                                    result1 = "\\u";
                                    pos += 2;
                                  } else {
                                    result1 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"\\\\u\"");
                                    }
                                  }
                                  if (result1 !== null) {
                                    result2 = parse_hexDigit();
                                    if (result2 !== null) {
                                      result3 = parse_hexDigit();
                                      if (result3 !== null) {
                                        result4 = parse_hexDigit();
                                        if (result4 !== null) {
                                          result5 = parse_hexDigit();
                                          if (result5 !== null) {
                                            result0 = [result0, result1, result2, result3, result4, result5];
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                                if (result0 !== null) {
                                  result0 = (function(offset, h1, h2, h3, h4) {
                                      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
                                    })(pos0, result0[2], result0[3], result0[4], result0[5]);
                                }
                                if (result0 === null) {
                                  pos = pos0;
                                }
                                if (result0 === null) {
                                  pos0 = pos;
                                  pos1 = pos;
                                  if (input.charCodeAt(pos) === 92) {
                                    result0 = "\\";
                                    pos++;
                                  } else {
                                    result0 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"\\\\\"");
                                    }
                                  }
                                  if (result0 !== null) {
                                    if (input.length > pos) {
                                      result1 = input.charAt(pos);
                                      pos++;
                                    } else {
                                      result1 = null;
                                      if (reportFailures === 0) {
                                        matchFailed("any character");
                                      }
                                    }
                                    if (result1 !== null) {
                                      result0 = [result0, result1];
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                  if (result0 !== null) {
                                    result0 = (function(offset, char) {
                                        if(options.STRING_STRICT_ESCAPE)
                                          throw new SyntaxError("Unknown escape sequence: '\\"+char+"'");
                                  
                                        if(options.STRING_INVALID_ESCAPE_STRIP_BACKSLASH)
                                          return char;
                                  
                                        return '\\'+char;
                                      })(pos0, result0[1]);
                                  }
                                  if (result0 === null) {
                                    pos = pos0;
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_hexDigit() {
        var cacheKey = "hexDigit@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        if (/^[0-9a-fA-F]/.test(input.charAt(pos))) {
          result0 = input.charAt(pos);
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("[0-9a-fA-F]");
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SIGNED_NUMBER() {
        var cacheKey = "SIGNED_NUMBER@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = parse_NUMBER_SIGN();
        if (result0 !== null) {
          result1 = parse_POSITIVE_NUMBER();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, sign, val) { return val*sign; })(pos0, result0[0], result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("number");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_NUMBER_SIGN() {
        var cacheKey = "NUMBER_SIGN@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 45) {
          result0 = "-";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"-\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return -1; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.charCodeAt(pos) === 43) {
            result0 = "+";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"+\"");
            }
          }
          result0 = result0 !== null ? result0 : "";
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset) { return 1; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_POSITIVE_NUMBER() {
        var cacheKey = "POSITIVE_NUMBER@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        result0 = parse_POSITIVE_FLOAT();
        if (result0 === null) {
          result0 = parse_POSITIVE_INTEGER();
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("number");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_POSITIVE_FLOAT() {
        var cacheKey = "POSITIVE_FLOAT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = parse_FloatLiteral();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, val) { return parseFloat(val); })(pos0, result0[0]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("float");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_POSITIVE_INTEGER() {
        var cacheKey = "POSITIVE_INTEGER@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = (function(offset) { return options.ALLOW_OCTAL_NOTATION || options.OCTAL_AS_DECIMAL; })(pos) ? "" : null;
        if (result0 !== null) {
          if (input.charCodeAt(pos) === 48) {
            result1 = "0";
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"0\"");
            }
          }
          if (result1 !== null) {
            if (/^[0-7]/.test(input.charAt(pos))) {
              result3 = input.charAt(pos);
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("[0-7]");
              }
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                if (/^[0-7]/.test(input.charAt(pos))) {
                  result3 = input.charAt(pos);
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("[0-7]");
                  }
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, octal) { return parseInt('0'+octal.join(''), options.OCTAL_AS_DECIMAL ? 10 : 8); })(pos0, result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.substr(pos, 2).toLowerCase() === "0x") {
            result0 = input.substr(pos, 2);
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"0x\"");
            }
          }
          if (result0 !== null) {
            if (/^[0-9A-Fa-f]/.test(input.charAt(pos))) {
              result2 = input.charAt(pos);
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("[0-9A-Fa-f]");
              }
            }
            if (result2 !== null) {
              result1 = [];
              while (result2 !== null) {
                result1.push(result2);
                if (/^[0-9A-Fa-f]/.test(input.charAt(pos))) {
                  result2 = input.charAt(pos);
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("[0-9A-Fa-f]");
                  }
                }
              }
            } else {
              result1 = null;
            }
            if (result1 !== null) {
              result2 = parse__();
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, hex) { return parseInt(hex.join(''), 16); })(pos0, result0[1]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (input.substr(pos, 2).toLowerCase() === "0b") {
              result0 = input.substr(pos, 2);
              pos += 2;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"0b\"");
              }
            }
            if (result0 !== null) {
              if (/^[01]/.test(input.charAt(pos))) {
                result2 = input.charAt(pos);
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("[01]");
                }
              }
              if (result2 !== null) {
                result1 = [];
                while (result2 !== null) {
                  result1.push(result2);
                  if (/^[01]/.test(input.charAt(pos))) {
                    result2 = input.charAt(pos);
                    pos++;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("[01]");
                    }
                  }
                }
              } else {
                result1 = null;
              }
              if (result1 !== null) {
                result2 = parse__();
                if (result2 !== null) {
                  result0 = [result0, result1, result2];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, bin) { return parseInt(bin.join(''), 2); })(pos0, result0[1]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              pos1 = pos;
              result0 = parse_DecimalLiteral();
              if (result0 !== null) {
                result1 = parse__();
                if (result1 !== null) {
                  result0 = [result0, result1];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
              if (result0 !== null) {
                result0 = (function(offset, dec) { return parseInt(dec, 10); })(pos0, result0[0]);
              }
              if (result0 === null) {
                pos = pos0;
              }
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("integer");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_FloatLiteral() {
        var cacheKey = "FloatLiteral@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        if (/^[0-9]/.test(input.charAt(pos))) {
          result1 = input.charAt(pos);
          pos++;
        } else {
          result1 = null;
          if (reportFailures === 0) {
            matchFailed("[0-9]");
          }
        }
        if (result1 !== null) {
          result0 = [];
          while (result1 !== null) {
            result0.push(result1);
            if (/^[0-9]/.test(input.charAt(pos))) {
              result1 = input.charAt(pos);
              pos++;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("[0-9]");
              }
            }
          }
        } else {
          result0 = null;
        }
        if (result0 !== null) {
          pos2 = pos;
          pos3 = pos;
          if (/^[.]/.test(input.charAt(pos))) {
            result1 = input.charAt(pos);
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("[.]");
            }
          }
          if (result1 !== null) {
            result2 = [];
            if (/^[0-9]/.test(input.charAt(pos))) {
              result3 = input.charAt(pos);
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("[0-9]");
              }
            }
            while (result3 !== null) {
              result2.push(result3);
              if (/^[0-9]/.test(input.charAt(pos))) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("[0-9]");
                }
              }
            }
            if (result2 !== null) {
              result1 = [result1, result2];
            } else {
              result1 = null;
              pos = pos3;
            }
          } else {
            result1 = null;
            pos = pos3;
          }
          if (result1 !== null) {
            result1 = (function(offset, frac) {return '.'+ frac.join('')})(pos2, result1[1]);
          }
          if (result1 === null) {
            pos = pos2;
          }
          result1 = result1 !== null ? result1 : "";
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (/^[eE]/.test(input.charAt(pos))) {
              result2 = input.charAt(pos);
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("[eE]");
              }
            }
            if (result2 !== null) {
              if (/^[+\-]/.test(input.charAt(pos))) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("[+\\-]");
                }
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                if (/^[0-9]/.test(input.charAt(pos))) {
                  result5 = input.charAt(pos);
                  pos++;
                } else {
                  result5 = null;
                  if (reportFailures === 0) {
                    matchFailed("[0-9]");
                  }
                }
                if (result5 !== null) {
                  result4 = [];
                  while (result5 !== null) {
                    result4.push(result5);
                    if (/^[0-9]/.test(input.charAt(pos))) {
                      result5 = input.charAt(pos);
                      pos++;
                    } else {
                      result5 = null;
                      if (reportFailures === 0) {
                        matchFailed("[0-9]");
                      }
                    }
                  }
                } else {
                  result4 = null;
                }
                if (result4 !== null) {
                  result2 = [result2, result3, result4];
                } else {
                  result2 = null;
                  pos = pos3;
                }
              } else {
                result2 = null;
                pos = pos3;
              }
            } else {
              result2 = null;
              pos = pos3;
            }
            if (result2 !== null) {
              result2 = (function(offset, sign, exp) { return 'e' + sign + exp.join(''); })(pos2, result2[1], result2[2]);
            }
            if (result2 === null) {
              pos = pos2;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, base, frac, exp) {
              return base.join('') + frac + exp; 
            })(pos0, result0[0], result0[1], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (/^[0-9]/.test(input.charAt(pos))) {
            result1 = input.charAt(pos);
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("[0-9]");
            }
          }
          if (result1 !== null) {
            result0 = [];
            while (result1 !== null) {
              result0.push(result1);
              if (/^[0-9]/.test(input.charAt(pos))) {
                result1 = input.charAt(pos);
                pos++;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("[0-9]");
                }
              }
            }
          } else {
            result0 = null;
          }
          if (result0 !== null) {
            if (/^[.]/.test(input.charAt(pos))) {
              result1 = input.charAt(pos);
              pos++;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("[.]");
              }
            }
            if (result1 !== null) {
              pos2 = pos;
              result2 = [];
              if (/^[0-9]/.test(input.charAt(pos))) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("[0-9]");
                }
              }
              while (result3 !== null) {
                result2.push(result3);
                if (/^[0-9]/.test(input.charAt(pos))) {
                  result3 = input.charAt(pos);
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("[0-9]");
                  }
                }
              }
              if (result2 !== null) {
                result2 = (function(offset, frac) {return frac.join('')})(pos2, result2);
              }
              if (result2 === null) {
                pos = pos2;
              }
              result2 = result2 !== null ? result2 : "";
              if (result2 !== null) {
                pos2 = pos;
                pos3 = pos;
                if (/^[eE]/.test(input.charAt(pos))) {
                  result3 = input.charAt(pos);
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("[eE]");
                  }
                }
                if (result3 !== null) {
                  if (/^[+\-]/.test(input.charAt(pos))) {
                    result4 = input.charAt(pos);
                    pos++;
                  } else {
                    result4 = null;
                    if (reportFailures === 0) {
                      matchFailed("[+\\-]");
                    }
                  }
                  result4 = result4 !== null ? result4 : "";
                  if (result4 !== null) {
                    if (/^[0-9]/.test(input.charAt(pos))) {
                      result6 = input.charAt(pos);
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("[0-9]");
                      }
                    }
                    if (result6 !== null) {
                      result5 = [];
                      while (result6 !== null) {
                        result5.push(result6);
                        if (/^[0-9]/.test(input.charAt(pos))) {
                          result6 = input.charAt(pos);
                          pos++;
                        } else {
                          result6 = null;
                          if (reportFailures === 0) {
                            matchFailed("[0-9]");
                          }
                        }
                      }
                    } else {
                      result5 = null;
                    }
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, sign, exp) { return 'e' + sign + exp.join(''); })(pos2, result3[1], result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
                result3 = result3 !== null ? result3 : "";
                if (result3 !== null) {
                  result0 = [result0, result1, result2, result3];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, base, frac, exp) {
                return base.join('') + '.' + frac + exp; 
              })(pos0, result0[0], result0[2], result0[3]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (/^[.]/.test(input.charAt(pos))) {
              result0 = input.charAt(pos);
              pos++;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("[.]");
              }
            }
            if (result0 !== null) {
              if (/^[0-9]/.test(input.charAt(pos))) {
                result2 = input.charAt(pos);
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("[0-9]");
                }
              }
              if (result2 !== null) {
                result1 = [];
                while (result2 !== null) {
                  result1.push(result2);
                  if (/^[0-9]/.test(input.charAt(pos))) {
                    result2 = input.charAt(pos);
                    pos++;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("[0-9]");
                    }
                  }
                }
              } else {
                result1 = null;
              }
              if (result1 !== null) {
                pos2 = pos;
                pos3 = pos;
                if (/^[eE]/.test(input.charAt(pos))) {
                  result2 = input.charAt(pos);
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("[eE]");
                  }
                }
                if (result2 !== null) {
                  if (/^[+\-]/.test(input.charAt(pos))) {
                    result3 = input.charAt(pos);
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("[+\\-]");
                    }
                  }
                  result3 = result3 !== null ? result3 : "";
                  if (result3 !== null) {
                    if (/^[0-9]/.test(input.charAt(pos))) {
                      result5 = input.charAt(pos);
                      pos++;
                    } else {
                      result5 = null;
                      if (reportFailures === 0) {
                        matchFailed("[0-9]");
                      }
                    }
                    if (result5 !== null) {
                      result4 = [];
                      while (result5 !== null) {
                        result4.push(result5);
                        if (/^[0-9]/.test(input.charAt(pos))) {
                          result5 = input.charAt(pos);
                          pos++;
                        } else {
                          result5 = null;
                          if (reportFailures === 0) {
                            matchFailed("[0-9]");
                          }
                        }
                      }
                    } else {
                      result4 = null;
                    }
                    if (result4 !== null) {
                      result2 = [result2, result3, result4];
                    } else {
                      result2 = null;
                      pos = pos3;
                    }
                  } else {
                    result2 = null;
                    pos = pos3;
                  }
                } else {
                  result2 = null;
                  pos = pos3;
                }
                if (result2 !== null) {
                  result2 = (function(offset, sign, exp) { return 'e' + sign + exp.join(''); })(pos2, result2[1], result2[2]);
                }
                if (result2 === null) {
                  pos = pos2;
                }
                result2 = result2 !== null ? result2 : "";
                if (result2 !== null) {
                  result0 = [result0, result1, result2];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, frac, exp) {
                  return '0.' + frac.join('') + exp; 
                })(pos0, result0[1], result0[2]);
            }
            if (result0 === null) {
              pos = pos0;
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_DecimalLiteral() {
        var cacheKey = "DecimalLiteral@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (/^[1-9]/.test(input.charAt(pos))) {
          result0 = input.charAt(pos);
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("[1-9]");
          }
        }
        if (result0 !== null) {
          result1 = [];
          if (/^[0-9]/.test(input.charAt(pos))) {
            result2 = input.charAt(pos);
            pos++;
          } else {
            result2 = null;
            if (reportFailures === 0) {
              matchFailed("[0-9]");
            }
          }
          while (result2 !== null) {
            result1.push(result2);
            if (/^[0-9]/.test(input.charAt(pos))) {
              result2 = input.charAt(pos);
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("[0-9]");
              }
            }
          }
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, first, decimal) { return first+decimal.join(''); })(pos0, result0[0], result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          if (/^[0]/.test(input.charAt(pos))) {
            result1 = input.charAt(pos);
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("[0]");
            }
          }
          if (result1 !== null) {
            result0 = [];
            while (result1 !== null) {
              result0.push(result1);
              if (/^[0]/.test(input.charAt(pos))) {
                result1 = input.charAt(pos);
                pos++;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("[0]");
                }
              }
            }
          } else {
            result0 = null;
          }
          if (result0 !== null) {
            result0 = (function(offset) { return "0"; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_BOOLEAN() {
        var cacheKey = "BOOLEAN@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 4).toLowerCase() === "true") {
          result0 = input.substr(pos, 4);
          pos += 4;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"TRUE\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return options.createValueTrue(); })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.substr(pos, 5).toLowerCase() === "false") {
            result0 = input.substr(pos, 5);
            pos += 5;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"FALSE\"");
            }
          }
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset) { return options.createValueFalse(); })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("boolean");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_NULL() {
        var cacheKey = "NULL@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 4).toLowerCase() === "null") {
          result0 = input.substr(pos, 4);
          pos += 4;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"NULL\"");
          }
        }
        if (result0 === null) {
          if (input.charCodeAt(pos) === 78) {
            result0 = "N";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"N\"");
            }
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return options.createValueNull(); })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("NULL");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ID_OR_STR() {
        var cacheKey = "ID_OR_STR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        result0 = parse_ID();
        if (result0 === null) {
          result0 = parse_STRING();
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("ID or STR");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_DATABASE_NAME() {
        var cacheKey = "DATABASE_NAME@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        reportFailures++;
        pos0 = pos;
        result0 = parse_ID();
        if (result0 !== null) {
          result0 = (function(offset, schema) { return schema })(pos0, result0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("database name");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_TABLE_NAME() {
        var cacheKey = "TABLE_NAME@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = parse_ID_OR_STR();
        if (result0 !== null) {
          if (input.charCodeAt(pos) === 46) {
            result1 = ".";
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\".\"");
            }
          }
          if (result1 !== null) {
            result2 = parse_ID_OR_STR();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, schema, name) {
              return { schema: schema, table: name };
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          result0 = parse_ID_OR_STR();
          if (result0 !== null) {
            result0 = (function(offset, name) { return { table: name }; })(pos0, result0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("table name");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_COLUMN_NAME() {
        var cacheKey = "COLUMN_NAME@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = parse_ID_OR_STR();
        if (result0 !== null) {
          if (input.charCodeAt(pos) === 46) {
            result1 = ".";
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\".\"");
            }
          }
          if (result1 !== null) {
            result2 = parse_ID_OR_STR();
            if (result2 !== null) {
              if (input.charCodeAt(pos) === 46) {
                result3 = ".";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\".\"");
                }
              }
              if (result3 !== null) {
                result4 = parse_ID_OR_STR();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, schema, table, column) {
              return { schema: schema, table: table, column: column };
            })(pos0, result0[0], result0[2], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse_ID_OR_STR();
          if (result0 !== null) {
            if (input.charCodeAt(pos) === 46) {
              result1 = ".";
              pos++;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\".\"");
              }
            }
            if (result1 !== null) {
              result2 = parse_ID_OR_STR();
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, table, column) {
                return { table: table, column: column };
              })(pos0, result0[0], result0[2]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            result0 = parse_ID_OR_STR();
            if (result0 !== null) {
              result0 = (function(offset, column) {
                  return { column: column };
                })(pos0, result0);
            }
            if (result0 === null) {
              pos = pos0;
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("column name");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ID() {
        var cacheKey = "ID@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (/^[A-Za-z$_]/.test(input.charAt(pos))) {
          result0 = input.charAt(pos);
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("[A-Za-z$_]");
          }
        }
        if (result0 !== null) {
          result1 = [];
          if (/^[0-9A-Za-z$_]/.test(input.charAt(pos))) {
            result2 = input.charAt(pos);
            pos++;
          } else {
            result2 = null;
            if (reportFailures === 0) {
              matchFailed("[0-9A-Za-z$_]");
            }
          }
          while (result2 !== null) {
            result1.push(result2);
            if (/^[0-9A-Za-z$_]/.test(input.charAt(pos))) {
              result2 = input.charAt(pos);
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("[0-9A-Za-z$_]");
              }
            }
          }
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, start, rest) { return start + rest.join(''); })(pos0, result0[0], result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.charCodeAt(pos) === 96) {
            result0 = "`";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"`\"");
            }
          }
          if (result0 !== null) {
            if (/^[^`]/.test(input.charAt(pos))) {
              result2 = input.charAt(pos);
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("[^`]");
              }
            }
            if (result2 === null) {
              result2 = parse_double_backtick_escape();
            }
            if (result2 !== null) {
              result1 = [];
              while (result2 !== null) {
                result1.push(result2);
                if (/^[^`]/.test(input.charAt(pos))) {
                  result2 = input.charAt(pos);
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("[^`]");
                  }
                }
                if (result2 === null) {
                  result2 = parse_double_backtick_escape();
                }
              }
            } else {
              result1 = null;
            }
            if (result1 !== null) {
              if (input.charCodeAt(pos) === 96) {
                result2 = "`";
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"`\"");
                }
              }
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, name) { return name.join(''); })(pos0, result0[1]);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("identifier");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_double_backtick_escape() {
        var cacheKey = "double_backtick_escape@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        pos0 = pos;
        if (input.substr(pos, 2) === "``") {
          result0 = "``";
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"``\"");
          }
        }
        if (result0 !== null) {
          result0 = (function(offset) { return "`"; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CONSTANT_EXPRESSION() {
        var cacheKey = "CONSTANT_EXPRESSION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        reportFailures++;
        pos0 = pos;
        result0 = parse_EXPRESSION();
        if (result0 !== null) {
          result0 = (function(offset, expr) {
              return options.resolveConstantExpression(expr);
            })(pos0, result0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("constant expression");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_EXPRESSION() {
        var cacheKey = "EXPRESSION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = parse_ASSIGN_EXPR();
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr) { return options.expression(expr); })(pos0, result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ASSIGN_EXPR() {
        var cacheKey = "ASSIGN_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_LOGICALOR_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.substr(pos, 2) === ":=") {
              result3 = ":=";
              pos += 2;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\":=\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_LOGICALOR_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.substr(pos, 2) === ":=") {
                  result3 = ":=";
                  pos += 2;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\":=\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_LOGICALOR_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return {
                operator: ":=",
                expressions: tail
              };
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_LOGICALOR_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_LOGICALOR_EXPR() {
        var cacheKey = "LOGICALOR_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_LOGICALXOR_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.substr(pos, 2) === "||") {
              result3 = "||";
              pos += 2;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"||\"");
              }
            }
            if (result3 === null) {
              if (input.substr(pos, 2).toLowerCase() === "or") {
                result3 = input.substr(pos, 2);
                pos += 2;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"OR\"");
                }
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_LOGICALXOR_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, op, expr) { return [op, expr]; })(pos2, result3[0], result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.substr(pos, 2) === "||") {
                  result3 = "||";
                  pos += 2;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"||\"");
                  }
                }
                if (result3 === null) {
                  if (input.substr(pos, 2).toLowerCase() === "or") {
                    result3 = input.substr(pos, 2);
                    pos += 2;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"OR\"");
                    }
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_LOGICALXOR_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, op, expr) { return [op, expr]; })(pos2, result3[0], result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              var exprs = [left];
              var operators = [];
              tail.forEach(function(val){
                operators.push(val[0]); // operator
                exprs.push(val[1]); // expression
              });
              return options.orExpression({
                operators: operators,
                expressions: exprs
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_LOGICALXOR_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_LOGICALXOR_EXPR() {
        var cacheKey = "LOGICALXOR_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_LOGICALAND_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.substr(pos, 3).toLowerCase() === "xor") {
              result3 = input.substr(pos, 3);
              pos += 3;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"XOR\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_LOGICALXOR_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.substr(pos, 3).toLowerCase() === "xor") {
                  result3 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"XOR\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_LOGICALXOR_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return options.xorExpression({
                operator: "XOR",
                expressions: tail
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_LOGICALAND_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_LOGICALAND_EXPR() {
        var cacheKey = "LOGICALAND_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_LOGICALNOT_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.substr(pos, 2) === "&&") {
              result3 = "&&";
              pos += 2;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"&&\"");
              }
            }
            if (result3 === null) {
              if (input.substr(pos, 3).toLowerCase() === "and") {
                result3 = input.substr(pos, 3);
                pos += 3;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"AND\"");
                }
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_LOGICALNOT_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.substr(pos, 2) === "&&") {
                  result3 = "&&";
                  pos += 2;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"&&\"");
                  }
                }
                if (result3 === null) {
                  if (input.substr(pos, 3).toLowerCase() === "and") {
                    result3 = input.substr(pos, 3);
                    pos += 3;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"AND\"");
                    }
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_LOGICALNOT_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return options.andExpression({
                operator: "AND",
                expressions: tail
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_LOGICALNOT_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_LOGICALNOT_EXPR() {
        var cacheKey = "LOGICALNOT_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 3).toLowerCase() === "not") {
          result0 = input.substr(pos, 3);
          pos += 3;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"NOT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result2 = parse_COMPARISON_EXPR();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr) {
              return options.notExpression({
                unary: "NOT",
                expression: expr
              });
            })(pos0, result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_COMPARISON_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_COMPARISON_EXPR() {
        var cacheKey = "COMPARISON_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_BITOR_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            if (input.substr(pos, 2) === "IS") {
              result2 = "IS";
              pos += 2;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"IS\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                if (input.substr(pos, 3).toLowerCase() === "not") {
                  result4 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"NOT\"");
                  }
                }
                result4 = result4 !== null ? result4 : "";
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    if (input.substr(pos, 4).toLowerCase() === "true") {
                      result6 = input.substr(pos, 4);
                      pos += 4;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"TRUE\"");
                      }
                    }
                    if (result6 === null) {
                      if (input.substr(pos, 5).toLowerCase() === "false") {
                        result6 = input.substr(pos, 5);
                        pos += 5;
                      } else {
                        result6 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"FALSE\"");
                        }
                      }
                      if (result6 === null) {
                        if (input.substr(pos, 7).toLowerCase() === "unknown") {
                          result6 = input.substr(pos, 7);
                          pos += 7;
                        } else {
                          result6 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"UNKNOWN\"");
                          }
                        }
                        if (result6 === null) {
                          if (input.substr(pos, 4).toLowerCase() === "null") {
                            result6 = input.substr(pos, 4);
                            pos += 4;
                          } else {
                            result6 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"NULL\"");
                            }
                          }
                        }
                      }
                    }
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr, not, val) {
              return options.isExpression({
                unary: 'IS',
                not: !!not,
                value: val.toUpperCase(),
                expression: expr
              });
            })(pos0, result0[0], result0[4], result0[6]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse_BITOR_EXPR();
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              pos2 = pos;
              pos3 = pos;
              if (input.charCodeAt(pos) === 61) {
                result3 = "=";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"=\"");
                }
              }
              if (result3 === null) {
                if (input.substr(pos, 3) === "<=>") {
                  result3 = "<=>";
                  pos += 3;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"<=>\"");
                  }
                }
                if (result3 === null) {
                  if (input.substr(pos, 2) === ">=") {
                    result3 = ">=";
                    pos += 2;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\">=\"");
                    }
                  }
                  if (result3 === null) {
                    if (input.charCodeAt(pos) === 62) {
                      result3 = ">";
                      pos++;
                    } else {
                      result3 = null;
                      if (reportFailures === 0) {
                        matchFailed("\">\"");
                      }
                    }
                    if (result3 === null) {
                      if (input.substr(pos, 2) === "<=") {
                        result3 = "<=";
                        pos += 2;
                      } else {
                        result3 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"<=\"");
                        }
                      }
                      if (result3 === null) {
                        if (input.charCodeAt(pos) === 60) {
                          result3 = "<";
                          pos++;
                        } else {
                          result3 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"<\"");
                          }
                        }
                        if (result3 === null) {
                          if (input.substr(pos, 2) === "<>") {
                            result3 = "<>";
                            pos += 2;
                          } else {
                            result3 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"<>\"");
                            }
                          }
                          if (result3 === null) {
                            if (input.substr(pos, 2) === "!=") {
                              result3 = "!=";
                              pos += 2;
                            } else {
                              result3 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"!=\"");
                              }
                            }
                            if (result3 === null) {
                              if (input.substr(pos, 4).toLowerCase() === "like") {
                                result3 = input.substr(pos, 4);
                                pos += 4;
                              } else {
                                result3 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"LIKE\"");
                                }
                              }
                              if (result3 === null) {
                                if (input.substr(pos, 6).toLowerCase() === "regexp") {
                                  result3 = input.substr(pos, 6);
                                  pos += 6;
                                } else {
                                  result3 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\"REGEXP\"");
                                  }
                                }
                                if (result3 === null) {
                                  if (input.substr(pos, 2).toLowerCase() === "in") {
                                    result3 = input.substr(pos, 2);
                                    pos += 2;
                                  } else {
                                    result3 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"IN\"");
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_BITOR_EXPR();
                  if (result5 !== null) {
                    result3 = [result3, result4, result5];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
              }
              if (result3 === null) {
                pos = pos2;
              }
              if (result3 !== null) {
                result2 = [];
                while (result3 !== null) {
                  result2.push(result3);
                  pos2 = pos;
                  pos3 = pos;
                  if (input.charCodeAt(pos) === 61) {
                    result3 = "=";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"=\"");
                    }
                  }
                  if (result3 === null) {
                    if (input.substr(pos, 3) === "<=>") {
                      result3 = "<=>";
                      pos += 3;
                    } else {
                      result3 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"<=>\"");
                      }
                    }
                    if (result3 === null) {
                      if (input.substr(pos, 2) === ">=") {
                        result3 = ">=";
                        pos += 2;
                      } else {
                        result3 = null;
                        if (reportFailures === 0) {
                          matchFailed("\">=\"");
                        }
                      }
                      if (result3 === null) {
                        if (input.charCodeAt(pos) === 62) {
                          result3 = ">";
                          pos++;
                        } else {
                          result3 = null;
                          if (reportFailures === 0) {
                            matchFailed("\">\"");
                          }
                        }
                        if (result3 === null) {
                          if (input.substr(pos, 2) === "<=") {
                            result3 = "<=";
                            pos += 2;
                          } else {
                            result3 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"<=\"");
                            }
                          }
                          if (result3 === null) {
                            if (input.charCodeAt(pos) === 60) {
                              result3 = "<";
                              pos++;
                            } else {
                              result3 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"<\"");
                              }
                            }
                            if (result3 === null) {
                              if (input.substr(pos, 2) === "<>") {
                                result3 = "<>";
                                pos += 2;
                              } else {
                                result3 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"<>\"");
                                }
                              }
                              if (result3 === null) {
                                if (input.substr(pos, 2) === "!=") {
                                  result3 = "!=";
                                  pos += 2;
                                } else {
                                  result3 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\"!=\"");
                                  }
                                }
                                if (result3 === null) {
                                  if (input.substr(pos, 4).toLowerCase() === "like") {
                                    result3 = input.substr(pos, 4);
                                    pos += 4;
                                  } else {
                                    result3 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"LIKE\"");
                                    }
                                  }
                                  if (result3 === null) {
                                    if (input.substr(pos, 6).toLowerCase() === "regexp") {
                                      result3 = input.substr(pos, 6);
                                      pos += 6;
                                    } else {
                                      result3 = null;
                                      if (reportFailures === 0) {
                                        matchFailed("\"REGEXP\"");
                                      }
                                    }
                                    if (result3 === null) {
                                      if (input.substr(pos, 2).toLowerCase() === "in") {
                                        result3 = input.substr(pos, 2);
                                        pos += 2;
                                      } else {
                                        result3 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"IN\"");
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  if (result3 !== null) {
                    result4 = parse__();
                    if (result4 !== null) {
                      result5 = parse_BITOR_EXPR();
                      if (result5 !== null) {
                        result3 = [result3, result4, result5];
                      } else {
                        result3 = null;
                        pos = pos3;
                      }
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                  if (result3 !== null) {
                    result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
                  }
                  if (result3 === null) {
                    pos = pos2;
                  }
                }
              } else {
                result2 = null;
              }
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, left, tail) {
                var exprs = [left];
                var operators = [];
                tail.forEach(function(val){
                  operators.push(val[0]); // operator
                  exprs.push(val[1]); // expression
                });
                return options.comparisonExpression({
                  operators: operators,
                  expressions: exprs
                });
              })(pos0, result0[0], result0[2]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            result0 = parse_BITOR_EXPR();
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_BITOR_EXPR() {
        var cacheKey = "BITOR_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_BITAND_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 124) {
              result3 = "|";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"|\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_BITAND_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 124) {
                  result3 = "|";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"|\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_BITAND_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return options.bitwiseOrExpression({
                operator: "|",
                expressions: tail
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_BITAND_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_BITAND_EXPR() {
        var cacheKey = "BITAND_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_BITSHIFT_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 38) {
              result3 = "&";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"&\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_BITSHIFT_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 38) {
                  result3 = "&";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"&\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_BITSHIFT_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return options.bitwiseAndExpression({
                operator: "&",
                expressions: tail
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_BITSHIFT_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_BITSHIFT_EXPR() {
        var cacheKey = "BITSHIFT_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_ADD_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.substr(pos, 2) === "<<") {
              result3 = "<<";
              pos += 2;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"<<\"");
              }
            }
            if (result3 === null) {
              if (input.substr(pos, 2) === ">>") {
                result3 = ">>";
                pos += 2;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\">>\"");
                }
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_ADD_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.substr(pos, 2) === "<<") {
                  result3 = "<<";
                  pos += 2;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"<<\"");
                  }
                }
                if (result3 === null) {
                  if (input.substr(pos, 2) === ">>") {
                    result3 = ">>";
                    pos += 2;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\">>\"");
                    }
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_ADD_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              var exprs = [left];
              var operators = [];
              tail.forEach(function(val){
                operators.push(val[0]); // operator
                exprs.push(val[1]); // expression
              });
              return options.bitShiftExpression({
                operators: operators,
                expressions: exprs
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_ADD_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ADD_EXPR() {
        var cacheKey = "ADD_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_MULT_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 43) {
              result3 = "+";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"+\"");
              }
            }
            if (result3 === null) {
              if (input.charCodeAt(pos) === 45) {
                result3 = "-";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"-\"");
                }
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_MULT_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 43) {
                  result3 = "+";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"+\"");
                  }
                }
                if (result3 === null) {
                  if (input.charCodeAt(pos) === 45) {
                    result3 = "-";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"-\"");
                    }
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_MULT_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              var exprs = [left];
              var operators = [];
              tail.forEach(function(val){
                operators.push(val[0]); // operator
                exprs.push(val[1]); // expression
              });
              return options.addExpression({
                operators: operators,
                expressions: exprs
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_MULT_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_MULT_EXPR() {
        var cacheKey = "MULT_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_BITXOR_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 42) {
              result3 = "*";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"*\"");
              }
            }
            if (result3 === null) {
              if (input.charCodeAt(pos) === 47) {
                result3 = "/";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"/\"");
                }
              }
              if (result3 === null) {
                if (input.substr(pos, 3).toLowerCase() === "div") {
                  result3 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"DIV\"");
                  }
                }
                if (result3 === null) {
                  if (input.charCodeAt(pos) === 37) {
                    result3 = "%";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"%\"");
                    }
                  }
                  if (result3 === null) {
                    if (input.substr(pos, 3).toLowerCase() === "mod") {
                      result3 = input.substr(pos, 3);
                      pos += 3;
                    } else {
                      result3 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"MOD\"");
                      }
                    }
                  }
                }
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_BITXOR_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 42) {
                  result3 = "*";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"*\"");
                  }
                }
                if (result3 === null) {
                  if (input.charCodeAt(pos) === 47) {
                    result3 = "/";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"/\"");
                    }
                  }
                  if (result3 === null) {
                    if (input.substr(pos, 3).toLowerCase() === "div") {
                      result3 = input.substr(pos, 3);
                      pos += 3;
                    } else {
                      result3 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"DIV\"");
                      }
                    }
                    if (result3 === null) {
                      if (input.charCodeAt(pos) === 37) {
                        result3 = "%";
                        pos++;
                      } else {
                        result3 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"%\"");
                        }
                      }
                      if (result3 === null) {
                        if (input.substr(pos, 3).toLowerCase() === "mod") {
                          result3 = input.substr(pos, 3);
                          pos += 3;
                        } else {
                          result3 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"MOD\"");
                          }
                        }
                      }
                    }
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_BITXOR_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, op, val) { return [op, val]; })(pos2, result3[0], result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              var exprs = [left];
              var operators = [];
              tail.forEach(function(val){
                operators.push(val[0]); // operator
                exprs.push(val[1]); // expression
              });
              return options.mulDivExpression({
                operators: operators,
                expressions: exprs
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_BITXOR_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_BITXOR_EXPR() {
        var cacheKey = "BITXOR_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_UNARY_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 94) {
              result3 = "^";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\"^\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_UNARY_EXPR();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            if (result3 !== null) {
              result2 = [];
              while (result3 !== null) {
                result2.push(result3);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 94) {
                  result3 = "^";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"^\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result5 = parse_UNARY_EXPR();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
                if (result3 !== null) {
                  result3 = (function(offset, expr) { return expr; })(pos2, result3[2]);
                }
                if (result3 === null) {
                  pos = pos2;
                }
              }
            } else {
              result2 = null;
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, left, tail) {
              tail.unshift(left);
              return options.bitwiseXorExpression({
                operator: "^",
                expressions: tail
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_UNARY_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_UNARY_EXPR() {
        var cacheKey = "UNARY_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 126) {
          result0 = "~";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"~\"");
          }
        }
        if (result0 === null) {
          if (input.charCodeAt(pos) === 43) {
            result0 = "+";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"+\"");
            }
          }
          if (result0 === null) {
            if (input.charCodeAt(pos) === 45) {
              result0 = "-";
              pos++;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"-\"");
              }
            }
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_UNARY_EXPR();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, op, expr) {
              return options.unaryExpression({
                unary: op,
                expression: expr
              });
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_HIGH_NOT_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_HIGH_NOT_EXPR() {
        var cacheKey = "HIGH_NOT_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 33) {
          result0 = "!";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"!\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_HIGH_NOT_EXPR();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr) {
              return options.notExpression({
                unary: '!',
                expression: expr
              });
            })(pos0, result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_STRING_COLLATE_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_STRING_COLLATE_EXPR() {
        var cacheKey = "STRING_COLLATE_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_STRING_BINARY_EXPR();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            if (input.substr(pos, 7).toLowerCase() === "collate") {
              result2 = input.substr(pos, 7);
              pos += 7;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"COLLATE\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result4 = parse_COLLATION_NAME();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr, collation) {
              return options.collateExpression({
                unary: 'COLLATE',
                collation: collation,
                expression: expr
              });
            })(pos0, result0[0], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_STRING_BINARY_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_COLLATION_NAME() {
        var cacheKey = "COLLATION_NAME@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        result0 = parse_ID();
        if (result0 === null) {
          result0 = parse_STRING();
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("collation name");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_STRING_BINARY_EXPR() {
        var cacheKey = "STRING_BINARY_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 6).toLowerCase() === "binary") {
          result0 = input.substr(pos, 6);
          pos += 6;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"BINARY\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result2 = parse_PRIMARY_EXPR();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, expr) {
              return options.modifierBinaryExpression({
                unary: 'BINARY',
                expression: expr
              });
            })(pos0, result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_PRIMARY_EXPR();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_PRIMARY_EXPR() {
        var cacheKey = "PRIMARY_EXPR@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        result0 = parse_CONSTANT_VALUE();
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.charCodeAt(pos) === 40) {
            result0 = "(";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"(\"");
            }
          }
          if (result0 !== null) {
            result1 = parse_EXPRESSION();
            if (result1 !== null) {
              if (input.charCodeAt(pos) === 41) {
                result2 = ")";
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\")\"");
                }
              }
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, expr) { return expr; })(pos0, result0[1]);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CONSTANT_VALUE() {
        var cacheKey = "CONSTANT_VALUE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        result0 = parse_NULL();
        if (result0 === null) {
          result0 = parse_BOOLEAN();
          if (result0 === null) {
            result0 = parse_STRING();
            if (result0 === null) {
              result0 = parse_POSITIVE_NUMBER();
              if (result0 === null) {
                result0 = parse_CURRENT_TIMESTAMP();
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_STATEMENTS() {
        var cacheKey = "STATEMENTS@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8;
        var pos0, pos1, pos2, pos3, pos4;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = [];
          pos2 = pos;
          if (input.charCodeAt(pos) === 59) {
            result2 = ";";
            pos++;
          } else {
            result2 = null;
            if (reportFailures === 0) {
              matchFailed("\";\"");
            }
          }
          if (result2 !== null) {
            result3 = parse__();
            if (result3 !== null) {
              result2 = [result2, result3];
            } else {
              result2 = null;
              pos = pos2;
            }
          } else {
            result2 = null;
            pos = pos2;
          }
          while (result2 !== null) {
            result1.push(result2);
            pos2 = pos;
            if (input.charCodeAt(pos) === 59) {
              result2 = ";";
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\";\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos2;
              }
            } else {
              result2 = null;
              pos = pos2;
            }
          }
          if (result1 !== null) {
            result2 = parse_STATEMENT();
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result4 = [];
                pos2 = pos;
                pos3 = pos;
                pos4 = pos;
                if (input.charCodeAt(pos) === 59) {
                  result6 = ";";
                  pos++;
                } else {
                  result6 = null;
                  if (reportFailures === 0) {
                    matchFailed("\";\"");
                  }
                }
                if (result6 !== null) {
                  result7 = parse__();
                  if (result7 !== null) {
                    result6 = [result6, result7];
                  } else {
                    result6 = null;
                    pos = pos4;
                  }
                } else {
                  result6 = null;
                  pos = pos4;
                }
                if (result6 !== null) {
                  result5 = [];
                  while (result6 !== null) {
                    result5.push(result6);
                    pos4 = pos;
                    if (input.charCodeAt(pos) === 59) {
                      result6 = ";";
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\";\"");
                      }
                    }
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result6 = [result6, result7];
                      } else {
                        result6 = null;
                        pos = pos4;
                      }
                    } else {
                      result6 = null;
                      pos = pos4;
                    }
                  }
                } else {
                  result5 = null;
                }
                if (result5 !== null) {
                  result6 = parse_STATEMENT();
                  if (result6 !== null) {
                    result7 = parse__();
                    if (result7 !== null) {
                      result5 = [result5, result6, result7];
                    } else {
                      result5 = null;
                      pos = pos3;
                    }
                  } else {
                    result5 = null;
                    pos = pos3;
                  }
                } else {
                  result5 = null;
                  pos = pos3;
                }
                if (result5 !== null) {
                  result5 = (function(offset, stmt) { return stmt; })(pos2, result5[1]);
                }
                if (result5 === null) {
                  pos = pos2;
                }
                while (result5 !== null) {
                  result4.push(result5);
                  pos2 = pos;
                  pos3 = pos;
                  pos4 = pos;
                  if (input.charCodeAt(pos) === 59) {
                    result6 = ";";
                    pos++;
                  } else {
                    result6 = null;
                    if (reportFailures === 0) {
                      matchFailed("\";\"");
                    }
                  }
                  if (result6 !== null) {
                    result7 = parse__();
                    if (result7 !== null) {
                      result6 = [result6, result7];
                    } else {
                      result6 = null;
                      pos = pos4;
                    }
                  } else {
                    result6 = null;
                    pos = pos4;
                  }
                  if (result6 !== null) {
                    result5 = [];
                    while (result6 !== null) {
                      result5.push(result6);
                      pos4 = pos;
                      if (input.charCodeAt(pos) === 59) {
                        result6 = ";";
                        pos++;
                      } else {
                        result6 = null;
                        if (reportFailures === 0) {
                          matchFailed("\";\"");
                        }
                      }
                      if (result6 !== null) {
                        result7 = parse__();
                        if (result7 !== null) {
                          result6 = [result6, result7];
                        } else {
                          result6 = null;
                          pos = pos4;
                        }
                      } else {
                        result6 = null;
                        pos = pos4;
                      }
                    }
                  } else {
                    result5 = null;
                  }
                  if (result5 !== null) {
                    result6 = parse_STATEMENT();
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result5 = [result5, result6, result7];
                      } else {
                        result5 = null;
                        pos = pos3;
                      }
                    } else {
                      result5 = null;
                      pos = pos3;
                    }
                  } else {
                    result5 = null;
                    pos = pos3;
                  }
                  if (result5 !== null) {
                    result5 = (function(offset, stmt) { return stmt; })(pos2, result5[1]);
                  }
                  if (result5 === null) {
                    pos = pos2;
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = [];
                    pos2 = pos;
                    if (input.charCodeAt(pos) === 59) {
                      result7 = ";";
                      pos++;
                    } else {
                      result7 = null;
                      if (reportFailures === 0) {
                        matchFailed("\";\"");
                      }
                    }
                    if (result7 !== null) {
                      result8 = parse__();
                      if (result8 !== null) {
                        result7 = [result7, result8];
                      } else {
                        result7 = null;
                        pos = pos2;
                      }
                    } else {
                      result7 = null;
                      pos = pos2;
                    }
                    while (result7 !== null) {
                      result6.push(result7);
                      pos2 = pos;
                      if (input.charCodeAt(pos) === 59) {
                        result7 = ";";
                        pos++;
                      } else {
                        result7 = null;
                        if (reportFailures === 0) {
                          matchFailed("\";\"");
                        }
                      }
                      if (result7 !== null) {
                        result8 = parse__();
                        if (result8 !== null) {
                          result7 = [result7, result8];
                        } else {
                          result7 = null;
                          pos = pos2;
                        }
                      } else {
                        result7 = null;
                        pos = pos2;
                      }
                    }
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, first, statements) {
              statements.unshift(first); return statements;
            })(pos0, result0[2], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          result0 = parse__();
          if (result0 !== null) {
            result0 = (function(offset) { return []; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_STATEMENT() {
        var cacheKey = "STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        result0 = parse_DATA_DEFINITION_STATEMENT();
        if (result0 === null) {
          result0 = parse_DATA_MANIPULATION_STATEMENT();
          if (result0 === null) {
            result0 = parse_USE_STATEMENT();
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_DATA_DEFINITION_STATEMENT() {
        var cacheKey = "DATA_DEFINITION_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        result0 = parse_SET_STATEMENT();
        if (result0 === null) {
          result0 = parse_CREATE_STATEMENT();
          if (result0 === null) {
            result0 = parse_ALTER_STATEMENT();
            if (result0 === null) {
              result0 = parse_DROP_STATEMENT();
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_STATEMENT() {
        var cacheKey = "CREATE_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        result0 = parse_CREATE_DATABASE();
        if (result0 === null) {
          result0 = parse_CREATE_TABLE();
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("CREATE");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ALTER_STATEMENT() {
        var cacheKey = "ALTER_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        result0 = parse_ALTER_DATABASE();
        if (result0 === null) {
          result0 = parse_ALTER_TABLE();
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("ALTER");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ALTER_DATABASE() {
        var cacheKey = "ALTER_DATABASE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 5).toLowerCase() === "alter") {
          result0 = input.substr(pos, 5);
          pos += 5;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"ALTER\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            if (input.substr(pos, 8).toLowerCase() === "database") {
              result2 = input.substr(pos, 8);
              pos += 8;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"DATABASE\"");
              }
            }
            if (result2 === null) {
              if (input.substr(pos, 6).toLowerCase() === "schema") {
                result2 = input.substr(pos, 6);
                pos += 6;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"SCHEMA\"");
                }
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result4 = parse_DATABASE_NAME();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, what, name) {
              return {
                statement: "ALTER",
                what: what.toUpperCase()
              };
            })(pos0, result0[2], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ALTER_TABLE() {
        var cacheKey = "ALTER_TABLE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 5).toLowerCase() === "alter") {
          result0 = input.substr(pos, 5);
          pos += 5;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"ALTER\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            pos2 = pos;
            if (input.substr(pos, 6).toLowerCase() === "ignore") {
              result2 = input.substr(pos, 6);
              pos += 6;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"IGNORE\"");
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos2;
              }
            } else {
              result2 = null;
              pos = pos2;
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              if (input.substr(pos, 5).toLowerCase() === "table") {
                result3 = input.substr(pos, 5);
                pos += 5;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"TABLE\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_TABLE_NAME();
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_ALTER_TABLE_SPECIFICATIONS();
                      if (result7 !== null) {
                        result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, ignore, name, specifications) {
              return {
                statement: "ALTER",
                what: "TABLE",
                ignore: !!ignore,
                specifications:specifications
              };
            })(pos0, result0[2], result0[5], result0[7]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ALTER_TABLE_SPECIFICATIONS() {
        var cacheKey = "ALTER_TABLE_SPECIFICATIONS@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_ALTER_TABLE_SPECIFICATION();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = [];
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 44) {
              result3 = ",";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\",\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_ALTER_TABLE_SPECIFICATION();
                if (result5 !== null) {
                  result3 = [result3, result4, result5];
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, spec) { return spec; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            while (result3 !== null) {
              result2.push(result3);
              pos2 = pos;
              pos3 = pos;
              if (input.charCodeAt(pos) === 44) {
                result3 = ",";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_ALTER_TABLE_SPECIFICATION();
                  if (result5 !== null) {
                    result3 = [result3, result4, result5];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, spec) { return spec; })(pos2, result3[2]);
              }
              if (result3 === null) {
                pos = pos2;
              }
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, first, tail) {
              tail.unshift(first);
              return tail;
            })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ALTER_TABLE_SPECIFICATION() {
        var cacheKey = "ALTER_TABLE_SPECIFICATION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 3).toLowerCase() === "add") {
          result0 = input.substr(pos, 3);
          pos += 3;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"ADD\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_CREATE_DEFINITION();
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, column) {
              column.alter_type = "ADD"
              return column;
            })(pos0, result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_DATABASE() {
        var cacheKey = "CREATE_DATABASE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 6).toLowerCase() === "create") {
          result0 = input.substr(pos, 6);
          pos += 6;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"CREATE\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            if (input.substr(pos, 6).toLowerCase() === "schema") {
              result2 = input.substr(pos, 6);
              pos += 6;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"SCHEMA\"");
              }
            }
            if (result2 === null) {
              if (input.substr(pos, 8).toLowerCase() === "database") {
                result2 = input.substr(pos, 8);
                pos += 8;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"DATABASE\"");
                }
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                pos2 = pos;
                if (input.substr(pos, 2).toLowerCase() === "if") {
                  result4 = input.substr(pos, 2);
                  pos += 2;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"IF\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    if (input.substr(pos, 3).toLowerCase() === "not") {
                      result6 = input.substr(pos, 3);
                      pos += 3;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"NOT\"");
                      }
                    }
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        if (input.substr(pos, 5).toLowerCase() === "exist") {
                          result8 = input.substr(pos, 5);
                          pos += 5;
                        } else {
                          result8 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"EXIST\"");
                          }
                        }
                        if (result8 !== null) {
                          if (input.substr(pos, 1).toLowerCase() === "s") {
                            result9 = input.substr(pos, 1);
                            pos++;
                          } else {
                            result9 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"S\"");
                            }
                          }
                          result9 = result9 !== null ? result9 : "";
                          if (result9 !== null) {
                            result4 = [result4, result5, result6, result7, result8, result9];
                          } else {
                            result4 = null;
                            pos = pos2;
                          }
                        } else {
                          result4 = null;
                          pos = pos2;
                        }
                      } else {
                        result4 = null;
                        pos = pos2;
                      }
                    } else {
                      result4 = null;
                      pos = pos2;
                    }
                  } else {
                    result4 = null;
                    pos = pos2;
                  }
                } else {
                  result4 = null;
                  pos = pos2;
                }
                result4 = result4 !== null ? result4 : "";
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_ID();
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result8 = parse_SCHEMA_PROPERTIES();
                        if (result8 !== null) {
                          result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, what, exists, name, props) {
              props.statement = 'CREATE';
              props.what = what.toUpperCase();
              props.database = name;
              if (exists.length > 0) props.ifNotExists = true;
              return props;
            })(pos0, result0[2], result0[4], result0[6], result0[8]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("CREATE DATABASE");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SCHEMA_PROPERTIES() {
        var cacheKey = "SCHEMA_PROPERTIES@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        pos2 = pos;
        if (input.substr(pos, 7).toLowerCase() === "default") {
          result0 = input.substr(pos, 7);
          pos += 7;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"DEFAULT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos2;
          }
        } else {
          result0 = null;
          pos = pos2;
        }
        result0 = result0 !== null ? result0 : "";
        if (result0 !== null) {
          if (input.substr(pos, 4).toLowerCase() === "char") {
            result1 = input.substr(pos, 4);
            pos += 4;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"CHAR\"");
            }
          }
          if (result1 !== null) {
            if (input.substr(pos, 5).toLowerCase() === "acter") {
              result2 = input.substr(pos, 5);
              pos += 5;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"ACTER\"");
              }
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              result3 = parse__();
              if (result3 === null) {
                if (input.charCodeAt(pos) === 95) {
                  result3 = "_";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"_\"");
                  }
                }
              }
              if (result3 !== null) {
                if (input.substr(pos, 3).toLowerCase() === "set") {
                  result4 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"SET\"");
                  }
                }
                if (result4 !== null) {
                  pos2 = pos;
                  result5 = parse__();
                  if (result5 !== null) {
                    if (input.charCodeAt(pos) === 61) {
                      result6 = "=";
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"=\"");
                      }
                    }
                    result6 = result6 !== null ? result6 : "";
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result5 = [result5, result6, result7];
                      } else {
                        result5 = null;
                        pos = pos2;
                      }
                    } else {
                      result5 = null;
                      pos = pos2;
                    }
                  } else {
                    result5 = null;
                    pos = pos2;
                  }
                  if (result5 === null) {
                    result5 = parse___();
                  }
                  if (result5 !== null) {
                    result6 = parse_ID();
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result8 = parse_SCHEMA_PROPERTIES();
                        if (result8 !== null) {
                          result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, charset, props) {
              props.charset = charset;
              return props;
            })(pos0, result0[6], result0[8]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          pos2 = pos;
          if (input.substr(pos, 7).toLowerCase() === "default") {
            result0 = input.substr(pos, 7);
            pos += 7;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"DEFAULT\"");
            }
          }
          if (result0 !== null) {
            result1 = parse___();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos2;
            }
          } else {
            result0 = null;
            pos = pos2;
          }
          result0 = result0 !== null ? result0 : "";
          if (result0 !== null) {
            if (input.substr(pos, 6).toLowerCase() === "collat") {
              result1 = input.substr(pos, 6);
              pos += 6;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"COLLAT\"");
              }
            }
            if (result1 !== null) {
              if (input.substr(pos, 1).toLowerCase() === "e") {
                result2 = input.substr(pos, 1);
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"E\"");
                }
              }
              if (result2 === null) {
                if (input.substr(pos, 3).toLowerCase() === "ion") {
                  result2 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"ION\"");
                  }
                }
              }
              if (result2 !== null) {
                pos2 = pos;
                result3 = parse__();
                if (result3 !== null) {
                  if (input.charCodeAt(pos) === 61) {
                    result4 = "=";
                    pos++;
                  } else {
                    result4 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"=\"");
                    }
                  }
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos2;
                    }
                  } else {
                    result3 = null;
                    pos = pos2;
                  }
                } else {
                  result3 = null;
                  pos = pos2;
                }
                if (result3 === null) {
                  result3 = parse___();
                }
                if (result3 !== null) {
                  result4 = parse_COLLATION_NAME();
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result6 = parse_SCHEMA_PROPERTIES();
                      if (result6 !== null) {
                        result0 = [result0, result1, result2, result3, result4, result5, result6];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, collate, props) {
                props.collate = collate;
                return props;
              })(pos0, result0[4], result0[6]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (input.substr(pos, 7).toLowerCase() === "comment") {
              result0 = input.substr(pos, 7);
              pos += 7;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"COMMENT\"");
              }
            }
            if (result0 !== null) {
              pos2 = pos;
              result1 = parse__();
              if (result1 !== null) {
                if (input.charCodeAt(pos) === 61) {
                  result2 = "=";
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"=\"");
                  }
                }
                if (result2 !== null) {
                  result3 = parse__();
                  if (result3 !== null) {
                    result1 = [result1, result2, result3];
                  } else {
                    result1 = null;
                    pos = pos2;
                  }
                } else {
                  result1 = null;
                  pos = pos2;
                }
              } else {
                result1 = null;
                pos = pos2;
              }
              if (result1 === null) {
                result1 = parse___();
              }
              if (result1 !== null) {
                result2 = parse_ID();
                if (result2 === null) {
                  result2 = parse_STRING();
                }
                if (result2 !== null) {
                  result3 = parse__();
                  if (result3 !== null) {
                    result4 = parse_SCHEMA_PROPERTIES();
                    if (result4 !== null) {
                      result0 = [result0, result1, result2, result3, result4];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, comment, props) {
                  props.comment = comment;
                  return props;
                })(pos0, result0[2], result0[4]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              result0 = parse__();
              if (result0 !== null) {
                result0 = (function(offset) { return {}; })(pos0);
              }
              if (result0 === null) {
                pos = pos0;
              }
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("schema properties");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_TABLE() {
        var cacheKey = "CREATE_TABLE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        pos1 = pos;
        pos2 = pos;
        if (input.substr(pos, 6).toLowerCase() === "create") {
          result0 = input.substr(pos, 6);
          pos += 6;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"CREATE\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos2;
          }
        } else {
          result0 = null;
          pos = pos2;
        }
        result0 = result0 !== null ? result0 : "";
        if (result0 !== null) {
          pos2 = pos;
          if (input.substr(pos, 4).toLowerCase() === "temp") {
            result1 = input.substr(pos, 4);
            pos += 4;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"TEMP\"");
            }
          }
          if (result1 !== null) {
            if (input.substr(pos, 5).toLowerCase() === "orary") {
              result2 = input.substr(pos, 5);
              pos += 5;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"ORARY\"");
              }
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result1 = [result1, result2, result3];
              } else {
                result1 = null;
                pos = pos2;
              }
            } else {
              result1 = null;
              pos = pos2;
            }
          } else {
            result1 = null;
            pos = pos2;
          }
          result1 = result1 !== null ? result1 : "";
          if (result1 !== null) {
            if (input.substr(pos, 5).toLowerCase() === "table") {
              result2 = input.substr(pos, 5);
              pos += 5;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"TABLE\"");
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result4 = parse_TABLE_PROPERTIES();
                if (result4 !== null) {
                  result5 = parse_TABLE_NAME();
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_TABLE_PROPERTIES();
                      if (result7 !== null) {
                        if (input.charCodeAt(pos) === 40) {
                          result8 = "(";
                          pos++;
                        } else {
                          result8 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"(\"");
                          }
                        }
                        if (result8 !== null) {
                          result9 = parse_CREATE_DEFINITIONS();
                          if (result9 !== null) {
                            if (input.charCodeAt(pos) === 41) {
                              result10 = ")";
                              pos++;
                            } else {
                              result10 = null;
                              if (reportFailures === 0) {
                                matchFailed("\")\"");
                              }
                            }
                            if (result10 !== null) {
                              result11 = parse__();
                              if (result11 !== null) {
                                result12 = parse_TABLE_PROPERTIES();
                                if (result12 !== null) {
                                  result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12];
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, temp, props1, table, props2, columns, props) { 
              safeMergeObject(props, props1);
              safeMergeObject(props, props2);
              props.statement = "CREATE"; 
              props.what = "TABLE";
              props.schema = table.schema;
              props.table = table.table;
              if(temp) props.temporary = true;
              props.definitions = columns;
              return props;
            })(pos0, result0[1], result0[4], result0[5], result0[7], result0[9], result0[12]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_TABLE_PROPERTIES() {
        var cacheKey = "TABLE_PROPERTIES@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        pos1 = pos;
        pos2 = pos;
        if (input.substr(pos, 7).toLowerCase() === "default") {
          result0 = input.substr(pos, 7);
          pos += 7;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"DEFAULT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos2;
          }
        } else {
          result0 = null;
          pos = pos2;
        }
        result0 = result0 !== null ? result0 : "";
        if (result0 !== null) {
          if (input.substr(pos, 4).toLowerCase() === "char") {
            result1 = input.substr(pos, 4);
            pos += 4;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"CHAR\"");
            }
          }
          if (result1 !== null) {
            if (input.substr(pos, 5).toLowerCase() === "acter") {
              result2 = input.substr(pos, 5);
              pos += 5;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"ACTER\"");
              }
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              result3 = parse__();
              if (result3 === null) {
                if (input.charCodeAt(pos) === 95) {
                  result3 = "_";
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"_\"");
                  }
                }
              }
              if (result3 !== null) {
                if (input.substr(pos, 3).toLowerCase() === "set") {
                  result4 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"SET\"");
                  }
                }
                if (result4 !== null) {
                  pos2 = pos;
                  result5 = parse__();
                  if (result5 !== null) {
                    if (input.charCodeAt(pos) === 61) {
                      result6 = "=";
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"=\"");
                      }
                    }
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result5 = [result5, result6, result7];
                      } else {
                        result5 = null;
                        pos = pos2;
                      }
                    } else {
                      result5 = null;
                      pos = pos2;
                    }
                  } else {
                    result5 = null;
                    pos = pos2;
                  }
                  if (result5 === null) {
                    result5 = parse___();
                  }
                  if (result5 !== null) {
                    result6 = parse_ID();
                    if (result6 !== null) {
                      result7 = parse__();
                      if (result7 !== null) {
                        result8 = parse_TABLE_PROPERTIES();
                        if (result8 !== null) {
                          result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, charset, props) {
              props.charset = charset;
              return props;
            })(pos0, result0[6], result0[8]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          pos2 = pos;
          if (input.substr(pos, 7).toLowerCase() === "default") {
            result0 = input.substr(pos, 7);
            pos += 7;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"DEFAULT\"");
            }
          }
          if (result0 !== null) {
            result1 = parse___();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos2;
            }
          } else {
            result0 = null;
            pos = pos2;
          }
          result0 = result0 !== null ? result0 : "";
          if (result0 !== null) {
            if (input.substr(pos, 6).toLowerCase() === "collat") {
              result1 = input.substr(pos, 6);
              pos += 6;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"COLLAT\"");
              }
            }
            if (result1 !== null) {
              if (input.substr(pos, 1).toLowerCase() === "e") {
                result2 = input.substr(pos, 1);
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"E\"");
                }
              }
              if (result2 === null) {
                if (input.substr(pos, 3).toLowerCase() === "ion") {
                  result2 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"ION\"");
                  }
                }
              }
              if (result2 !== null) {
                pos2 = pos;
                result3 = parse__();
                if (result3 !== null) {
                  if (input.charCodeAt(pos) === 61) {
                    result4 = "=";
                    pos++;
                  } else {
                    result4 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"=\"");
                    }
                  }
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result3 = [result3, result4, result5];
                    } else {
                      result3 = null;
                      pos = pos2;
                    }
                  } else {
                    result3 = null;
                    pos = pos2;
                  }
                } else {
                  result3 = null;
                  pos = pos2;
                }
                if (result3 === null) {
                  result3 = parse___();
                }
                if (result3 !== null) {
                  result4 = parse_COLLATION_NAME();
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result6 = parse_TABLE_PROPERTIES();
                      if (result6 !== null) {
                        result0 = [result0, result1, result2, result3, result4, result5, result6];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, collate, props) {
                props.collate = collate;
                return props;
              })(pos0, result0[4], result0[6]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (input.substr(pos, 7).toLowerCase() === "comment") {
              result0 = input.substr(pos, 7);
              pos += 7;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"COMMENT\"");
              }
            }
            if (result0 !== null) {
              pos2 = pos;
              result1 = parse__();
              if (result1 !== null) {
                if (input.charCodeAt(pos) === 61) {
                  result2 = "=";
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"=\"");
                  }
                }
                if (result2 !== null) {
                  result3 = parse__();
                  if (result3 !== null) {
                    result1 = [result1, result2, result3];
                  } else {
                    result1 = null;
                    pos = pos2;
                  }
                } else {
                  result1 = null;
                  pos = pos2;
                }
              } else {
                result1 = null;
                pos = pos2;
              }
              if (result1 === null) {
                result1 = parse___();
              }
              if (result1 !== null) {
                result2 = parse_ID();
                if (result2 === null) {
                  result2 = parse_STRING();
                }
                if (result2 !== null) {
                  result3 = parse__();
                  if (result3 !== null) {
                    result4 = parse_TABLE_PROPERTIES();
                    if (result4 !== null) {
                      result0 = [result0, result1, result2, result3, result4];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, comment, props) {
                  props.comment = comment;
                  return props;
                })(pos0, result0[2], result0[4]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              pos1 = pos;
              if (input.substr(pos, 2).toLowerCase() === "if") {
                result0 = input.substr(pos, 2);
                pos += 2;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"IF\"");
                }
              }
              if (result0 !== null) {
                result1 = parse__();
                if (result1 !== null) {
                  if (input.substr(pos, 3).toLowerCase() === "not") {
                    result2 = input.substr(pos, 3);
                    pos += 3;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"NOT\"");
                    }
                  }
                  if (result2 !== null) {
                    result3 = parse__();
                    if (result3 !== null) {
                      if (input.substr(pos, 5) === "EXIST") {
                        result4 = "EXIST";
                        pos += 5;
                      } else {
                        result4 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"EXIST\"");
                        }
                      }
                      if (result4 !== null) {
                        if (input.substr(pos, 1).toLowerCase() === "s") {
                          result5 = input.substr(pos, 1);
                          pos++;
                        } else {
                          result5 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"S\"");
                          }
                        }
                        result5 = result5 !== null ? result5 : "";
                        if (result5 !== null) {
                          result6 = parse__();
                          if (result6 !== null) {
                            result7 = parse_TABLE_PROPERTIES();
                            if (result7 !== null) {
                              result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
              if (result0 !== null) {
                result0 = (function(offset, props) {
                    props.ifNotExists = true;
                    return props;
                  })(pos0, result0[7]);
              }
              if (result0 === null) {
                pos = pos0;
              }
              if (result0 === null) {
                pos0 = pos;
                pos1 = pos;
                if (input.substr(pos, 6).toLowerCase() === "engine") {
                  result0 = input.substr(pos, 6);
                  pos += 6;
                } else {
                  result0 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"ENGINE\"");
                  }
                }
                if (result0 !== null) {
                  pos2 = pos;
                  result1 = parse__();
                  if (result1 !== null) {
                    if (input.charCodeAt(pos) === 61) {
                      result2 = "=";
                      pos++;
                    } else {
                      result2 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"=\"");
                      }
                    }
                    if (result2 !== null) {
                      result3 = parse__();
                      if (result3 !== null) {
                        result1 = [result1, result2, result3];
                      } else {
                        result1 = null;
                        pos = pos2;
                      }
                    } else {
                      result1 = null;
                      pos = pos2;
                    }
                  } else {
                    result1 = null;
                    pos = pos2;
                  }
                  if (result1 === null) {
                    result1 = parse___();
                  }
                  if (result1 !== null) {
                    result2 = parse_ID();
                    if (result2 === null) {
                      result2 = parse_STRING();
                    }
                    if (result2 !== null) {
                      result3 = parse__();
                      if (result3 !== null) {
                        result4 = parse_TABLE_PROPERTIES();
                        if (result4 !== null) {
                          result0 = [result0, result1, result2, result3, result4];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
                if (result0 !== null) {
                  result0 = (function(offset, name, props) {
                      props.engine = name;
                      return props;
                    })(pos0, result0[2], result0[4]);
                }
                if (result0 === null) {
                  pos = pos0;
                }
                if (result0 === null) {
                  pos0 = pos;
                  pos1 = pos;
                  if (input.substr(pos, 4).toLowerCase() === "auto") {
                    result0 = input.substr(pos, 4);
                    pos += 4;
                  } else {
                    result0 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"AUTO\"");
                    }
                  }
                  if (result0 !== null) {
                    if (input.charCodeAt(pos) === 95) {
                      result1 = "_";
                      pos++;
                    } else {
                      result1 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"_\"");
                      }
                    }
                    if (result1 === null) {
                      result1 = parse__();
                    }
                    result1 = result1 !== null ? result1 : "";
                    if (result1 !== null) {
                      if (input.substr(pos, 3).toLowerCase() === "inc") {
                        result2 = input.substr(pos, 3);
                        pos += 3;
                      } else {
                        result2 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"INC\"");
                        }
                      }
                      if (result2 !== null) {
                        if (input.substr(pos, 6).toLowerCase() === "rement") {
                          result3 = input.substr(pos, 6);
                          pos += 6;
                        } else {
                          result3 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"REMENT\"");
                          }
                        }
                        if (result3 !== null) {
                          result4 = parse__();
                          if (result4 !== null) {
                            pos2 = pos;
                            result5 = parse__();
                            if (result5 !== null) {
                              if (input.charCodeAt(pos) === 61) {
                                result6 = "=";
                                pos++;
                              } else {
                                result6 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"=\"");
                                }
                              }
                              if (result6 !== null) {
                                result7 = parse__();
                                if (result7 !== null) {
                                  result5 = [result5, result6, result7];
                                } else {
                                  result5 = null;
                                  pos = pos2;
                                }
                              } else {
                                result5 = null;
                                pos = pos2;
                              }
                            } else {
                              result5 = null;
                              pos = pos2;
                            }
                            if (result5 === null) {
                              result5 = parse___();
                            }
                            if (result5 !== null) {
                              result6 = parse_CONSTANT_EXPRESSION();
                              if (result6 !== null) {
                                result7 = parse__();
                                if (result7 !== null) {
                                  result8 = parse_TABLE_PROPERTIES();
                                  if (result8 !== null) {
                                    result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                  if (result0 !== null) {
                    result0 = (function(offset, value, props) {
                        props.autoIncrement = value;
                        return props;
                      })(pos0, result0[6], result0[8]);
                  }
                  if (result0 === null) {
                    pos = pos0;
                  }
                  if (result0 === null) {
                    pos0 = pos;
                    result0 = parse__();
                    if (result0 !== null) {
                      result0 = (function(offset) { return {}; })(pos0);
                    }
                    if (result0 === null) {
                      pos = pos0;
                    }
                  }
                }
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_DEFINITIONS() {
        var cacheKey = "CREATE_DEFINITIONS@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = parse_CREATE_DEFINITION();
          if (result1 !== null) {
            result2 = [];
            pos2 = pos;
            pos3 = pos;
            result3 = parse__();
            if (result3 !== null) {
              if (input.charCodeAt(pos) === 44) {
                result4 = ",";
                pos++;
              } else {
                result4 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result4 !== null) {
                result5 = parse__();
                if (result5 !== null) {
                  result6 = parse_CREATE_DEFINITION();
                  if (result6 !== null) {
                    result3 = [result3, result4, result5, result6];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, col) { return col; })(pos2, result3[3]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            while (result3 !== null) {
              result2.push(result3);
              pos2 = pos;
              pos3 = pos;
              result3 = parse__();
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 44) {
                  result4 = ",";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_CREATE_DEFINITION();
                    if (result6 !== null) {
                      result3 = [result3, result4, result5, result6];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, col) { return col; })(pos2, result3[3]);
              }
              if (result3 === null) {
                pos = pos2;
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result4 = [];
                pos2 = pos;
                if (input.charCodeAt(pos) === 44) {
                  result5 = ",";
                  pos++;
                } else {
                  result5 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result5 !== null) {
                  result6 = parse__();
                  if (result6 !== null) {
                    result5 = [result5, result6];
                  } else {
                    result5 = null;
                    pos = pos2;
                  }
                } else {
                  result5 = null;
                  pos = pos2;
                }
                while (result5 !== null) {
                  result4.push(result5);
                  pos2 = pos;
                  if (input.charCodeAt(pos) === 44) {
                    result5 = ",";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\",\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result5 = [result5, result6];
                    } else {
                      result5 = null;
                      pos = pos2;
                    }
                  } else {
                    result5 = null;
                    pos = pos2;
                  }
                }
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, col, cols) { cols.unshift(col); return cols; })(pos0, result0[1], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          result0 = parse__();
          if (result0 !== null) {
            result0 = (function(offset) { return []; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_DEFINITION() {
        var cacheKey = "CREATE_DEFINITION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1;
        
        reportFailures++;
        result0 = parse_CREATE_DEFINITION_CONSTRAINT();
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse_ID_OR_STR();
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              result2 = parse_COLUMN_TYPE_PROPERTIES();
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, name, props) { props.name = name; return props; })(pos0, result0[0], result0[2]);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("column create definition");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CREATE_DEFINITION_CONSTRAINT() {
        var cacheKey = "CREATE_DEFINITION_CONSTRAINT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_CONSTRAINT_NAME_OPT();
        if (result0 !== null) {
          if (input.substr(pos, 7).toLowerCase() === "primary") {
            result1 = input.substr(pos, 7);
            pos += 7;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"PRIMARY\"");
            }
          }
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              pos2 = pos;
              if (input.substr(pos, 3).toLowerCase() === "key") {
                result3 = input.substr(pos, 3);
                pos += 3;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"KEY\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result3 = [result3, result4];
                } else {
                  result3 = null;
                  pos = pos2;
                }
              } else {
                result3 = null;
                pos = pos2;
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 40) {
                  result4 = "(";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"(\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_ID_LIST();
                    if (result6 !== null) {
                      if (input.charCodeAt(pos) === 41) {
                        result7 = ")";
                        pos++;
                      } else {
                        result7 = null;
                        if (reportFailures === 0) {
                          matchFailed("\")\"");
                        }
                      }
                      if (result7 !== null) {
                        result8 = parse__();
                        if (result8 !== null) {
                          result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, constraint_name, idlist) {
              return { 
                type: "CONSTRAINT", 
                constraint: "PRIMARY KEY", 
                constraintName:constraint_name, 
                columns: idlist
              };
            })(pos0, result0[0], result0[6]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse_CONSTRAINT_NAME_OPT();
          if (result0 !== null) {
            if (input.substr(pos, 7).toLowerCase() === "foreign") {
              result1 = input.substr(pos, 7);
              pos += 7;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"FOREIGN\"");
              }
            }
            if (result1 !== null) {
              result2 = parse__();
              if (result2 !== null) {
                pos2 = pos;
                if (input.substr(pos, 3).toLowerCase() === "key") {
                  result3 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"KEY\"");
                  }
                }
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    result3 = [result3, result4];
                  } else {
                    result3 = null;
                    pos = pos2;
                  }
                } else {
                  result3 = null;
                  pos = pos2;
                }
                result3 = result3 !== null ? result3 : "";
                if (result3 !== null) {
                  pos2 = pos;
                  result4 = parse_ID();
                  if (result4 === null) {
                    result4 = parse_STRING();
                  }
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result4 = [result4, result5];
                    } else {
                      result4 = null;
                      pos = pos2;
                    }
                  } else {
                    result4 = null;
                    pos = pos2;
                  }
                  result4 = result4 !== null ? result4 : "";
                  if (result4 !== null) {
                    if (input.charCodeAt(pos) === 40) {
                      result5 = "(";
                      pos++;
                    } else {
                      result5 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"(\"");
                      }
                    }
                    if (result5 !== null) {
                      result6 = parse__();
                      if (result6 !== null) {
                        result7 = parse_ID_LIST();
                        if (result7 !== null) {
                          if (input.charCodeAt(pos) === 41) {
                            result8 = ")";
                            pos++;
                          } else {
                            result8 = null;
                            if (reportFailures === 0) {
                              matchFailed("\")\"");
                            }
                          }
                          if (result8 !== null) {
                            result9 = parse__();
                            if (result9 !== null) {
                              result10 = parse_REFERENCE_DEFINITION();
                              if (result10 !== null) {
                                result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10];
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, constraint_name, idx_name, idlist, ref) {
                return { 
                  type: "CONSTRAINT", 
                  constraint: "FOREIGN KEY", 
                  constraintName:constraint_name,
                  indexName:idx_name,
                  columns: idlist,
                  references: ref
                };
              })(pos0, result0[0], result0[4], result0[7], result0[10]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (input.substr(pos, 6).toLowerCase() === "unique") {
              result0 = input.substr(pos, 6);
              pos += 6;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"UNIQUE\"");
              }
            }
            if (result0 !== null) {
              result1 = parse___();
              if (result1 !== null) {
                if (input.substr(pos, 3).toLowerCase() === "key") {
                  result2 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"KEY\"");
                  }
                }
                if (result2 === null) {
                  if (input.substr(pos, 5).toLowerCase() === "index") {
                    result2 = input.substr(pos, 5);
                    pos += 5;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"INDEX\"");
                    }
                  }
                }
                result2 = result2 !== null ? result2 : "";
                if (result2 !== null) {
                  pos2 = pos;
                  pos3 = pos;
                  result3 = parse___();
                  if (result3 !== null) {
                    result4 = parse_ID();
                    if (result4 === null) {
                      result4 = parse_STRING();
                    }
                    if (result4 !== null) {
                      result3 = [result3, result4];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                  if (result3 !== null) {
                    result3 = (function(offset, name) {return name;})(pos2, result3[1]);
                  }
                  if (result3 === null) {
                    pos = pos2;
                  }
                  result3 = result3 !== null ? result3 : "";
                  if (result3 !== null) {
                    result4 = parse__();
                    if (result4 !== null) {
                      if (input.charCodeAt(pos) === 40) {
                        result5 = "(";
                        pos++;
                      } else {
                        result5 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"(\"");
                        }
                      }
                      if (result5 !== null) {
                        result6 = parse__();
                        if (result6 !== null) {
                          result7 = parse_ID_LIST();
                          if (result7 !== null) {
                            if (input.charCodeAt(pos) === 41) {
                              result8 = ")";
                              pos++;
                            } else {
                              result8 = null;
                              if (reportFailures === 0) {
                                matchFailed("\")\"");
                              }
                            }
                            if (result8 !== null) {
                              result9 = parse__();
                              if (result9 !== null) {
                                result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9];
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, type, name, idlist) {
                  var key = {
                    type: "CONSTRAINT",
                    constraint: (type ? type.toUpperCase() : 'INDEX'),
                    unique: true,
                    columns: idlist
                  };
                  if(name)
                    key.name = name;
                  return key;
                })(pos0, result0[2], result0[3], result0[7]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              pos1 = pos;
              pos2 = pos;
              if (input.substr(pos, 6).toLowerCase() === "unique") {
                result0 = input.substr(pos, 6);
                pos += 6;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"UNIQUE\"");
                }
              }
              if (result0 !== null) {
                result1 = parse___();
                if (result1 !== null) {
                  result0 = [result0, result1];
                } else {
                  result0 = null;
                  pos = pos2;
                }
              } else {
                result0 = null;
                pos = pos2;
              }
              result0 = result0 !== null ? result0 : "";
              if (result0 !== null) {
                if (input.substr(pos, 3).toLowerCase() === "key") {
                  result1 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result1 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"KEY\"");
                  }
                }
                if (result1 === null) {
                  if (input.substr(pos, 5).toLowerCase() === "index") {
                    result1 = input.substr(pos, 5);
                    pos += 5;
                  } else {
                    result1 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"INDEX\"");
                    }
                  }
                }
                if (result1 !== null) {
                  pos2 = pos;
                  pos3 = pos;
                  result2 = parse___();
                  if (result2 !== null) {
                    result3 = parse_ID();
                    if (result3 === null) {
                      result3 = parse_STRING();
                    }
                    if (result3 !== null) {
                      result2 = [result2, result3];
                    } else {
                      result2 = null;
                      pos = pos3;
                    }
                  } else {
                    result2 = null;
                    pos = pos3;
                  }
                  if (result2 !== null) {
                    result2 = (function(offset, name) {return name;})(pos2, result2[1]);
                  }
                  if (result2 === null) {
                    pos = pos2;
                  }
                  result2 = result2 !== null ? result2 : "";
                  if (result2 !== null) {
                    result3 = parse__();
                    if (result3 !== null) {
                      if (input.charCodeAt(pos) === 40) {
                        result4 = "(";
                        pos++;
                      } else {
                        result4 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"(\"");
                        }
                      }
                      if (result4 !== null) {
                        result5 = parse__();
                        if (result5 !== null) {
                          result6 = parse_ID_LIST();
                          if (result6 !== null) {
                            if (input.charCodeAt(pos) === 41) {
                              result7 = ")";
                              pos++;
                            } else {
                              result7 = null;
                              if (reportFailures === 0) {
                                matchFailed("\")\"");
                              }
                            }
                            if (result7 !== null) {
                              result8 = parse__();
                              if (result8 !== null) {
                                result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
              if (result0 !== null) {
                result0 = (function(offset, unique, type, name, idlist) {
                    var key = {
                      type: "CONSTRAINT",
                      constraint: type.toUpperCase(),
                      unique: !!unique,
                      columns: idlist
                    };
                    if(name)
                      key.name = name;
                    return key;
                  })(pos0, result0[0], result0[1], result0[2], result0[6]);
              }
              if (result0 === null) {
                pos = pos0;
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CONSTRAINT_NAME_OPT() {
        var cacheKey = "CONSTRAINT_NAME_OPT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 10).toLowerCase() === "constraint") {
          result0 = input.substr(pos, 10);
          pos += 10;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"CONSTRAINT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            pos2 = pos;
            reportFailures++;
            if (input.substr(pos, 7).toLowerCase() === "primary") {
              result2 = input.substr(pos, 7);
              pos += 7;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"PRIMARY\"");
              }
            }
            if (result2 === null) {
              if (input.substr(pos, 7).toLowerCase() === "foreign") {
                result2 = input.substr(pos, 7);
                pos += 7;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"FOREIGN\"");
                }
              }
              if (result2 === null) {
                if (input.substr(pos, 3).toLowerCase() === "key") {
                  result2 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"KEY\"");
                  }
                }
                if (result2 === null) {
                  if (input.substr(pos, 5).toLowerCase() === "index") {
                    result2 = input.substr(pos, 5);
                    pos += 5;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"INDEX\"");
                    }
                  }
                  if (result2 === null) {
                    if (input.substr(pos, 6).toLowerCase() === "unique") {
                      result2 = input.substr(pos, 6);
                      pos += 6;
                    } else {
                      result2 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"UNIQUE\"");
                      }
                    }
                  }
                }
              }
            }
            reportFailures--;
            if (result2 === null) {
              result2 = "";
            } else {
              result2 = null;
              pos = pos2;
            }
            if (result2 !== null) {
              result3 = parse_ID();
              if (result3 === null) {
                result3 = parse_STRING();
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, name) { return name; })(pos0, result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.substr(pos, 10).toLowerCase() === "constraint") {
            result0 = input.substr(pos, 10);
            pos += 10;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"CONSTRAINT\"");
            }
          }
          if (result0 !== null) {
            result1 = parse___();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset) { return true; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            result0 = [];
            if (result0 !== null) {
              result0 = (function(offset) { })(pos0);
            }
            if (result0 === null) {
              pos = pos0;
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ID_LIST() {
        var cacheKey = "ID_LIST@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_ID();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = [];
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 44) {
              result3 = ",";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\",\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_ID();
                if (result5 !== null) {
                  result6 = parse__();
                  if (result6 !== null) {
                    result3 = [result3, result4, result5, result6];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, id2) { return id2; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            while (result3 !== null) {
              result2.push(result3);
              pos2 = pos;
              pos3 = pos;
              if (input.charCodeAt(pos) === 44) {
                result3 = ",";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_ID();
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result3 = [result3, result4, result5, result6];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, id2) { return id2; })(pos2, result3[2]);
              }
              if (result3 === null) {
                pos = pos2;
              }
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, id, rest) { rest.unshift(id); return rest; })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_STRING_ID_LIST() {
        var cacheKey = "STRING_ID_LIST@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_STRING();
        if (result0 === null) {
          result0 = parse_ID();
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = [];
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 44) {
              result3 = ",";
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("\",\"");
              }
            }
            if (result3 !== null) {
              result4 = parse__();
              if (result4 !== null) {
                result5 = parse_STRING();
                if (result5 === null) {
                  result5 = parse_ID();
                }
                if (result5 !== null) {
                  result6 = parse__();
                  if (result6 !== null) {
                    result3 = [result3, result4, result5, result6];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, id2) { return id2; })(pos2, result3[2]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            while (result3 !== null) {
              result2.push(result3);
              pos2 = pos;
              pos3 = pos;
              if (input.charCodeAt(pos) === 44) {
                result3 = ",";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_STRING();
                  if (result5 === null) {
                    result5 = parse_ID();
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result3 = [result3, result4, result5, result6];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, id2) { return id2; })(pos2, result3[2]);
              }
              if (result3 === null) {
                pos = pos2;
              }
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, id, rest) { rest.unshift(id); return rest; })(pos0, result0[0], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_NUMERIC_TYPE_LENGTH() {
        var cacheKey = "NUMERIC_TYPE_LENGTH@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          if (input.charCodeAt(pos) === 40) {
            result1 = "(";
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"(\"");
            }
          }
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              result3 = parse_POSITIVE_INTEGER();
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 44) {
                    result5 = ",";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\",\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_POSITIVE_INTEGER();
                      if (result7 !== null) {
                        result8 = parse__();
                        if (result8 !== null) {
                          if (input.charCodeAt(pos) === 41) {
                            result9 = ")";
                            pos++;
                          } else {
                            result9 = null;
                            if (reportFailures === 0) {
                              matchFailed("\")\"");
                            }
                          }
                          if (result9 !== null) {
                            result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9];
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, length, decimals) {
              return { length: length, decimals: decimals };
            })(pos0, result0[3], result0[7]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse__();
          if (result0 !== null) {
            if (input.charCodeAt(pos) === 40) {
              result1 = "(";
              pos++;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"(\"");
              }
            }
            if (result1 !== null) {
              result2 = parse__();
              if (result2 !== null) {
                result3 = parse_POSITIVE_INTEGER();
                if (result3 !== null) {
                  result4 = parse__();
                  if (result4 !== null) {
                    if (input.charCodeAt(pos) === 41) {
                      result5 = ")";
                      pos++;
                    } else {
                      result5 = null;
                      if (reportFailures === 0) {
                        matchFailed("\")\"");
                      }
                    }
                    if (result5 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, length) {
                return { length: length, decimals: 0 };
              })(pos0, result0[3]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            result0 = [];
            if (result0 !== null) {
              result0 = (function(offset) { return {}; })(pos0);
            }
            if (result0 === null) {
              pos = pos0;
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_TYPE_LENGTH() {
        var cacheKey = "TYPE_LENGTH@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          if (input.charCodeAt(pos) === 40) {
            result1 = "(";
            pos++;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"(\"");
            }
          }
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              result3 = parse_POSITIVE_INTEGER();
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 41) {
                    result5 = ")";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\")\"");
                    }
                  }
                  if (result5 !== null) {
                    result0 = [result0, result1, result2, result3, result4, result5];
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, length) {
              return length;
            })(pos0, result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_COLUMN_TYPE_PROPERTIES() {
        var cacheKey = "COLUMN_TYPE_PROPERTIES@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          if (input.substr(pos, 4).toLowerCase() === "tiny") {
            result1 = input.substr(pos, 4);
            pos += 4;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"TINY\"");
            }
          }
          if (result1 === null) {
            if (input.substr(pos, 5).toLowerCase() === "small") {
              result1 = input.substr(pos, 5);
              pos += 5;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"SMALL\"");
              }
            }
            if (result1 === null) {
              if (input.substr(pos, 6).toLowerCase() === "medium") {
                result1 = input.substr(pos, 6);
                pos += 6;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("\"MEDIUM\"");
                }
              }
              if (result1 === null) {
                if (input.substr(pos, 3).toLowerCase() === "big") {
                  result1 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result1 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"BIG\"");
                  }
                }
              }
            }
          }
          result1 = result1 !== null ? result1 : "";
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              if (input.substr(pos, 3).toLowerCase() === "int") {
                result3 = input.substr(pos, 3);
                pos += 3;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"INT\"");
                }
              }
              if (result3 !== null) {
                if (input.substr(pos, 4).toLowerCase() === "eger") {
                  result4 = input.substr(pos, 4);
                  pos += 4;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"EGER\"");
                  }
                }
                result4 = result4 !== null ? result4 : "";
                if (result4 !== null) {
                  result5 = parse_TYPE_LENGTH();
                  if (result5 !== null) {
                    result6 = parse_COLUMN_TYPE_PROPERTIES();
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, prefix, length, props) {
              if(props.type)
                throw new SyntaxError("Ambiguous type");
              props.type = prefix ? prefix.toUpperCase()+'INT' : 'INT';
              if(length) props.length = length;
              return props;
            })(pos0, result0[1], result0[5], result0[6]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse__();
          if (result0 !== null) {
            pos2 = pos;
            if (input.substr(pos, 3).toLowerCase() === "num") {
              result1 = input.substr(pos, 3);
              pos += 3;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"NUM\"");
              }
            }
            if (result1 !== null) {
              if (input.substr(pos, 4).toLowerCase() === "eric") {
                result2 = input.substr(pos, 4);
                pos += 4;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"ERIC\"");
                }
              }
              if (result2 === null) {
                if (input.substr(pos, 3).toLowerCase() === "ber") {
                  result2 = input.substr(pos, 3);
                  pos += 3;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"BER\"");
                  }
                }
              }
              result2 = result2 !== null ? result2 : "";
              if (result2 !== null) {
                result1 = [result1, result2];
              } else {
                result1 = null;
                pos = pos2;
              }
            } else {
              result1 = null;
              pos = pos2;
            }
            if (result1 === null) {
              pos2 = pos;
              if (input.substr(pos, 3).toLowerCase() === "dec") {
                result1 = input.substr(pos, 3);
                pos += 3;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("\"DEC\"");
                }
              }
              if (result1 !== null) {
                if (input.substr(pos, 4).toLowerCase() === "imal") {
                  result2 = input.substr(pos, 4);
                  pos += 4;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"IMAL\"");
                  }
                }
                result2 = result2 !== null ? result2 : "";
                if (result2 !== null) {
                  result1 = [result1, result2];
                } else {
                  result1 = null;
                  pos = pos2;
                }
              } else {
                result1 = null;
                pos = pos2;
              }
            }
            if (result1 !== null) {
              result2 = parse_NUMERIC_TYPE_LENGTH();
              if (result2 !== null) {
                result3 = parse_COLUMN_TYPE_PROPERTIES();
                if (result3 !== null) {
                  result0 = [result0, result1, result2, result3];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, length, props) {
                if(props.type)
                  throw new SyntaxError("Ambiguous type");
                props.type = 'DECIMAL';
                if(length.length) props.length = length.length;
                if(length.decimals) props.decimals = length.decimals;
                return props;
              })(pos0, result0[2], result0[3]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            result0 = parse__();
            if (result0 !== null) {
              if (input.substr(pos, 6).toLowerCase() === "double") {
                result1 = input.substr(pos, 6);
                pos += 6;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("\"DOUBLE\"");
                }
              }
              if (result1 === null) {
                if (input.substr(pos, 5).toLowerCase() === "float") {
                  result1 = input.substr(pos, 5);
                  pos += 5;
                } else {
                  result1 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"FLOAT\"");
                  }
                }
                if (result1 === null) {
                  if (input.substr(pos, 4).toLowerCase() === "real") {
                    result1 = input.substr(pos, 4);
                    pos += 4;
                  } else {
                    result1 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"REAL\"");
                    }
                  }
                }
              }
              if (result1 !== null) {
                result2 = parse_NUMERIC_TYPE_LENGTH();
                if (result2 !== null) {
                  result3 = parse_COLUMN_TYPE_PROPERTIES();
                  if (result3 !== null) {
                    result0 = [result0, result1, result2, result3];
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, type, length, props) {
                  if(props.type)
                    throw new SyntaxError("Ambiguous type");
                  props.type = type.toUpperCase();
                  if(length.length) props.length = length.length;
                  if(length.decimals) props.decimals = length.decimals;
                  return props;
                })(pos0, result0[1], result0[2], result0[3]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              pos1 = pos;
              result0 = parse__();
              if (result0 !== null) {
                if (input.substr(pos, 7).toLowerCase() === "varchar") {
                  result1 = input.substr(pos, 7);
                  pos += 7;
                } else {
                  result1 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"VARCHAR\"");
                  }
                }
                if (result1 === null) {
                  pos2 = pos;
                  if (input.substr(pos, 9).toLowerCase() === "character") {
                    result1 = input.substr(pos, 9);
                    pos += 9;
                  } else {
                    result1 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"CHARACTER\"");
                    }
                  }
                  if (result1 !== null) {
                    result2 = parse___();
                    if (result2 !== null) {
                      if (input.substr(pos, 7).toLowerCase() === "varying") {
                        result3 = input.substr(pos, 7);
                        pos += 7;
                      } else {
                        result3 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"VARYING\"");
                        }
                      }
                      if (result3 !== null) {
                        result1 = [result1, result2, result3];
                      } else {
                        result1 = null;
                        pos = pos2;
                      }
                    } else {
                      result1 = null;
                      pos = pos2;
                    }
                  } else {
                    result1 = null;
                    pos = pos2;
                  }
                }
                if (result1 !== null) {
                  result2 = parse_TYPE_LENGTH();
                  if (result2 !== null) {
                    result3 = parse_COLUMN_TYPE_PROPERTIES();
                    if (result3 !== null) {
                      result0 = [result0, result1, result2, result3];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
              if (result0 !== null) {
                result0 = (function(offset, length, props) {
                    if(props.type)
                      throw new SyntaxError("Ambiguous type");
                    props.type = 'VARCHAR';
                    if(length) props.length = length;
                    return props;
                  })(pos0, result0[2], result0[3]);
              }
              if (result0 === null) {
                pos = pos0;
              }
              if (result0 === null) {
                pos0 = pos;
                pos1 = pos;
                result0 = parse__();
                if (result0 !== null) {
                  if (input.substr(pos, 4).toLowerCase() === "char") {
                    result1 = input.substr(pos, 4);
                    pos += 4;
                  } else {
                    result1 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"CHAR\"");
                    }
                  }
                  if (result1 === null) {
                    if (input.substr(pos, 9).toLowerCase() === "character") {
                      result1 = input.substr(pos, 9);
                      pos += 9;
                    } else {
                      result1 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"CHARACTER\"");
                      }
                    }
                  }
                  if (result1 !== null) {
                    result2 = parse_TYPE_LENGTH();
                    if (result2 !== null) {
                      result3 = parse_COLUMN_TYPE_PROPERTIES();
                      if (result3 !== null) {
                        result0 = [result0, result1, result2, result3];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
                if (result0 !== null) {
                  result0 = (function(offset, length, props) {
                      if(props.type)
                        throw new SyntaxError("Ambiguous type");
                      props.type = 'CHAR';
                      if(length) props.length = length;
                      return props;
                    })(pos0, result0[2], result0[3]);
                }
                if (result0 === null) {
                  pos = pos0;
                }
                if (result0 === null) {
                  pos0 = pos;
                  pos1 = pos;
                  result0 = parse__();
                  if (result0 !== null) {
                    pos2 = pos;
                    if (input.substr(pos, 4).toLowerCase() === "tiny") {
                      result1 = input.substr(pos, 4);
                      pos += 4;
                    } else {
                      result1 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"TINY\"");
                      }
                    }
                    if (result1 === null) {
                      if (input.substr(pos, 6).toLowerCase() === "medium") {
                        result1 = input.substr(pos, 6);
                        pos += 6;
                      } else {
                        result1 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"MEDIUM\"");
                        }
                      }
                      if (result1 === null) {
                        if (input.substr(pos, 4).toLowerCase() === "long") {
                          result1 = input.substr(pos, 4);
                          pos += 4;
                        } else {
                          result1 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"LONG\"");
                          }
                        }
                      }
                    }
                    if (result1 !== null) {
                      result2 = parse__();
                      if (result2 !== null) {
                        result1 = [result1, result2];
                      } else {
                        result1 = null;
                        pos = pos2;
                      }
                    } else {
                      result1 = null;
                      pos = pos2;
                    }
                    result1 = result1 !== null ? result1 : "";
                    if (result1 !== null) {
                      if (input.substr(pos, 4).toLowerCase() === "text") {
                        result2 = input.substr(pos, 4);
                        pos += 4;
                      } else {
                        result2 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"TEXT\"");
                        }
                      }
                      if (result2 !== null) {
                        result3 = parse_COLUMN_TYPE_PROPERTIES();
                        if (result3 !== null) {
                          result0 = [result0, result1, result2, result3];
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                  if (result0 !== null) {
                    result0 = (function(offset, props) {
                        if(props.type)
                          throw new SyntaxError("Ambiguous type");
                        props.type = typeof prefix !== 'undefined' ? prefix.toUpperCase()+'TEXT' : 'TEXT';
                        return props;
                      })(pos0, result0[3]);
                  }
                  if (result0 === null) {
                    pos = pos0;
                  }
                  if (result0 === null) {
                    pos0 = pos;
                    pos1 = pos;
                    result0 = parse__();
                    if (result0 !== null) {
                      if (input.substr(pos, 8).toLowerCase() === "datetime") {
                        result1 = input.substr(pos, 8);
                        pos += 8;
                      } else {
                        result1 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"DATETIME\"");
                        }
                      }
                      if (result1 === null) {
                        if (input.substr(pos, 4).toLowerCase() === "date") {
                          result1 = input.substr(pos, 4);
                          pos += 4;
                        } else {
                          result1 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"DATE\"");
                          }
                        }
                        if (result1 === null) {
                          if (input.substr(pos, 9).toLowerCase() === "timestamp") {
                            result1 = input.substr(pos, 9);
                            pos += 9;
                          } else {
                            result1 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"TIMESTAMP\"");
                            }
                          }
                          if (result1 === null) {
                            if (input.substr(pos, 4).toLowerCase() === "time") {
                              result1 = input.substr(pos, 4);
                              pos += 4;
                            } else {
                              result1 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"TIME\"");
                              }
                            }
                            if (result1 === null) {
                              if (input.substr(pos, 4).toLowerCase() === "year") {
                                result1 = input.substr(pos, 4);
                                pos += 4;
                              } else {
                                result1 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"YEAR\"");
                                }
                              }
                            }
                          }
                        }
                      }
                      if (result1 !== null) {
                        result2 = parse_TYPE_LENGTH();
                        if (result2 !== null) {
                          result3 = parse__();
                          if (result3 !== null) {
                            result4 = parse_COLUMN_TYPE_PROPERTIES();
                            if (result4 !== null) {
                              result0 = [result0, result1, result2, result3, result4];
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                    if (result0 !== null) {
                      result0 = (function(offset, type, length, props) {
                          if(props.type)
                            throw new SyntaxError("Ambiguous type");
                          props.type = type.toUpperCase();
                          if(length) props.length = length;
                          return props;      
                        })(pos0, result0[1], result0[2], result0[4]);
                    }
                    if (result0 === null) {
                      pos = pos0;
                    }
                    if (result0 === null) {
                      pos0 = pos;
                      pos1 = pos;
                      result0 = parse__();
                      if (result0 !== null) {
                        if (input.substr(pos, 4).toLowerCase() === "enum") {
                          result1 = input.substr(pos, 4);
                          pos += 4;
                        } else {
                          result1 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"ENUM\"");
                          }
                        }
                        if (result1 !== null) {
                          result2 = parse__();
                          if (result2 !== null) {
                            if (input.charCodeAt(pos) === 40) {
                              result3 = "(";
                              pos++;
                            } else {
                              result3 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"(\"");
                              }
                            }
                            if (result3 !== null) {
                              result4 = parse_STRING_ID_LIST();
                              if (result4 !== null) {
                                if (input.charCodeAt(pos) === 41) {
                                  result5 = ")";
                                  pos++;
                                } else {
                                  result5 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\")\"");
                                  }
                                }
                                if (result5 !== null) {
                                  result6 = parse__();
                                  if (result6 !== null) {
                                    result7 = parse_COLUMN_TYPE_PROPERTIES();
                                    if (result7 !== null) {
                                      result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                      if (result0 !== null) {
                        result0 = (function(offset, values, props) {
                            if(props.type)
                              throw new SyntaxError("Ambiguous type");
                            props.type = 'ENUM';
                            props.values = values;
                            return props;
                          })(pos0, result0[4], result0[7]);
                      }
                      if (result0 === null) {
                        pos = pos0;
                      }
                      if (result0 === null) {
                        pos0 = pos;
                        pos1 = pos;
                        result0 = parse__();
                        if (result0 !== null) {
                          if (input.substr(pos, 8).toLowerCase() === "unsigned") {
                            result1 = input.substr(pos, 8);
                            pos += 8;
                          } else {
                            result1 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"UNSIGNED\"");
                            }
                          }
                          if (result1 !== null) {
                            result2 = parse__();
                            if (result2 !== null) {
                              result3 = parse_COLUMN_TYPE_PROPERTIES();
                              if (result3 !== null) {
                                result0 = [result0, result1, result2, result3];
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                        if (result0 !== null) {
                          result0 = (function(offset, props) {
                                props.unsigned=true;
                                return props; 
                              })(pos0, result0[3]);
                        }
                        if (result0 === null) {
                          pos = pos0;
                        }
                        if (result0 === null) {
                          pos0 = pos;
                          pos1 = pos;
                          result0 = parse__();
                          if (result0 !== null) {
                            if (input.substr(pos, 6).toLowerCase() === "signed") {
                              result1 = input.substr(pos, 6);
                              pos += 6;
                            } else {
                              result1 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"SIGNED\"");
                              }
                            }
                            if (result1 !== null) {
                              result2 = parse__();
                              if (result2 !== null) {
                                result3 = parse_COLUMN_TYPE_PROPERTIES();
                                if (result3 !== null) {
                                  result0 = [result0, result1, result2, result3];
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                          if (result0 !== null) {
                            result0 = (function(offset, props) {
                                  props.signed=true;
                                  return props; 
                                })(pos0, result0[3]);
                          }
                          if (result0 === null) {
                            pos = pos0;
                          }
                          if (result0 === null) {
                            pos0 = pos;
                            pos1 = pos;
                            result0 = parse__();
                            if (result0 !== null) {
                              if (input.substr(pos, 3).toLowerCase() === "not") {
                                result1 = input.substr(pos, 3);
                                pos += 3;
                              } else {
                                result1 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"NOT\"");
                                }
                              }
                              if (result1 !== null) {
                                result2 = parse__();
                                if (result2 !== null) {
                                  if (input.substr(pos, 4).toLowerCase() === "null") {
                                    result3 = input.substr(pos, 4);
                                    pos += 4;
                                  } else {
                                    result3 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"NULL\"");
                                    }
                                  }
                                  if (result3 !== null) {
                                    result4 = parse__();
                                    if (result4 !== null) {
                                      result5 = parse_COLUMN_TYPE_PROPERTIES();
                                      if (result5 !== null) {
                                        result0 = [result0, result1, result2, result3, result4, result5];
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                            if (result0 !== null) {
                              result0 = (function(offset, props) {
                                  if(typeof props.notNull !== 'undefined')
                                    throw new Error('NULL or NOT NULL?');
                                  props.notNull=true;
                                  return props; 
                                })(pos0, result0[5]);
                            }
                            if (result0 === null) {
                              pos = pos0;
                            }
                            if (result0 === null) {
                              pos0 = pos;
                              pos1 = pos;
                              result0 = parse__();
                              if (result0 !== null) {
                                if (input.substr(pos, 4).toLowerCase() === "null") {
                                  result1 = input.substr(pos, 4);
                                  pos += 4;
                                } else {
                                  result1 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\"NULL\"");
                                  }
                                }
                                if (result1 !== null) {
                                  result2 = parse_COLUMN_TYPE_PROPERTIES();
                                  if (result2 !== null) {
                                    result0 = [result0, result1, result2];
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                              if (result0 !== null) {
                                result0 = (function(offset, props) {
                                    if(typeof props.notNull !== 'undefined')
                                      throw new Error('NULL or NOT NULL?');
                                    props.notNull=false;
                                    return props;
                                  })(pos0, result0[2]);
                              }
                              if (result0 === null) {
                                pos = pos0;
                              }
                              if (result0 === null) {
                                pos0 = pos;
                                pos1 = pos;
                                result0 = parse__();
                                if (result0 !== null) {
                                  if (input.substr(pos, 7).toLowerCase() === "primary") {
                                    result1 = input.substr(pos, 7);
                                    pos += 7;
                                  } else {
                                    result1 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"PRIMARY\"");
                                    }
                                  }
                                  if (result1 !== null) {
                                    pos2 = pos;
                                    result2 = parse__();
                                    if (result2 !== null) {
                                      if (input.substr(pos, 3).toLowerCase() === "key") {
                                        result3 = input.substr(pos, 3);
                                        pos += 3;
                                      } else {
                                        result3 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"KEY\"");
                                        }
                                      }
                                      if (result3 !== null) {
                                        result2 = [result2, result3];
                                      } else {
                                        result2 = null;
                                        pos = pos2;
                                      }
                                    } else {
                                      result2 = null;
                                      pos = pos2;
                                    }
                                    result2 = result2 !== null ? result2 : "";
                                    if (result2 !== null) {
                                      result3 = parse__();
                                      if (result3 !== null) {
                                        result4 = parse_COLUMN_TYPE_PROPERTIES();
                                        if (result4 !== null) {
                                          result0 = [result0, result1, result2, result3, result4];
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result0 = null;
                                  pos = pos1;
                                }
                                if (result0 !== null) {
                                  result0 = (function(offset, props) {
                                      props.primaryKey=true;
                                      return props;
                                    })(pos0, result0[4]);
                                }
                                if (result0 === null) {
                                  pos = pos0;
                                }
                                if (result0 === null) {
                                  pos0 = pos;
                                  pos1 = pos;
                                  result0 = parse__();
                                  if (result0 !== null) {
                                    if (input.substr(pos, 4).toLowerCase() === "uniq") {
                                      result1 = input.substr(pos, 4);
                                      pos += 4;
                                    } else {
                                      result1 = null;
                                      if (reportFailures === 0) {
                                        matchFailed("\"UNIQ\"");
                                      }
                                    }
                                    if (result1 !== null) {
                                      if (input.substr(pos, 2).toLowerCase() === "ue") {
                                        result2 = input.substr(pos, 2);
                                        pos += 2;
                                      } else {
                                        result2 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"UE\"");
                                        }
                                      }
                                      result2 = result2 !== null ? result2 : "";
                                      if (result2 !== null) {
                                        result3 = parse__();
                                        if (result3 !== null) {
                                          result4 = parse_COLUMN_TYPE_PROPERTIES();
                                          if (result4 !== null) {
                                            result0 = [result0, result1, result2, result3, result4];
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result0 = null;
                                    pos = pos1;
                                  }
                                  if (result0 !== null) {
                                    result0 = (function(offset, props) {
                                        props.unique=true;
                                        return props;
                                      })(pos0, result0[4]);
                                  }
                                  if (result0 === null) {
                                    pos = pos0;
                                  }
                                  if (result0 === null) {
                                    pos0 = pos;
                                    pos1 = pos;
                                    result0 = parse__();
                                    if (result0 !== null) {
                                      if (input.substr(pos, 4).toLowerCase() === "auto") {
                                        result1 = input.substr(pos, 4);
                                        pos += 4;
                                      } else {
                                        result1 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"AUTO\"");
                                        }
                                      }
                                      if (result1 !== null) {
                                        if (input.charCodeAt(pos) === 95) {
                                          result2 = "_";
                                          pos++;
                                        } else {
                                          result2 = null;
                                          if (reportFailures === 0) {
                                            matchFailed("\"_\"");
                                          }
                                        }
                                        if (result2 === null) {
                                          result2 = parse__();
                                        }
                                        if (result2 !== null) {
                                          if (input.substr(pos, 3).toLowerCase() === "inc") {
                                            result3 = input.substr(pos, 3);
                                            pos += 3;
                                          } else {
                                            result3 = null;
                                            if (reportFailures === 0) {
                                              matchFailed("\"INC\"");
                                            }
                                          }
                                          if (result3 !== null) {
                                            if (input.substr(pos, 6).toLowerCase() === "rement") {
                                              result4 = input.substr(pos, 6);
                                              pos += 6;
                                            } else {
                                              result4 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\"REMENT\"");
                                              }
                                            }
                                            result4 = result4 !== null ? result4 : "";
                                            if (result4 !== null) {
                                              result5 = parse__();
                                              if (result5 !== null) {
                                                result6 = parse_COLUMN_TYPE_PROPERTIES();
                                                if (result6 !== null) {
                                                  result0 = [result0, result1, result2, result3, result4, result5, result6];
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result0 = null;
                                              pos = pos1;
                                            }
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result0 = null;
                                      pos = pos1;
                                    }
                                    if (result0 !== null) {
                                      result0 = (function(offset, props) {
                                          props.autoIncrement=true;
                                          return props;
                                        })(pos0, result0[6]);
                                    }
                                    if (result0 === null) {
                                      pos = pos0;
                                    }
                                    if (result0 === null) {
                                      pos0 = pos;
                                      pos1 = pos;
                                      result0 = parse__();
                                      if (result0 !== null) {
                                        if (input.substr(pos, 6).toLowerCase() === "collat") {
                                          result1 = input.substr(pos, 6);
                                          pos += 6;
                                        } else {
                                          result1 = null;
                                          if (reportFailures === 0) {
                                            matchFailed("\"COLLAT\"");
                                          }
                                        }
                                        if (result1 !== null) {
                                          if (input.substr(pos, 1).toLowerCase() === "e") {
                                            result2 = input.substr(pos, 1);
                                            pos++;
                                          } else {
                                            result2 = null;
                                            if (reportFailures === 0) {
                                              matchFailed("\"E\"");
                                            }
                                          }
                                          if (result2 === null) {
                                            if (input.substr(pos, 3).toLowerCase() === "ion") {
                                              result2 = input.substr(pos, 3);
                                              pos += 3;
                                            } else {
                                              result2 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\"ION\"");
                                              }
                                            }
                                          }
                                          if (result2 !== null) {
                                            pos2 = pos;
                                            result3 = parse__();
                                            if (result3 !== null) {
                                              if (input.charCodeAt(pos) === 61) {
                                                result4 = "=";
                                                pos++;
                                              } else {
                                                result4 = null;
                                                if (reportFailures === 0) {
                                                  matchFailed("\"=\"");
                                                }
                                              }
                                              if (result4 !== null) {
                                                result5 = parse__();
                                                if (result5 !== null) {
                                                  result3 = [result3, result4, result5];
                                                } else {
                                                  result3 = null;
                                                  pos = pos2;
                                                }
                                              } else {
                                                result3 = null;
                                                pos = pos2;
                                              }
                                            } else {
                                              result3 = null;
                                              pos = pos2;
                                            }
                                            if (result3 === null) {
                                              result3 = parse___();
                                            }
                                            if (result3 !== null) {
                                              result4 = parse_COLLATION_NAME();
                                              if (result4 !== null) {
                                                result5 = parse__();
                                                if (result5 !== null) {
                                                  result6 = parse_COLUMN_TYPE_PROPERTIES();
                                                  if (result6 !== null) {
                                                    result0 = [result0, result1, result2, result3, result4, result5, result6];
                                                  } else {
                                                    result0 = null;
                                                    pos = pos1;
                                                  }
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result0 = null;
                                              pos = pos1;
                                            }
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result0 = null;
                                        pos = pos1;
                                      }
                                      if (result0 !== null) {
                                        result0 = (function(offset, collate, props) {
                                            props.collate = collate;
                                            return props;
                                          })(pos0, result0[4], result0[6]);
                                      }
                                      if (result0 === null) {
                                        pos = pos0;
                                      }
                                      if (result0 === null) {
                                        pos0 = pos;
                                        pos1 = pos;
                                        result0 = parse__();
                                        if (result0 !== null) {
                                          if (input.substr(pos, 7).toLowerCase() === "default") {
                                            result1 = input.substr(pos, 7);
                                            pos += 7;
                                          } else {
                                            result1 = null;
                                            if (reportFailures === 0) {
                                              matchFailed("\"DEFAULT\"");
                                            }
                                          }
                                          if (result1 !== null) {
                                            result2 = parse___();
                                            if (result2 !== null) {
                                              result3 = parse_CONSTANT_EXPRESSION();
                                              if (result3 !== null) {
                                                result4 = parse_COLUMN_TYPE_PROPERTIES();
                                                if (result4 !== null) {
                                                  result0 = [result0, result1, result2, result3, result4];
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result0 = null;
                                              pos = pos1;
                                            }
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result0 = null;
                                          pos = pos1;
                                        }
                                        if (result0 !== null) {
                                          result0 = (function(offset, value, props) {
                                              props.default = value;
                                              return props;
                                            })(pos0, result0[3], result0[4]);
                                        }
                                        if (result0 === null) {
                                          pos = pos0;
                                        }
                                        if (result0 === null) {
                                          pos0 = pos;
                                          pos1 = pos;
                                          result0 = parse__();
                                          if (result0 !== null) {
                                            if (input.substr(pos, 7).toLowerCase() === "default") {
                                              result1 = input.substr(pos, 7);
                                              pos += 7;
                                            } else {
                                              result1 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\"DEFAULT\"");
                                              }
                                            }
                                            if (result1 !== null) {
                                              result2 = parse___();
                                              if (result2 !== null) {
                                                result3 = parse_CURRENT_TIMESTAMP();
                                                if (result3 !== null) {
                                                  result4 = parse_COLUMN_TYPE_PROPERTIES();
                                                  if (result4 !== null) {
                                                    result0 = [result0, result1, result2, result3, result4];
                                                  } else {
                                                    result0 = null;
                                                    pos = pos1;
                                                  }
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result0 = null;
                                              pos = pos1;
                                            }
                                          } else {
                                            result0 = null;
                                            pos = pos1;
                                          }
                                          if (result0 !== null) {
                                            result0 = (function(offset, props) {
                                                props.default = 'CURRENT_TIMESTAMP';
                                                return props;
                                              })(pos0, result0[4]);
                                          }
                                          if (result0 === null) {
                                            pos = pos0;
                                          }
                                          if (result0 === null) {
                                            pos0 = pos;
                                            pos1 = pos;
                                            result0 = parse__();
                                            if (result0 !== null) {
                                              if (input.substr(pos, 2).toLowerCase() === "on") {
                                                result1 = input.substr(pos, 2);
                                                pos += 2;
                                              } else {
                                                result1 = null;
                                                if (reportFailures === 0) {
                                                  matchFailed("\"ON\"");
                                                }
                                              }
                                              if (result1 !== null) {
                                                result2 = parse__();
                                                if (result2 !== null) {
                                                  if (input.substr(pos, 6).toLowerCase() === "update") {
                                                    result3 = input.substr(pos, 6);
                                                    pos += 6;
                                                  } else {
                                                    result3 = null;
                                                    if (reportFailures === 0) {
                                                      matchFailed("\"UPDATE\"");
                                                    }
                                                  }
                                                  if (result3 !== null) {
                                                    result4 = parse__();
                                                    if (result4 !== null) {
                                                      result5 = parse_CURRENT_TIMESTAMP();
                                                      if (result5 !== null) {
                                                        result6 = parse__();
                                                        if (result6 !== null) {
                                                          result7 = parse_COLUMN_TYPE_PROPERTIES();
                                                          if (result7 !== null) {
                                                            result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                                                          } else {
                                                            result0 = null;
                                                            pos = pos1;
                                                          }
                                                        } else {
                                                          result0 = null;
                                                          pos = pos1;
                                                        }
                                                      } else {
                                                        result0 = null;
                                                        pos = pos1;
                                                      }
                                                    } else {
                                                      result0 = null;
                                                      pos = pos1;
                                                    }
                                                  } else {
                                                    result0 = null;
                                                    pos = pos1;
                                                  }
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result0 = null;
                                              pos = pos1;
                                            }
                                            if (result0 !== null) {
                                              result0 = (function(offset, val, props) {
                                                  props.onUpdate = val;
                                                  return props;
                                                })(pos0, result0[5], result0[7]);
                                            }
                                            if (result0 === null) {
                                              pos = pos0;
                                            }
                                            if (result0 === null) {
                                              pos0 = pos;
                                              pos1 = pos;
                                              result0 = parse__();
                                              if (result0 !== null) {
                                                if (input.substr(pos, 7).toLowerCase() === "comment") {
                                                  result1 = input.substr(pos, 7);
                                                  pos += 7;
                                                } else {
                                                  result1 = null;
                                                  if (reportFailures === 0) {
                                                    matchFailed("\"COMMENT\"");
                                                  }
                                                }
                                                if (result1 !== null) {
                                                  pos2 = pos;
                                                  result2 = parse__();
                                                  if (result2 !== null) {
                                                    if (input.charCodeAt(pos) === 61) {
                                                      result3 = "=";
                                                      pos++;
                                                    } else {
                                                      result3 = null;
                                                      if (reportFailures === 0) {
                                                        matchFailed("\"=\"");
                                                      }
                                                    }
                                                    if (result3 !== null) {
                                                      result4 = parse__();
                                                      if (result4 !== null) {
                                                        result2 = [result2, result3, result4];
                                                      } else {
                                                        result2 = null;
                                                        pos = pos2;
                                                      }
                                                    } else {
                                                      result2 = null;
                                                      pos = pos2;
                                                    }
                                                  } else {
                                                    result2 = null;
                                                    pos = pos2;
                                                  }
                                                  if (result2 === null) {
                                                    result2 = parse___();
                                                  }
                                                  if (result2 !== null) {
                                                    result3 = parse_STRING();
                                                    if (result3 !== null) {
                                                      result4 = parse_COLUMN_TYPE_PROPERTIES();
                                                      if (result4 !== null) {
                                                        result0 = [result0, result1, result2, result3, result4];
                                                      } else {
                                                        result0 = null;
                                                        pos = pos1;
                                                      }
                                                    } else {
                                                      result0 = null;
                                                      pos = pos1;
                                                    }
                                                  } else {
                                                    result0 = null;
                                                    pos = pos1;
                                                  }
                                                } else {
                                                  result0 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result0 = null;
                                                pos = pos1;
                                              }
                                              if (result0 !== null) {
                                                result0 = (function(offset, comment, props) {
                                                    props.comment = comment;
                                                    return props;
                                                  })(pos0, result0[3], result0[4]);
                                              }
                                              if (result0 === null) {
                                                pos = pos0;
                                              }
                                              if (result0 === null) {
                                                pos0 = pos;
                                                result0 = parse__();
                                                if (result0 !== null) {
                                                  result0 = (function(offset) { return {}; })(pos0);
                                                }
                                                if (result0 === null) {
                                                  pos = pos0;
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("Column type properties");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_DROP_STATEMENT() {
        var cacheKey = "DROP_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 4).toLowerCase() === "drop") {
          result0 = input.substr(pos, 4);
          pos += 4;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"DROP\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            if (input.substr(pos, 8).toLowerCase() === "database") {
              result2 = input.substr(pos, 8);
              pos += 8;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"DATABASE\"");
              }
            }
            if (result2 === null) {
              if (input.substr(pos, 6).toLowerCase() === "schema") {
                result2 = input.substr(pos, 6);
                pos += 6;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"SCHEMA\"");
                }
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result4 = parse_ID();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, name) {
              return {
                statement: "DROP DATABASE",
                database: name
              };
            })(pos0, result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.substr(pos, 4).toLowerCase() === "drop") {
            result0 = input.substr(pos, 4);
            pos += 4;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"DROP\"");
            }
          }
          if (result0 !== null) {
            result1 = parse___();
            if (result1 !== null) {
              if (input.substr(pos, 9).toLowerCase() === "procedure") {
                result2 = input.substr(pos, 9);
                pos += 9;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"PROCEDURE\"");
                }
              }
              if (result2 !== null) {
                result3 = parse___();
                if (result3 !== null) {
                  result4 = parse_IF_EXISTS_OPT();
                  if (result4 !== null) {
                    result5 = parse__();
                    if (result5 !== null) {
                      result6 = parse_ID();
                      if (result6 !== null) {
                        result0 = [result0, result1, result2, result3, result4, result5, result6];
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, ifExists, name) {
                return {
                  statement: "DROP PROCEDURE",
                  database: name,
                  ifExists: ifExists
                };
              })(pos0, result0[4], result0[6]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            if (input.substr(pos, 4).toLowerCase() === "drop") {
              result0 = input.substr(pos, 4);
              pos += 4;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"DROP\"");
              }
            }
            if (result0 !== null) {
              result1 = parse___();
              if (result1 !== null) {
                if (input.substr(pos, 5).toLowerCase() === "table") {
                  result2 = input.substr(pos, 5);
                  pos += 5;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"TABLE\"");
                  }
                }
                if (result2 !== null) {
                  result3 = parse___();
                  if (result3 !== null) {
                    result4 = parse_TABLE_NAME();
                    if (result4 !== null) {
                      result0 = [result0, result1, result2, result3, result4];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, name) {
                  return {
                    statement: "DROP TABLE",
                    schema: name.schema,
                    table: name.name
                  };
                })(pos0, result0[4]);
            }
            if (result0 === null) {
              pos = pos0;
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("DROP");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_IF_EXISTS_OPT() {
        var cacheKey = "IF_EXISTS_OPT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 2).toLowerCase() === "if") {
          result0 = input.substr(pos, 2);
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"IF\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            if (input.substr(pos, 5).toLowerCase() === "exist") {
              result2 = input.substr(pos, 5);
              pos += 5;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"EXIST\"");
              }
            }
            if (result2 !== null) {
              if (input.substr(pos, 1).toLowerCase() === "s") {
                result3 = input.substr(pos, 1);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"S\"");
                }
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return true; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return false; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_DATA_MANIPULATION_STATEMENT() {
        var cacheKey = "DATA_MANIPULATION_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        result0 = parse_CALL_STATEMENT();
        if (result0 === null) {
          result0 = parse_INSERT_STATEMENT();
          if (result0 === null) {
            result0 = parse_SELECT_STATEMENT();
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CALL_STATEMENT() {
        var cacheKey = "CALL_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 4).toLowerCase() === "call") {
          result0 = input.substr(pos, 4);
          pos += 4;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"CALL\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result2 = parse_ID();
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 40) {
                  result4 = "(";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"(\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse_CALL_PARAMETER_LIST();
                  if (result5 !== null) {
                    if (input.charCodeAt(pos) === 41) {
                      result6 = ")";
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\")\"");
                      }
                    }
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, name, params) {
              return {
                statement: "CALL",
                name: name,
                params: params
              };
            })(pos0, result0[2], result0[5]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          if (input.substr(pos, 4).toLowerCase() === "call") {
            result0 = input.substr(pos, 4);
            pos += 4;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"CALL\"");
            }
          }
          if (result0 !== null) {
            result1 = parse___();
            if (result1 !== null) {
              result2 = parse_ID();
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, name) {
                return {
                  statement: "CALL",
                  name: name,
                  params: []
                };
              })(pos0, result0[2]);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("CALL");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CALL_PARAMETER_LIST() {
        var cacheKey = "CALL_PARAMETER_LIST@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = parse_EXPRESSION();
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              pos2 = pos;
              if (input.charCodeAt(pos) === 44) {
                result3 = ",";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result3 = [result3, result4];
                } else {
                  result3 = null;
                  pos = pos2;
                }
              } else {
                result3 = null;
                pos = pos2;
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                result4 = parse_CALL_PARAMETER_LIST();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, param, list) {
              list.unshift(param);
              return list;
            })(pos0, result0[1], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          result0 = parse__();
          if (result0 !== null) {
            result0 = (function(offset) { return []; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_STATEMENT() {
        var cacheKey = "INSERT_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 6).toLowerCase() === "insert") {
          result0 = input.substr(pos, 6);
          pos += 6;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"INSERT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse_INSERT_PRIORITY();
          if (result1 !== null) {
            result2 = parse_INSERT_IGNORE();
            if (result2 !== null) {
              pos2 = pos;
              result3 = parse___();
              if (result3 !== null) {
                if (input.substr(pos, 4).toLowerCase() === "into") {
                  result4 = input.substr(pos, 4);
                  pos += 4;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"INTO\"");
                  }
                }
                if (result4 !== null) {
                  result3 = [result3, result4];
                } else {
                  result3 = null;
                  pos = pos2;
                }
              } else {
                result3 = null;
                pos = pos2;
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                result4 = parse___();
                if (result4 !== null) {
                  result5 = parse_TABLE_NAME();
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_INSERT_COLUMN_LIST();
                      if (result7 !== null) {
                        if (input.substr(pos, 5).toLowerCase() === "value") {
                          result8 = input.substr(pos, 5);
                          pos += 5;
                        } else {
                          result8 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"VALUE\"");
                          }
                        }
                        if (result8 !== null) {
                          if (input.substr(pos, 1).toLowerCase() === "s") {
                            result9 = input.substr(pos, 1);
                            pos++;
                          } else {
                            result9 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"S\"");
                            }
                          }
                          result9 = result9 !== null ? result9 : "";
                          if (result9 !== null) {
                            result10 = parse__();
                            if (result10 !== null) {
                              result11 = parse_INSERT_ROWS();
                              if (result11 !== null) {
                                result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11];
                              } else {
                                result0 = null;
                                pos = pos1;
                              }
                            } else {
                              result0 = null;
                              pos = pos1;
                            }
                          } else {
                            result0 = null;
                            pos = pos1;
                          }
                        } else {
                          result0 = null;
                          pos = pos1;
                        }
                      } else {
                        result0 = null;
                        pos = pos1;
                      }
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, priority, ignore, table, columns, rows) {
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
            })(pos0, result0[1], result0[2], result0[5], result0[7], result0[11]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("INSERT");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_PRIORITY() {
        var cacheKey = "INSERT_PRIORITY@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse___();
        if (result0 !== null) {
          if (input.substr(pos, 3).toLowerCase() === "low") {
            result1 = input.substr(pos, 3);
            pos += 3;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"LOW\"");
            }
          }
          if (result1 !== null) {
            if (input.charCodeAt(pos) === 95) {
              result2 = "_";
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"_\"");
              }
            }
            if (result2 === null) {
              result2 = parse__();
            }
            if (result2 !== null) {
              if (input.substr(pos, 8).toLowerCase() === "priority") {
                result3 = input.substr(pos, 8);
                pos += 8;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"PRIORITY\"");
                }
              }
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return "LOW"; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse___();
          if (result0 !== null) {
            if (input.substr(pos, 7).toLowerCase() === "delayed") {
              result1 = input.substr(pos, 7);
              pos += 7;
            } else {
              result1 = null;
              if (reportFailures === 0) {
                matchFailed("\"DELAYED\"");
              }
            }
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset) { return "DELAYED"; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            result0 = parse___();
            if (result0 !== null) {
              if (input.substr(pos, 4).toLowerCase() === "high") {
                result1 = input.substr(pos, 4);
                pos += 4;
              } else {
                result1 = null;
                if (reportFailures === 0) {
                  matchFailed("\"HIGH\"");
                }
              }
              if (result1 !== null) {
                if (input.charCodeAt(pos) === 95) {
                  result2 = "_";
                  pos++;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"_\"");
                  }
                }
                if (result2 === null) {
                  result2 = parse__();
                }
                if (result2 !== null) {
                  if (input.substr(pos, 8).toLowerCase() === "priority") {
                    result3 = input.substr(pos, 8);
                    pos += 8;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"PRIORITY\"");
                    }
                  }
                  if (result3 !== null) {
                    result0 = [result0, result1, result2, result3];
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset) { return "HIGH"; })(pos0);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              pos1 = pos;
              result0 = [];
              if (result0 !== null) {
                result0 = (function(offset) { return false; })(pos0);
              }
              if (result0 === null) {
                pos = pos0;
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_IGNORE() {
        var cacheKey = "INSERT_IGNORE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse___();
        if (result0 !== null) {
          if (input.substr(pos, 6).toLowerCase() === "ignore") {
            result1 = input.substr(pos, 6);
            pos += 6;
          } else {
            result1 = null;
            if (reportFailures === 0) {
              matchFailed("\"IGNORE\"");
            }
          }
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset) { return true; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return false; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_COLUMN_LIST() {
        var cacheKey = "INSERT_COLUMN_LIST@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 40) {
          result0 = "(";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"(\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_ID();
            if (result2 === null) {
              result2 = parse_STRING();
            }
            if (result2 !== null) {
              result3 = [];
              pos2 = pos;
              pos3 = pos;
              result4 = parse__();
              if (result4 !== null) {
                if (input.charCodeAt(pos) === 44) {
                  result5 = ",";
                  pos++;
                } else {
                  result5 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result5 !== null) {
                  result6 = parse__();
                  if (result6 !== null) {
                    result7 = parse_ID();
                    if (result7 === null) {
                      result7 = parse_STRING();
                    }
                    if (result7 !== null) {
                      result4 = [result4, result5, result6, result7];
                    } else {
                      result4 = null;
                      pos = pos3;
                    }
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
              } else {
                result4 = null;
                pos = pos3;
              }
              if (result4 !== null) {
                result4 = (function(offset, col) {return col;})(pos2, result4[3]);
              }
              if (result4 === null) {
                pos = pos2;
              }
              while (result4 !== null) {
                result3.push(result4);
                pos2 = pos;
                pos3 = pos;
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 44) {
                    result5 = ",";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\",\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_ID();
                      if (result7 === null) {
                        result7 = parse_STRING();
                      }
                      if (result7 !== null) {
                        result4 = [result4, result5, result6, result7];
                      } else {
                        result4 = null;
                        pos = pos3;
                      }
                    } else {
                      result4 = null;
                      pos = pos3;
                    }
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
                if (result4 !== null) {
                  result4 = (function(offset, col) {return col;})(pos2, result4[3]);
                }
                if (result4 === null) {
                  pos = pos2;
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 41) {
                    result5 = ")";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\")\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, col, tail) {
              tail.unshift(col);
              return tail;
            })(pos0, result0[2], result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return []; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_ROWS() {
        var cacheKey = "INSERT_ROWS@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_INSERT_ROW();
        if (result0 !== null) {
          result1 = [];
          pos2 = pos;
          pos3 = pos;
          if (input.charCodeAt(pos) === 44) {
            result2 = ",";
            pos++;
          } else {
            result2 = null;
            if (reportFailures === 0) {
              matchFailed("\",\"");
            }
          }
          if (result2 !== null) {
            result3 = parse__();
            if (result3 !== null) {
              result4 = parse_INSERT_ROW();
              if (result4 !== null) {
                result2 = [result2, result3, result4];
              } else {
                result2 = null;
                pos = pos3;
              }
            } else {
              result2 = null;
              pos = pos3;
            }
          } else {
            result2 = null;
            pos = pos3;
          }
          if (result2 !== null) {
            result2 = (function(offset, row) { return row; })(pos2, result2[2]);
          }
          if (result2 === null) {
            pos = pos2;
          }
          while (result2 !== null) {
            result1.push(result2);
            pos2 = pos;
            pos3 = pos;
            if (input.charCodeAt(pos) === 44) {
              result2 = ",";
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\",\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result4 = parse_INSERT_ROW();
                if (result4 !== null) {
                  result2 = [result2, result3, result4];
                } else {
                  result2 = null;
                  pos = pos3;
                }
              } else {
                result2 = null;
                pos = pos3;
              }
            } else {
              result2 = null;
              pos = pos3;
            }
            if (result2 !== null) {
              result2 = (function(offset, row) { return row; })(pos2, result2[2]);
            }
            if (result2 === null) {
              pos = pos2;
            }
          }
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, first, rows) {
              rows.unshift(first);
              return rows;
            })(pos0, result0[0], result0[1]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_INSERT_ROW() {
        var cacheKey = "INSERT_ROW@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 40) {
          result0 = "(";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"(\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_EXPRESSION();
            if (result2 !== null) {
              result3 = [];
              pos2 = pos;
              pos3 = pos;
              if (input.charCodeAt(pos) === 44) {
                result4 = ",";
                pos++;
              } else {
                result4 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result4 !== null) {
                result5 = parse_EXPRESSION();
                if (result5 !== null) {
                  result4 = [result4, result5];
                } else {
                  result4 = null;
                  pos = pos3;
                }
              } else {
                result4 = null;
                pos = pos3;
              }
              if (result4 !== null) {
                result4 = (function(offset, expr) { return expr; })(pos2, result4[1]);
              }
              if (result4 === null) {
                pos = pos2;
              }
              while (result4 !== null) {
                result3.push(result4);
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 44) {
                  result4 = ",";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse_EXPRESSION();
                  if (result5 !== null) {
                    result4 = [result4, result5];
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
                if (result4 !== null) {
                  result4 = (function(offset, expr) { return expr; })(pos2, result4[1]);
                }
                if (result4 === null) {
                  pos = pos2;
                }
              }
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 41) {
                  result4 = ")";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\")\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result0 = [result0, result1, result2, result3, result4, result5];
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, first, row) {
              row.unshift(first);
              return row;
            })(pos0, result0[2], result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SELECT_STATEMENT() {
        var cacheKey = "SELECT_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15, result16, result17, result18, result19, result20, result21, result22, result23, result24, result25, result26, result27, result28;
        var pos0, pos1, pos2, pos3;
        
        reportFailures++;
        pos0 = pos;
        if (input.substr(pos, 6).toLowerCase() === "select") {
          result0 = input.substr(pos, 6);
          pos += 6;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"SELECT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            pos1 = pos;
            if (input.substr(pos, 3).toLowerCase() === "all") {
              result2 = input.substr(pos, 3);
              pos += 3;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"ALL\"");
              }
            }
            if (result2 === null) {
              pos2 = pos;
              if (input.substr(pos, 8).toLowerCase() === "distinct") {
                result2 = input.substr(pos, 8);
                pos += 8;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"DISTINCT\"");
                }
              }
              if (result2 !== null) {
                result3 = parse__();
                if (result3 === null) {
                  if (input.charCodeAt(pos) === 95) {
                    result3 = "_";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"_\"");
                    }
                  }
                }
                if (result3 !== null) {
                  if (input.substr(pos, 3).toLowerCase() === "row") {
                    result4 = input.substr(pos, 3);
                    pos += 3;
                  } else {
                    result4 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"ROW\"");
                    }
                  }
                  if (result4 !== null) {
                    result2 = [result2, result3, result4];
                  } else {
                    result2 = null;
                    pos = pos2;
                  }
                } else {
                  result2 = null;
                  pos = pos2;
                }
              } else {
                result2 = null;
                pos = pos2;
              }
              if (result2 === null) {
                if (input.substr(pos, 8).toLowerCase() === "distinct") {
                  result2 = input.substr(pos, 8);
                  pos += 8;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"DISTINCT\"");
                  }
                }
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos1;
              }
            } else {
              result2 = null;
              pos = pos1;
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              pos1 = pos;
              if (input.substr(pos, 13).toLowerCase() === "high_priority") {
                result3 = input.substr(pos, 13);
                pos += 13;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\"HIGH_PRIORITY\"");
                }
              }
              if (result3 !== null) {
                result4 = parse___();
                if (result4 !== null) {
                  result3 = [result3, result4];
                } else {
                  result3 = null;
                  pos = pos1;
                }
              } else {
                result3 = null;
                pos = pos1;
              }
              result3 = result3 !== null ? result3 : "";
              if (result3 !== null) {
                pos1 = pos;
                if (input.substr(pos, 13).toLowerCase() === "straight_join") {
                  result4 = input.substr(pos, 13);
                  pos += 13;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"STRAIGHT_JOIN\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse___();
                  if (result5 !== null) {
                    result4 = [result4, result5];
                  } else {
                    result4 = null;
                    pos = pos1;
                  }
                } else {
                  result4 = null;
                  pos = pos1;
                }
                result4 = result4 !== null ? result4 : "";
                if (result4 !== null) {
                  pos1 = pos;
                  if (input.substr(pos, 16).toLowerCase() === "sql_small_result") {
                    result5 = input.substr(pos, 16);
                    pos += 16;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"SQL_SMALL_RESULT\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse___();
                    if (result6 !== null) {
                      result5 = [result5, result6];
                    } else {
                      result5 = null;
                      pos = pos1;
                    }
                  } else {
                    result5 = null;
                    pos = pos1;
                  }
                  result5 = result5 !== null ? result5 : "";
                  if (result5 !== null) {
                    pos1 = pos;
                    if (input.substr(pos, 14).toLowerCase() === "sql_big_result") {
                      result6 = input.substr(pos, 14);
                      pos += 14;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"SQL_BIG_RESULT\"");
                      }
                    }
                    if (result6 !== null) {
                      result7 = parse___();
                      if (result7 !== null) {
                        result6 = [result6, result7];
                      } else {
                        result6 = null;
                        pos = pos1;
                      }
                    } else {
                      result6 = null;
                      pos = pos1;
                    }
                    result6 = result6 !== null ? result6 : "";
                    if (result6 !== null) {
                      pos1 = pos;
                      if (input.substr(pos, 17).toLowerCase() === "sql_buffer_result") {
                        result7 = input.substr(pos, 17);
                        pos += 17;
                      } else {
                        result7 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"SQL_BUFFER_RESULT\"");
                        }
                      }
                      if (result7 !== null) {
                        result8 = parse___();
                        if (result8 !== null) {
                          result7 = [result7, result8];
                        } else {
                          result7 = null;
                          pos = pos1;
                        }
                      } else {
                        result7 = null;
                        pos = pos1;
                      }
                      result7 = result7 !== null ? result7 : "";
                      if (result7 !== null) {
                        pos1 = pos;
                        if (input.substr(pos, 9).toLowerCase() === "sql_cache") {
                          result8 = input.substr(pos, 9);
                          pos += 9;
                        } else {
                          result8 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"SQL_CACHE\"");
                          }
                        }
                        if (result8 === null) {
                          if (input.substr(pos, 12).toLowerCase() === "sql_no_cache") {
                            result8 = input.substr(pos, 12);
                            pos += 12;
                          } else {
                            result8 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"SQL_NO_CACHE\"");
                            }
                          }
                        }
                        if (result8 !== null) {
                          result9 = parse___();
                          if (result9 !== null) {
                            result8 = [result8, result9];
                          } else {
                            result8 = null;
                            pos = pos1;
                          }
                        } else {
                          result8 = null;
                          pos = pos1;
                        }
                        result8 = result8 !== null ? result8 : "";
                        if (result8 !== null) {
                          if (input.substr(pos, 19).toLowerCase() === "sql_calc_found_rows") {
                            result9 = input.substr(pos, 19);
                            pos += 19;
                          } else {
                            result9 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"SQL_CALC_FOUND_ROWS\"");
                            }
                          }
                          result9 = result9 !== null ? result9 : "";
                          if (result9 !== null) {
                            result10 = parse_SELECT_EXPRESSION_LIST();
                            if (result10 !== null) {
                              pos1 = pos;
                              if (input.substr(pos, 4).toLowerCase() === "from") {
                                result11 = input.substr(pos, 4);
                                pos += 4;
                              } else {
                                result11 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"FROM\"");
                                }
                              }
                              if (result11 !== null) {
                                result12 = parse___();
                                if (result12 !== null) {
                                  result13 = parse_FROM_TABLE_REFERENCES();
                                  if (result13 !== null) {
                                    pos2 = pos;
                                    if (input.substr(pos, 9).toLowerCase() === "partition") {
                                      result14 = input.substr(pos, 9);
                                      pos += 9;
                                    } else {
                                      result14 = null;
                                      if (reportFailures === 0) {
                                        matchFailed("\"PARTITION\"");
                                      }
                                    }
                                    if (result14 !== null) {
                                      result15 = parse___();
                                      if (result15 !== null) {
                                        result16 = parse_ID();
                                        if (result16 !== null) {
                                          pos3 = pos;
                                          result17 = parse__();
                                          if (result17 !== null) {
                                            if (input.charCodeAt(pos) === 44) {
                                              result18 = ",";
                                              pos++;
                                            } else {
                                              result18 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\",\"");
                                              }
                                            }
                                            if (result18 !== null) {
                                              result19 = parse__();
                                              if (result19 !== null) {
                                                result20 = parse_ID();
                                                if (result20 !== null) {
                                                  result17 = [result17, result18, result19, result20];
                                                } else {
                                                  result17 = null;
                                                  pos = pos3;
                                                }
                                              } else {
                                                result17 = null;
                                                pos = pos3;
                                              }
                                            } else {
                                              result17 = null;
                                              pos = pos3;
                                            }
                                          } else {
                                            result17 = null;
                                            pos = pos3;
                                          }
                                          result17 = result17 !== null ? result17 : "";
                                          if (result17 !== null) {
                                            result14 = [result14, result15, result16, result17];
                                          } else {
                                            result14 = null;
                                            pos = pos2;
                                          }
                                        } else {
                                          result14 = null;
                                          pos = pos2;
                                        }
                                      } else {
                                        result14 = null;
                                        pos = pos2;
                                      }
                                    } else {
                                      result14 = null;
                                      pos = pos2;
                                    }
                                    result14 = result14 !== null ? result14 : "";
                                    if (result14 !== null) {
                                      pos2 = pos;
                                      if (input.substr(pos, 5).toLowerCase() === "where") {
                                        result15 = input.substr(pos, 5);
                                        pos += 5;
                                      } else {
                                        result15 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"WHERE\"");
                                        }
                                      }
                                      if (result15 !== null) {
                                        result16 = parse__();
                                        if (result16 !== null) {
                                          result17 = parse_EXPRESSION();
                                          if (result17 !== null) {
                                            result15 = [result15, result16, result17];
                                          } else {
                                            result15 = null;
                                            pos = pos2;
                                          }
                                        } else {
                                          result15 = null;
                                          pos = pos2;
                                        }
                                      } else {
                                        result15 = null;
                                        pos = pos2;
                                      }
                                      result15 = result15 !== null ? result15 : "";
                                      if (result15 !== null) {
                                        pos2 = pos;
                                        if (input.substr(pos, 5).toLowerCase() === "group") {
                                          result16 = input.substr(pos, 5);
                                          pos += 5;
                                        } else {
                                          result16 = null;
                                          if (reportFailures === 0) {
                                            matchFailed("\"GROUP\"");
                                          }
                                        }
                                        if (result16 !== null) {
                                          result17 = parse__();
                                          if (result17 !== null) {
                                            if (input.substr(pos, 2).toLowerCase() === "by") {
                                              result18 = input.substr(pos, 2);
                                              pos += 2;
                                            } else {
                                              result18 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\"BY\"");
                                              }
                                            }
                                            if (result18 !== null) {
                                              pos3 = pos;
                                              if (input.charCodeAt(pos) === 44) {
                                                result20 = ",";
                                                pos++;
                                              } else {
                                                result20 = null;
                                                if (reportFailures === 0) {
                                                  matchFailed("\",\"");
                                                }
                                              }
                                              result20 = result20 !== null ? result20 : "";
                                              if (result20 !== null) {
                                                result21 = parse_COLUMN_NAME();
                                                if (result21 !== null) {
                                                  if (input.substr(pos, 3).toLowerCase() === "asc") {
                                                    result22 = input.substr(pos, 3);
                                                    pos += 3;
                                                  } else {
                                                    result22 = null;
                                                    if (reportFailures === 0) {
                                                      matchFailed("\"ASC\"");
                                                    }
                                                  }
                                                  if (result22 === null) {
                                                    if (input.substr(pos, 4).toLowerCase() === "desc") {
                                                      result22 = input.substr(pos, 4);
                                                      pos += 4;
                                                    } else {
                                                      result22 = null;
                                                      if (reportFailures === 0) {
                                                        matchFailed("\"DESC\"");
                                                      }
                                                    }
                                                  }
                                                  result22 = result22 !== null ? result22 : "";
                                                  if (result22 !== null) {
                                                    result20 = [result20, result21, result22];
                                                  } else {
                                                    result20 = null;
                                                    pos = pos3;
                                                  }
                                                } else {
                                                  result20 = null;
                                                  pos = pos3;
                                                }
                                              } else {
                                                result20 = null;
                                                pos = pos3;
                                              }
                                              if (result20 !== null) {
                                                result19 = [];
                                                while (result20 !== null) {
                                                  result19.push(result20);
                                                  pos3 = pos;
                                                  if (input.charCodeAt(pos) === 44) {
                                                    result20 = ",";
                                                    pos++;
                                                  } else {
                                                    result20 = null;
                                                    if (reportFailures === 0) {
                                                      matchFailed("\",\"");
                                                    }
                                                  }
                                                  result20 = result20 !== null ? result20 : "";
                                                  if (result20 !== null) {
                                                    result21 = parse_COLUMN_NAME();
                                                    if (result21 !== null) {
                                                      if (input.substr(pos, 3).toLowerCase() === "asc") {
                                                        result22 = input.substr(pos, 3);
                                                        pos += 3;
                                                      } else {
                                                        result22 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"ASC\"");
                                                        }
                                                      }
                                                      if (result22 === null) {
                                                        if (input.substr(pos, 4).toLowerCase() === "desc") {
                                                          result22 = input.substr(pos, 4);
                                                          pos += 4;
                                                        } else {
                                                          result22 = null;
                                                          if (reportFailures === 0) {
                                                            matchFailed("\"DESC\"");
                                                          }
                                                        }
                                                      }
                                                      result22 = result22 !== null ? result22 : "";
                                                      if (result22 !== null) {
                                                        result20 = [result20, result21, result22];
                                                      } else {
                                                        result20 = null;
                                                        pos = pos3;
                                                      }
                                                    } else {
                                                      result20 = null;
                                                      pos = pos3;
                                                    }
                                                  } else {
                                                    result20 = null;
                                                    pos = pos3;
                                                  }
                                                }
                                              } else {
                                                result19 = null;
                                              }
                                              if (result19 !== null) {
                                                pos3 = pos;
                                                if (input.substr(pos, 4).toLowerCase() === "with") {
                                                  result20 = input.substr(pos, 4);
                                                  pos += 4;
                                                } else {
                                                  result20 = null;
                                                  if (reportFailures === 0) {
                                                    matchFailed("\"WITH\"");
                                                  }
                                                }
                                                if (result20 !== null) {
                                                  if (input.charCodeAt(pos) === 95) {
                                                    result21 = "_";
                                                    pos++;
                                                  } else {
                                                    result21 = null;
                                                    if (reportFailures === 0) {
                                                      matchFailed("\"_\"");
                                                    }
                                                  }
                                                  if (result21 === null) {
                                                    result21 = parse__();
                                                  }
                                                  if (result21 !== null) {
                                                    if (input.substr(pos, 6).toLowerCase() === "rollup") {
                                                      result22 = input.substr(pos, 6);
                                                      pos += 6;
                                                    } else {
                                                      result22 = null;
                                                      if (reportFailures === 0) {
                                                        matchFailed("\"ROLLUP\"");
                                                      }
                                                    }
                                                    if (result22 !== null) {
                                                      result20 = [result20, result21, result22];
                                                    } else {
                                                      result20 = null;
                                                      pos = pos3;
                                                    }
                                                  } else {
                                                    result20 = null;
                                                    pos = pos3;
                                                  }
                                                } else {
                                                  result20 = null;
                                                  pos = pos3;
                                                }
                                                result20 = result20 !== null ? result20 : "";
                                                if (result20 !== null) {
                                                  result16 = [result16, result17, result18, result19, result20];
                                                } else {
                                                  result16 = null;
                                                  pos = pos2;
                                                }
                                              } else {
                                                result16 = null;
                                                pos = pos2;
                                              }
                                            } else {
                                              result16 = null;
                                              pos = pos2;
                                            }
                                          } else {
                                            result16 = null;
                                            pos = pos2;
                                          }
                                        } else {
                                          result16 = null;
                                          pos = pos2;
                                        }
                                        result16 = result16 !== null ? result16 : "";
                                        if (result16 !== null) {
                                          pos2 = pos;
                                          if (input.substr(pos, 6).toLowerCase() === "having") {
                                            result17 = input.substr(pos, 6);
                                            pos += 6;
                                          } else {
                                            result17 = null;
                                            if (reportFailures === 0) {
                                              matchFailed("\"HAVING\"");
                                            }
                                          }
                                          if (result17 !== null) {
                                            result18 = parse__();
                                            if (result18 !== null) {
                                              result19 = parse_EXPRESSION();
                                              if (result19 !== null) {
                                                result17 = [result17, result18, result19];
                                              } else {
                                                result17 = null;
                                                pos = pos2;
                                              }
                                            } else {
                                              result17 = null;
                                              pos = pos2;
                                            }
                                          } else {
                                            result17 = null;
                                            pos = pos2;
                                          }
                                          result17 = result17 !== null ? result17 : "";
                                          if (result17 !== null) {
                                            pos2 = pos;
                                            if (input.substr(pos, 5).toLowerCase() === "order") {
                                              result18 = input.substr(pos, 5);
                                              pos += 5;
                                            } else {
                                              result18 = null;
                                              if (reportFailures === 0) {
                                                matchFailed("\"ORDER\"");
                                              }
                                            }
                                            if (result18 !== null) {
                                              result19 = parse__();
                                              if (result19 !== null) {
                                                if (input.substr(pos, 2).toLowerCase() === "by") {
                                                  result20 = input.substr(pos, 2);
                                                  pos += 2;
                                                } else {
                                                  result20 = null;
                                                  if (reportFailures === 0) {
                                                    matchFailed("\"BY\"");
                                                  }
                                                }
                                                if (result20 !== null) {
                                                  result21 = parse__();
                                                  if (result21 !== null) {
                                                    result22 = parse_EXPRESSION();
                                                    if (result22 !== null) {
                                                      result18 = [result18, result19, result20, result21, result22];
                                                    } else {
                                                      result18 = null;
                                                      pos = pos2;
                                                    }
                                                  } else {
                                                    result18 = null;
                                                    pos = pos2;
                                                  }
                                                } else {
                                                  result18 = null;
                                                  pos = pos2;
                                                }
                                              } else {
                                                result18 = null;
                                                pos = pos2;
                                              }
                                            } else {
                                              result18 = null;
                                              pos = pos2;
                                            }
                                            result18 = result18 !== null ? result18 : "";
                                            if (result18 !== null) {
                                              pos2 = pos;
                                              if (input.substr(pos, 5).toLowerCase() === "limit") {
                                                result19 = input.substr(pos, 5);
                                                pos += 5;
                                              } else {
                                                result19 = null;
                                                if (reportFailures === 0) {
                                                  matchFailed("\"LIMIT\"");
                                                }
                                              }
                                              if (result19 !== null) {
                                                result20 = parse__();
                                                if (result20 !== null) {
                                                  result21 = parse_POSITIVE_NUMBER();
                                                  result21 = result21 !== null ? result21 : "";
                                                  if (result21 === null) {
                                                    pos3 = pos;
                                                    result21 = parse_POSITIVE_NUMBER();
                                                    if (result21 !== null) {
                                                      if (input.substr(pos, 6).toLowerCase() === "offset") {
                                                        result22 = input.substr(pos, 6);
                                                        pos += 6;
                                                      } else {
                                                        result22 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"OFFSET\"");
                                                        }
                                                      }
                                                      if (result22 !== null) {
                                                        result23 = parse_POSITIVE_NUMBER();
                                                        if (result23 !== null) {
                                                          result21 = [result21, result22, result23];
                                                        } else {
                                                          result21 = null;
                                                          pos = pos3;
                                                        }
                                                      } else {
                                                        result21 = null;
                                                        pos = pos3;
                                                      }
                                                    } else {
                                                      result21 = null;
                                                      pos = pos3;
                                                    }
                                                  }
                                                  if (result21 !== null) {
                                                    result19 = [result19, result20, result21];
                                                  } else {
                                                    result19 = null;
                                                    pos = pos2;
                                                  }
                                                } else {
                                                  result19 = null;
                                                  pos = pos2;
                                                }
                                              } else {
                                                result19 = null;
                                                pos = pos2;
                                              }
                                              result19 = result19 !== null ? result19 : "";
                                              if (result19 !== null) {
                                                pos2 = pos;
                                                if (input.substr(pos, 9).toLowerCase() === "procedure") {
                                                  result20 = input.substr(pos, 9);
                                                  pos += 9;
                                                } else {
                                                  result20 = null;
                                                  if (reportFailures === 0) {
                                                    matchFailed("\"PROCEDURE\"");
                                                  }
                                                }
                                                if (result20 !== null) {
                                                  result21 = parse_ID();
                                                  if (result21 !== null) {
                                                    result22 = parse_EXPRESSION();
                                                    if (result22 !== null) {
                                                      result20 = [result20, result21, result22];
                                                    } else {
                                                      result20 = null;
                                                      pos = pos2;
                                                    }
                                                  } else {
                                                    result20 = null;
                                                    pos = pos2;
                                                  }
                                                } else {
                                                  result20 = null;
                                                  pos = pos2;
                                                }
                                                result20 = result20 !== null ? result20 : "";
                                                if (result20 !== null) {
                                                  pos2 = pos;
                                                  if (input.substr(pos, 4).toLowerCase() === "into") {
                                                    result21 = input.substr(pos, 4);
                                                    pos += 4;
                                                  } else {
                                                    result21 = null;
                                                    if (reportFailures === 0) {
                                                      matchFailed("\"INTO\"");
                                                    }
                                                  }
                                                  if (result21 !== null) {
                                                    result22 = parse___();
                                                    if (result22 !== null) {
                                                      if (input.substr(pos, 7).toLowerCase() === "outfile") {
                                                        result23 = input.substr(pos, 7);
                                                        pos += 7;
                                                      } else {
                                                        result23 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"OUTFILE\"");
                                                        }
                                                      }
                                                      if (result23 !== null) {
                                                        result24 = parse_ID();
                                                        if (result24 === null) {
                                                          result24 = parse_STRING();
                                                        }
                                                        if (result24 !== null) {
                                                          pos3 = pos;
                                                          if (input.substr(pos, 9).toLowerCase() === "character") {
                                                            result25 = input.substr(pos, 9);
                                                            pos += 9;
                                                          } else {
                                                            result25 = null;
                                                            if (reportFailures === 0) {
                                                              matchFailed("\"CHARACTER\"");
                                                            }
                                                          }
                                                          if (result25 !== null) {
                                                            result26 = parse___();
                                                            if (result26 !== null) {
                                                              if (input.substr(pos, 3).toLowerCase() === "set") {
                                                                result27 = input.substr(pos, 3);
                                                                pos += 3;
                                                              } else {
                                                                result27 = null;
                                                                if (reportFailures === 0) {
                                                                  matchFailed("\"SET\"");
                                                                }
                                                              }
                                                              if (result27 !== null) {
                                                                result28 = parse_ID();
                                                                if (result28 !== null) {
                                                                  result25 = [result25, result26, result27, result28];
                                                                } else {
                                                                  result25 = null;
                                                                  pos = pos3;
                                                                }
                                                              } else {
                                                                result25 = null;
                                                                pos = pos3;
                                                              }
                                                            } else {
                                                              result25 = null;
                                                              pos = pos3;
                                                            }
                                                          } else {
                                                            result25 = null;
                                                            pos = pos3;
                                                          }
                                                          result25 = result25 !== null ? result25 : "";
                                                          if (result25 !== null) {
                                                            result21 = [result21, result22, result23, result24, result25];
                                                          } else {
                                                            result21 = null;
                                                            pos = pos2;
                                                          }
                                                        } else {
                                                          result21 = null;
                                                          pos = pos2;
                                                        }
                                                      } else {
                                                        result21 = null;
                                                        pos = pos2;
                                                      }
                                                    } else {
                                                      result21 = null;
                                                      pos = pos2;
                                                    }
                                                  } else {
                                                    result21 = null;
                                                    pos = pos2;
                                                  }
                                                  if (result21 === null) {
                                                    pos2 = pos;
                                                    if (input.substr(pos, 4).toLowerCase() === "into") {
                                                      result21 = input.substr(pos, 4);
                                                      pos += 4;
                                                    } else {
                                                      result21 = null;
                                                      if (reportFailures === 0) {
                                                        matchFailed("\"INTO\"");
                                                      }
                                                    }
                                                    if (result21 !== null) {
                                                      if (input.substr(pos, 8).toLowerCase() === "dumpfile") {
                                                        result22 = input.substr(pos, 8);
                                                        pos += 8;
                                                      } else {
                                                        result22 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"DUMPFILE\"");
                                                        }
                                                      }
                                                      if (result22 !== null) {
                                                        if (input.substr(pos, 9) === "file_name") {
                                                          result23 = "file_name";
                                                          pos += 9;
                                                        } else {
                                                          result23 = null;
                                                          if (reportFailures === 0) {
                                                            matchFailed("\"file_name\"");
                                                          }
                                                        }
                                                        if (result23 !== null) {
                                                          result21 = [result21, result22, result23];
                                                        } else {
                                                          result21 = null;
                                                          pos = pos2;
                                                        }
                                                      } else {
                                                        result21 = null;
                                                        pos = pos2;
                                                      }
                                                    } else {
                                                      result21 = null;
                                                      pos = pos2;
                                                    }
                                                    if (result21 === null) {
                                                      pos2 = pos;
                                                      if (input.substr(pos, 4).toLowerCase() === "into") {
                                                        result21 = input.substr(pos, 4);
                                                        pos += 4;
                                                      } else {
                                                        result21 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"INTO\"");
                                                        }
                                                      }
                                                      if (result21 !== null) {
                                                        result22 = parse_ID();
                                                        if (result22 !== null) {
                                                          pos3 = pos;
                                                          result23 = parse__();
                                                          if (result23 !== null) {
                                                            if (input.charCodeAt(pos) === 44) {
                                                              result24 = ",";
                                                              pos++;
                                                            } else {
                                                              result24 = null;
                                                              if (reportFailures === 0) {
                                                                matchFailed("\",\"");
                                                              }
                                                            }
                                                            if (result24 !== null) {
                                                              result25 = parse__();
                                                              if (result25 !== null) {
                                                                result26 = parse_ID();
                                                                if (result26 !== null) {
                                                                  result23 = [result23, result24, result25, result26];
                                                                } else {
                                                                  result23 = null;
                                                                  pos = pos3;
                                                                }
                                                              } else {
                                                                result23 = null;
                                                                pos = pos3;
                                                              }
                                                            } else {
                                                              result23 = null;
                                                              pos = pos3;
                                                            }
                                                          } else {
                                                            result23 = null;
                                                            pos = pos3;
                                                          }
                                                          result23 = result23 !== null ? result23 : "";
                                                          if (result23 !== null) {
                                                            result21 = [result21, result22, result23];
                                                          } else {
                                                            result21 = null;
                                                            pos = pos2;
                                                          }
                                                        } else {
                                                          result21 = null;
                                                          pos = pos2;
                                                        }
                                                      } else {
                                                        result21 = null;
                                                        pos = pos2;
                                                      }
                                                    }
                                                  }
                                                  result21 = result21 !== null ? result21 : "";
                                                  if (result21 !== null) {
                                                    pos2 = pos;
                                                    if (input.substr(pos, 3).toLowerCase() === "for") {
                                                      result22 = input.substr(pos, 3);
                                                      pos += 3;
                                                    } else {
                                                      result22 = null;
                                                      if (reportFailures === 0) {
                                                        matchFailed("\"FOR\"");
                                                      }
                                                    }
                                                    if (result22 !== null) {
                                                      result23 = parse__();
                                                      if (result23 !== null) {
                                                        if (input.substr(pos, 6).toLowerCase() === "update") {
                                                          result24 = input.substr(pos, 6);
                                                          pos += 6;
                                                        } else {
                                                          result24 = null;
                                                          if (reportFailures === 0) {
                                                            matchFailed("\"UPDATE\"");
                                                          }
                                                        }
                                                        if (result24 !== null) {
                                                          result22 = [result22, result23, result24];
                                                        } else {
                                                          result22 = null;
                                                          pos = pos2;
                                                        }
                                                      } else {
                                                        result22 = null;
                                                        pos = pos2;
                                                      }
                                                    } else {
                                                      result22 = null;
                                                      pos = pos2;
                                                    }
                                                    if (result22 === null) {
                                                      pos2 = pos;
                                                      if (input.substr(pos, 4).toLowerCase() === "lock") {
                                                        result22 = input.substr(pos, 4);
                                                        pos += 4;
                                                      } else {
                                                        result22 = null;
                                                        if (reportFailures === 0) {
                                                          matchFailed("\"LOCK\"");
                                                        }
                                                      }
                                                      if (result22 !== null) {
                                                        result23 = parse__();
                                                        if (result23 !== null) {
                                                          if (input.substr(pos, 2).toLowerCase() === "in") {
                                                            result24 = input.substr(pos, 2);
                                                            pos += 2;
                                                          } else {
                                                            result24 = null;
                                                            if (reportFailures === 0) {
                                                              matchFailed("\"IN\"");
                                                            }
                                                          }
                                                          if (result24 !== null) {
                                                            result25 = parse__();
                                                            if (result25 !== null) {
                                                              if (input.substr(pos, 5).toLowerCase() === "share") {
                                                                result26 = input.substr(pos, 5);
                                                                pos += 5;
                                                              } else {
                                                                result26 = null;
                                                                if (reportFailures === 0) {
                                                                  matchFailed("\"SHARE\"");
                                                                }
                                                              }
                                                              if (result26 !== null) {
                                                                result27 = parse__();
                                                                if (result27 !== null) {
                                                                  if (input.substr(pos, 4).toLowerCase() === "mode") {
                                                                    result28 = input.substr(pos, 4);
                                                                    pos += 4;
                                                                  } else {
                                                                    result28 = null;
                                                                    if (reportFailures === 0) {
                                                                      matchFailed("\"MODE\"");
                                                                    }
                                                                  }
                                                                  if (result28 !== null) {
                                                                    result22 = [result22, result23, result24, result25, result26, result27, result28];
                                                                  } else {
                                                                    result22 = null;
                                                                    pos = pos2;
                                                                  }
                                                                } else {
                                                                  result22 = null;
                                                                  pos = pos2;
                                                                }
                                                              } else {
                                                                result22 = null;
                                                                pos = pos2;
                                                              }
                                                            } else {
                                                              result22 = null;
                                                              pos = pos2;
                                                            }
                                                          } else {
                                                            result22 = null;
                                                            pos = pos2;
                                                          }
                                                        } else {
                                                          result22 = null;
                                                          pos = pos2;
                                                        }
                                                      } else {
                                                        result22 = null;
                                                        pos = pos2;
                                                      }
                                                    }
                                                    result22 = result22 !== null ? result22 : "";
                                                    if (result22 !== null) {
                                                      result11 = [result11, result12, result13, result14, result15, result16, result17, result18, result19, result20, result21, result22];
                                                    } else {
                                                      result11 = null;
                                                      pos = pos1;
                                                    }
                                                  } else {
                                                    result11 = null;
                                                    pos = pos1;
                                                  }
                                                } else {
                                                  result11 = null;
                                                  pos = pos1;
                                                }
                                              } else {
                                                result11 = null;
                                                pos = pos1;
                                              }
                                            } else {
                                              result11 = null;
                                              pos = pos1;
                                            }
                                          } else {
                                            result11 = null;
                                            pos = pos1;
                                          }
                                        } else {
                                          result11 = null;
                                          pos = pos1;
                                        }
                                      } else {
                                        result11 = null;
                                        pos = pos1;
                                      }
                                    } else {
                                      result11 = null;
                                      pos = pos1;
                                    }
                                  } else {
                                    result11 = null;
                                    pos = pos1;
                                  }
                                } else {
                                  result11 = null;
                                  pos = pos1;
                                }
                              } else {
                                result11 = null;
                                pos = pos1;
                              }
                              result11 = result11 !== null ? result11 : "";
                              if (result11 !== null) {
                                result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11];
                              } else {
                                result0 = null;
                                pos = pos0;
                              }
                            } else {
                              result0 = null;
                              pos = pos0;
                            }
                          } else {
                            result0 = null;
                            pos = pos0;
                          }
                        } else {
                          result0 = null;
                          pos = pos0;
                        }
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                } else {
                  result0 = null;
                  pos = pos0;
                }
              } else {
                result0 = null;
                pos = pos0;
              }
            } else {
              result0 = null;
              pos = pos0;
            }
          } else {
            result0 = null;
            pos = pos0;
          }
        } else {
          result0 = null;
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("SELECT");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SELECT_EXPRESSION_LIST() {
        var cacheKey = "SELECT_EXPRESSION_LIST@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = parse_SELECT_EXPRESSION();
          if (result1 !== null) {
            result2 = [];
            pos2 = pos;
            pos3 = pos;
            result3 = parse__();
            if (result3 !== null) {
              if (input.charCodeAt(pos) === 44) {
                result4 = ",";
                pos++;
              } else {
                result4 = null;
                if (reportFailures === 0) {
                  matchFailed("\",\"");
                }
              }
              if (result4 !== null) {
                result5 = parse__();
                if (result5 !== null) {
                  result6 = parse_SELECT_EXPRESSION();
                  if (result6 !== null) {
                    result3 = [result3, result4, result5, result6];
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
            } else {
              result3 = null;
              pos = pos3;
            }
            if (result3 !== null) {
              result3 = (function(offset, col) {return col;})(pos2, result3[3]);
            }
            if (result3 === null) {
              pos = pos2;
            }
            while (result3 !== null) {
              result2.push(result3);
              pos2 = pos;
              pos3 = pos;
              result3 = parse__();
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 44) {
                  result4 = ",";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_SELECT_EXPRESSION();
                    if (result6 !== null) {
                      result3 = [result3, result4, result5, result6];
                    } else {
                      result3 = null;
                      pos = pos3;
                    }
                  } else {
                    result3 = null;
                    pos = pos3;
                  }
                } else {
                  result3 = null;
                  pos = pos3;
                }
              } else {
                result3 = null;
                pos = pos3;
              }
              if (result3 !== null) {
                result3 = (function(offset, col) {return col;})(pos2, result3[3]);
              }
              if (result3 === null) {
                pos = pos2;
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, col, tail) {
              tail.unshift(col);
              return tail;
            })(pos0, result0[1], result0[2]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return []; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SELECT_EXPRESSION() {
        var cacheKey = "SELECT_EXPRESSION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse_AGGREGATED_SOURCE();
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            if (input.substr(pos, 2).toLowerCase() === "as") {
              result2 = input.substr(pos, 2);
              pos += 2;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"AS\"");
              }
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                result4 = parse_ID();
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, col, alias) { col.alias = alias; return col; })(pos0, result0[0], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          result0 = parse_AGGREGATED_SOURCE();
          if (result0 === null) {
            pos0 = pos;
            pos1 = pos;
            result0 = parse_SELECT_COLUMN_SOURCE();
            if (result0 !== null) {
              result1 = parse__();
              if (result1 !== null) {
                if (input.substr(pos, 2).toLowerCase() === "as") {
                  result2 = input.substr(pos, 2);
                  pos += 2;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"AS\"");
                  }
                }
                result2 = result2 !== null ? result2 : "";
                if (result2 !== null) {
                  result3 = parse__();
                  if (result3 !== null) {
                    result4 = parse_ID();
                    if (result4 !== null) {
                      result0 = [result0, result1, result2, result3, result4];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
            if (result0 !== null) {
              result0 = (function(offset, col, alias) { col.alias = alias; return col; })(pos0, result0[0], result0[4]);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              result0 = parse_SELECT_COLUMN_SOURCE();
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_AGGREGATION_FUNCTION_NAME() {
        var cacheKey = "AGGREGATION_FUNCTION_NAME@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        if (input.substr(pos, 3).toLowerCase() === "avg") {
          result0 = input.substr(pos, 3);
          pos += 3;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"AVG\"");
          }
        }
        if (result0 === null) {
          if (input.substr(pos, 7).toLowerCase() === "bit_and") {
            result0 = input.substr(pos, 7);
            pos += 7;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"BIT_AND\"");
            }
          }
          if (result0 === null) {
            if (input.substr(pos, 6).toLowerCase() === "bit_or") {
              result0 = input.substr(pos, 6);
              pos += 6;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"BIT_OR\"");
              }
            }
            if (result0 === null) {
              if (input.substr(pos, 7).toLowerCase() === "bit_xor") {
                result0 = input.substr(pos, 7);
                pos += 7;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"BIT_XOR\"");
                }
              }
              if (result0 === null) {
                if (input.substr(pos, 5).toLowerCase() === "count") {
                  result0 = input.substr(pos, 5);
                  pos += 5;
                } else {
                  result0 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"COUNT\"");
                  }
                }
                if (result0 === null) {
                  if (input.substr(pos, 12).toLowerCase() === "group_concat") {
                    result0 = input.substr(pos, 12);
                    pos += 12;
                  } else {
                    result0 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"GROUP_CONCAT\"");
                    }
                  }
                  if (result0 === null) {
                    if (input.substr(pos, 3).toLowerCase() === "max") {
                      result0 = input.substr(pos, 3);
                      pos += 3;
                    } else {
                      result0 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"MAX\"");
                      }
                    }
                    if (result0 === null) {
                      if (input.substr(pos, 3).toLowerCase() === "min") {
                        result0 = input.substr(pos, 3);
                        pos += 3;
                      } else {
                        result0 = null;
                        if (reportFailures === 0) {
                          matchFailed("\"MIN\"");
                        }
                      }
                      if (result0 === null) {
                        if (input.substr(pos, 3).toLowerCase() === "std") {
                          result0 = input.substr(pos, 3);
                          pos += 3;
                        } else {
                          result0 = null;
                          if (reportFailures === 0) {
                            matchFailed("\"STD\"");
                          }
                        }
                        if (result0 === null) {
                          if (input.substr(pos, 10).toLowerCase() === "stddev_pop") {
                            result0 = input.substr(pos, 10);
                            pos += 10;
                          } else {
                            result0 = null;
                            if (reportFailures === 0) {
                              matchFailed("\"STDDEV_POP\"");
                            }
                          }
                          if (result0 === null) {
                            if (input.substr(pos, 11).toLowerCase() === "stddev_samp") {
                              result0 = input.substr(pos, 11);
                              pos += 11;
                            } else {
                              result0 = null;
                              if (reportFailures === 0) {
                                matchFailed("\"STDDEV_SAMP\"");
                              }
                            }
                            if (result0 === null) {
                              if (input.substr(pos, 6).toLowerCase() === "stddev") {
                                result0 = input.substr(pos, 6);
                                pos += 6;
                              } else {
                                result0 = null;
                                if (reportFailures === 0) {
                                  matchFailed("\"STDDEV\"");
                                }
                              }
                              if (result0 === null) {
                                if (input.substr(pos, 3).toLowerCase() === "sum") {
                                  result0 = input.substr(pos, 3);
                                  pos += 3;
                                } else {
                                  result0 = null;
                                  if (reportFailures === 0) {
                                    matchFailed("\"SUM\"");
                                  }
                                }
                                if (result0 === null) {
                                  if (input.substr(pos, 7).toLowerCase() === "var_pop") {
                                    result0 = input.substr(pos, 7);
                                    pos += 7;
                                  } else {
                                    result0 = null;
                                    if (reportFailures === 0) {
                                      matchFailed("\"VAR_POP\"");
                                    }
                                  }
                                  if (result0 === null) {
                                    if (input.substr(pos, 8).toLowerCase() === "var_samp") {
                                      result0 = input.substr(pos, 8);
                                      pos += 8;
                                    } else {
                                      result0 = null;
                                      if (reportFailures === 0) {
                                        matchFailed("\"VAR_SAMP\"");
                                      }
                                    }
                                    if (result0 === null) {
                                      if (input.substr(pos, 8).toLowerCase() === "variance") {
                                        result0 = input.substr(pos, 8);
                                        pos += 8;
                                      } else {
                                        result0 = null;
                                        if (reportFailures === 0) {
                                          matchFailed("\"VARIANCE\"");
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_AGGREGATED_SOURCE() {
        var cacheKey = "AGGREGATED_SOURCE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8;
        var pos0, pos1;
        
        pos0 = pos;
        if (input.substr(pos, 5).toLowerCase() === "count") {
          result0 = input.substr(pos, 5);
          pos += 5;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"COUNT\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            pos1 = pos;
            if (input.charCodeAt(pos) === 40) {
              result2 = "(";
              pos++;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"(\"");
              }
            }
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 42) {
                  result4 = "*";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"*\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    if (input.charCodeAt(pos) === 41) {
                      result6 = ")";
                      pos++;
                    } else {
                      result6 = null;
                      if (reportFailures === 0) {
                        matchFailed("\")\"");
                      }
                    }
                    if (result6 !== null) {
                      result2 = [result2, result3, result4, result5, result6];
                    } else {
                      result2 = null;
                      pos = pos1;
                    }
                  } else {
                    result2 = null;
                    pos = pos1;
                  }
                } else {
                  result2 = null;
                  pos = pos1;
                }
              } else {
                result2 = null;
                pos = pos1;
              }
            } else {
              result2 = null;
              pos = pos1;
            }
            if (result2 === null) {
              if (input.charCodeAt(pos) === 42) {
                result2 = "*";
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"*\"");
                }
              }
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos0;
            }
          } else {
            result0 = null;
            pos = pos0;
          }
        } else {
          result0 = null;
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          if (input.substr(pos, 5).toLowerCase() === "count") {
            result0 = input.substr(pos, 5);
            pos += 5;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"COUNT\"");
            }
          }
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              if (input.charCodeAt(pos) === 40) {
                result2 = "(";
                pos++;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"(\"");
                }
              }
              if (result2 !== null) {
                result3 = parse__();
                if (result3 !== null) {
                  if (input.substr(pos, 8).toLowerCase() === "distinct") {
                    result4 = input.substr(pos, 8);
                    pos += 8;
                  } else {
                    result4 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"DISTINCT\"");
                    }
                  }
                  if (result4 !== null) {
                    result5 = parse___();
                    if (result5 !== null) {
                      result6 = parse_SELECT_COLUMN_SOURCE();
                      if (result6 !== null) {
                        result7 = parse__();
                        if (result7 !== null) {
                          if (input.charCodeAt(pos) === 41) {
                            result8 = ")";
                            pos++;
                          } else {
                            result8 = null;
                            if (reportFailures === 0) {
                              matchFailed("\")\"");
                            }
                          }
                          if (result8 !== null) {
                            result0 = [result0, result1, result2, result3, result4, result5, result6, result7, result8];
                          } else {
                            result0 = null;
                            pos = pos0;
                          }
                        } else {
                          result0 = null;
                          pos = pos0;
                        }
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                } else {
                  result0 = null;
                  pos = pos0;
                }
              } else {
                result0 = null;
                pos = pos0;
              }
            } else {
              result0 = null;
              pos = pos0;
            }
          } else {
            result0 = null;
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            if (input.substr(pos, 5).toLowerCase() === "count") {
              result0 = input.substr(pos, 5);
              pos += 5;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"COUNT\"");
              }
            }
            if (result0 !== null) {
              result1 = parse__();
              if (result1 !== null) {
                if (input.substr(pos, 8).toLowerCase() === "distinct") {
                  result2 = input.substr(pos, 8);
                  pos += 8;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"DISTINCT\"");
                  }
                }
                if (result2 !== null) {
                  if (input.charCodeAt(pos) === 40) {
                    result3 = "(";
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"(\"");
                    }
                  }
                  if (result3 !== null) {
                    result4 = parse__();
                    if (result4 !== null) {
                      result5 = parse_SELECT_COLUMN_SOURCE();
                      if (result5 !== null) {
                        result6 = parse__();
                        if (result6 !== null) {
                          if (input.charCodeAt(pos) === 41) {
                            result7 = ")";
                            pos++;
                          } else {
                            result7 = null;
                            if (reportFailures === 0) {
                              matchFailed("\")\"");
                            }
                          }
                          if (result7 !== null) {
                            result0 = [result0, result1, result2, result3, result4, result5, result6, result7];
                          } else {
                            result0 = null;
                            pos = pos0;
                          }
                        } else {
                          result0 = null;
                          pos = pos0;
                        }
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                } else {
                  result0 = null;
                  pos = pos0;
                }
              } else {
                result0 = null;
                pos = pos0;
              }
            } else {
              result0 = null;
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              if (input.substr(pos, 5).toLowerCase() === "count") {
                result0 = input.substr(pos, 5);
                pos += 5;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"COUNT\"");
                }
              }
              if (result0 !== null) {
                result1 = parse__();
                if (result1 !== null) {
                  if (input.substr(pos, 8).toLowerCase() === "distinct") {
                    result2 = input.substr(pos, 8);
                    pos += 8;
                  } else {
                    result2 = null;
                    if (reportFailures === 0) {
                      matchFailed("\"DISTINCT\"");
                    }
                  }
                  if (result2 !== null) {
                    result3 = parse__();
                    if (result3 !== null) {
                      result4 = parse_SELECT_COLUMN_SOURCE();
                      if (result4 !== null) {
                        result5 = parse__();
                        if (result5 !== null) {
                          result0 = [result0, result1, result2, result3, result4, result5];
                        } else {
                          result0 = null;
                          pos = pos0;
                        }
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                } else {
                  result0 = null;
                  pos = pos0;
                }
              } else {
                result0 = null;
                pos = pos0;
              }
              if (result0 === null) {
                pos0 = pos;
                result0 = parse_AGGREGATION_FUNCTION_NAME();
                if (result0 !== null) {
                  result1 = parse__();
                  if (result1 !== null) {
                    if (input.charCodeAt(pos) === 40) {
                      result2 = "(";
                      pos++;
                    } else {
                      result2 = null;
                      if (reportFailures === 0) {
                        matchFailed("\"(\"");
                      }
                    }
                    if (result2 !== null) {
                      result3 = parse__();
                      if (result3 !== null) {
                        result4 = parse_EXPRESSION();
                        if (result4 !== null) {
                          result5 = parse__();
                          if (result5 !== null) {
                            if (input.charCodeAt(pos) === 41) {
                              result6 = ")";
                              pos++;
                            } else {
                              result6 = null;
                              if (reportFailures === 0) {
                                matchFailed("\")\"");
                              }
                            }
                            if (result6 !== null) {
                              result0 = [result0, result1, result2, result3, result4, result5, result6];
                            } else {
                              result0 = null;
                              pos = pos0;
                            }
                          } else {
                            result0 = null;
                            pos = pos0;
                          }
                        } else {
                          result0 = null;
                          pos = pos0;
                        }
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                } else {
                  result0 = null;
                  pos = pos0;
                }
                if (result0 === null) {
                  pos0 = pos;
                  result0 = parse_AGGREGATION_FUNCTION_NAME();
                  if (result0 !== null) {
                    result1 = parse___();
                    if (result1 !== null) {
                      result2 = parse_EXPRESSION();
                      if (result2 !== null) {
                        result0 = [result0, result1, result2];
                      } else {
                        result0 = null;
                        pos = pos0;
                      }
                    } else {
                      result0 = null;
                      pos = pos0;
                    }
                  } else {
                    result0 = null;
                    pos = pos0;
                  }
                }
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SELECT_COLUMN_SOURCE() {
        var cacheKey = "SELECT_COLUMN_SOURCE@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        result0 = parse__();
        if (result0 !== null) {
          result1 = parse_ID();
          if (result1 !== null) {
            result2 = parse__();
            if (result2 !== null) {
              if (input.charCodeAt(pos) === 46) {
                result3 = ".";
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("\".\"");
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  result5 = parse_ID();
                  if (result5 !== null) {
                    result0 = [result0, result1, result2, result3, result4, result5];
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, table, col) { return { column: col, tableAlias: table }; })(pos0, result0[1], result0[5]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = parse__();
          if (result0 !== null) {
            result1 = parse_ID();
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 !== null) {
            result0 = (function(offset, col) { return { column: col }; })(pos0, result0[1]);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            result0 = parse__();
            if (result0 !== null) {
              result1 = parse_COMPARISON_EXPR();
              if (result1 !== null) {
                result0 = [result0, result1];
              } else {
                result0 = null;
                pos = pos0;
              }
            } else {
              result0 = null;
              pos = pos0;
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_FROM_TABLE_REFERENCES() {
        var cacheKey = "FROM_TABLE_REFERENCES@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        if (input.charCodeAt(pos) === 40) {
          result0 = "(";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"(\"");
          }
        }
        if (result0 !== null) {
          result1 = parse__();
          if (result1 !== null) {
            result2 = parse_ID();
            if (result2 === null) {
              result2 = parse_STRING();
            }
            if (result2 !== null) {
              result3 = [];
              pos2 = pos;
              pos3 = pos;
              result4 = parse__();
              if (result4 !== null) {
                if (input.charCodeAt(pos) === 44) {
                  result5 = ",";
                  pos++;
                } else {
                  result5 = null;
                  if (reportFailures === 0) {
                    matchFailed("\",\"");
                  }
                }
                if (result5 !== null) {
                  result6 = parse__();
                  if (result6 !== null) {
                    result7 = parse_ID();
                    if (result7 === null) {
                      result7 = parse_STRING();
                    }
                    if (result7 !== null) {
                      result4 = [result4, result5, result6, result7];
                    } else {
                      result4 = null;
                      pos = pos3;
                    }
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
              } else {
                result4 = null;
                pos = pos3;
              }
              if (result4 !== null) {
                result4 = (function(offset, col) {return col;})(pos2, result4[3]);
              }
              if (result4 === null) {
                pos = pos2;
              }
              while (result4 !== null) {
                result3.push(result4);
                pos2 = pos;
                pos3 = pos;
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 44) {
                    result5 = ",";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\",\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result7 = parse_ID();
                      if (result7 === null) {
                        result7 = parse_STRING();
                      }
                      if (result7 !== null) {
                        result4 = [result4, result5, result6, result7];
                      } else {
                        result4 = null;
                        pos = pos3;
                      }
                    } else {
                      result4 = null;
                      pos = pos3;
                    }
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
                if (result4 !== null) {
                  result4 = (function(offset, col) {return col;})(pos2, result4[3]);
                }
                if (result4 === null) {
                  pos = pos2;
                }
              }
              if (result3 !== null) {
                result4 = parse__();
                if (result4 !== null) {
                  if (input.charCodeAt(pos) === 41) {
                    result5 = ")";
                    pos++;
                  } else {
                    result5 = null;
                    if (reportFailures === 0) {
                      matchFailed("\")\"");
                    }
                  }
                  if (result5 !== null) {
                    result6 = parse__();
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, col, tail) {
              tail.unshift(col);
              return tail;
            })(pos0, result0[2], result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_SET_STATEMENT() {
        var cacheKey = "SET_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 3).toLowerCase() === "set") {
          result0 = input.substr(pos, 3);
          pos += 3;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"SET\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result2 = parse_ID();
            if (result2 !== null) {
              pos2 = pos;
              result3 = parse__();
              if (result3 !== null) {
                if (input.charCodeAt(pos) === 61) {
                  result4 = "=";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"=\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result3 = [result3, result4, result5];
                  } else {
                    result3 = null;
                    pos = pos2;
                  }
                } else {
                  result3 = null;
                  pos = pos2;
                }
              } else {
                result3 = null;
                pos = pos2;
              }
              if (result3 === null) {
                result3 = parse___();
              }
              if (result3 !== null) {
                result4 = parse_ID();
                if (result4 === null) {
                  result4 = parse_STRING();
                }
                if (result4 !== null) {
                  result0 = [result0, result1, result2, result3, result4];
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, variable, value) {
              return {
                statement: "SET",
                variable: variable,
                value: value
              };
            })(pos0, result0[2], result0[4]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("SET");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_USE_STATEMENT() {
        var cacheKey = "USE_STATEMENT@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1, pos2;
        
        reportFailures++;
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 3).toLowerCase() === "use") {
          result0 = input.substr(pos, 3);
          pos += 3;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"USE\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            pos2 = pos;
            if (input.substr(pos, 8).toLowerCase() === "database") {
              result2 = input.substr(pos, 8);
              pos += 8;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"DATABASE\"");
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos2;
              }
            } else {
              result2 = null;
              pos = pos2;
            }
            result2 = result2 !== null ? result2 : "";
            if (result2 !== null) {
              result3 = parse_ID();
              if (result3 !== null) {
                result0 = [result0, result1, result2, result3];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, name) {
              return { statement: "USE", database: name };
            })(pos0, result0[3]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("USE");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_REFERENCE_DEFINITION() {
        var cacheKey = "REFERENCE_DEFINITION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6, result7, result8;
        var pos0, pos1, pos2, pos3;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 10).toLowerCase() === "references") {
          result0 = input.substr(pos, 10);
          pos += 10;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"REFERENCES\"");
          }
        }
        if (result0 === null) {
          if (input.substr(pos, 2).toLowerCase() === "to") {
            result0 = input.substr(pos, 2);
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"TO\"");
            }
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            result2 = parse_TABLE_NAME();
            if (result2 !== null) {
              result3 = parse__();
              if (result3 !== null) {
                pos2 = pos;
                pos3 = pos;
                if (input.charCodeAt(pos) === 40) {
                  result4 = "(";
                  pos++;
                } else {
                  result4 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"(\"");
                  }
                }
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_ID_LIST();
                    if (result6 !== null) {
                      if (input.charCodeAt(pos) === 41) {
                        result7 = ")";
                        pos++;
                      } else {
                        result7 = null;
                        if (reportFailures === 0) {
                          matchFailed("\")\"");
                        }
                      }
                      if (result7 !== null) {
                        result8 = parse__();
                        if (result8 !== null) {
                          result4 = [result4, result5, result6, result7, result8];
                        } else {
                          result4 = null;
                          pos = pos3;
                        }
                      } else {
                        result4 = null;
                        pos = pos3;
                      }
                    } else {
                      result4 = null;
                      pos = pos3;
                    }
                  } else {
                    result4 = null;
                    pos = pos3;
                  }
                } else {
                  result4 = null;
                  pos = pos3;
                }
                if (result4 !== null) {
                  result4 = (function(offset, cols) { return cols; })(pos2, result4[2]);
                }
                if (result4 === null) {
                  pos = pos2;
                }
                result4 = result4 !== null ? result4 : "";
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_REFERENCE_DEFINITION_ACTIONS();
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, table, cols, actions) {
              return {
                schema: table.schema,
                table: table.table,
                columns: cols,
                actions: actions
              };
            })(pos0, result0[2], result0[4], result0[6]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_REFERENCE_DEFINITION_ACTIONS() {
        var cacheKey = "REFERENCE_DEFINITION_ACTIONS@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3, result4, result5, result6;
        var pos0, pos1;
        
        pos0 = pos;
        pos1 = pos;
        if (input.substr(pos, 2).toLowerCase() === "on") {
          result0 = input.substr(pos, 2);
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"ON\"");
          }
        }
        if (result0 !== null) {
          result1 = parse___();
          if (result1 !== null) {
            if (input.substr(pos, 6).toLowerCase() === "delete") {
              result2 = input.substr(pos, 6);
              pos += 6;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"DELETE\"");
              }
            }
            if (result2 === null) {
              if (input.substr(pos, 6).toLowerCase() === "update") {
                result2 = input.substr(pos, 6);
                pos += 6;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"UPDATE\"");
                }
              }
            }
            if (result2 !== null) {
              result3 = parse___();
              if (result3 !== null) {
                result4 = parse_REFERENCE_DEFINITION_ACTION_OPTION();
                if (result4 !== null) {
                  result5 = parse__();
                  if (result5 !== null) {
                    result6 = parse_REFERENCE_DEFINITION_ACTIONS();
                    if (result6 !== null) {
                      result0 = [result0, result1, result2, result3, result4, result5, result6];
                    } else {
                      result0 = null;
                      pos = pos1;
                    }
                  } else {
                    result0 = null;
                    pos = pos1;
                  }
                } else {
                  result0 = null;
                  pos = pos1;
                }
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
        } else {
          result0 = null;
          pos = pos1;
        }
        if (result0 !== null) {
          result0 = (function(offset, type, action, actions) {
              var name = "ON "+type.toUpperCase();
              if(actions[name])
                throw new Error('Trying to redefine reference action "'+name+'"');
              actions[name] = action;
              return actions;
            })(pos0, result0[2], result0[4], result0[6]);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          pos1 = pos;
          result0 = [];
          if (result0 !== null) {
            result0 = (function(offset) { return {}; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_REFERENCE_DEFINITION_ACTION_OPTION() {
        var cacheKey = "REFERENCE_DEFINITION_ACTION_OPTION@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        var pos0;
        
        pos0 = pos;
        if (input.substr(pos, 8).toLowerCase() === "restrict") {
          result0 = input.substr(pos, 8);
          pos += 8;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"RESTRICT\"");
          }
        }
        if (result0 !== null) {
          result0 = (function(offset) { return 'RESTRICT'; })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          if (input.substr(pos, 7).toLowerCase() === "cascade") {
            result0 = input.substr(pos, 7);
            pos += 7;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"CASCADE\"");
            }
          }
          if (result0 !== null) {
            result0 = (function(offset) { return 'CASCADE'; })(pos0);
          }
          if (result0 === null) {
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            if (input.substr(pos, 8).toLowerCase() === "set null") {
              result0 = input.substr(pos, 8);
              pos += 8;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"SET NULL\"");
              }
            }
            if (result0 !== null) {
              result0 = (function(offset) { return 'SET NULL'; })(pos0);
            }
            if (result0 === null) {
              pos = pos0;
            }
            if (result0 === null) {
              pos0 = pos;
              if (input.substr(pos, 9).toLowerCase() === "no action") {
                result0 = input.substr(pos, 9);
                pos += 9;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"NO ACTION\"");
                }
              }
              if (result0 !== null) {
                result0 = (function(offset) { return 'NO ACTION'; })(pos0);
              }
              if (result0 === null) {
                pos = pos0;
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_CURRENT_TIMESTAMP() {
        var cacheKey = "CURRENT_TIMESTAMP@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        if (input.substr(pos, 17).toLowerCase() === "current_timestamp") {
          result0 = input.substr(pos, 17);
          pos += 17;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"CURRENT_TIMESTAMP\"");
          }
        }
        if (result0 === null) {
          pos1 = pos;
          if (input.substr(pos, 7).toLowerCase() === "current") {
            result0 = input.substr(pos, 7);
            pos += 7;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"CURRENT\"");
            }
          }
          if (result0 !== null) {
            result1 = parse__();
            if (result1 !== null) {
              if (input.substr(pos, 9).toLowerCase() === "timestamp") {
                result2 = input.substr(pos, 9);
                pos += 9;
              } else {
                result2 = null;
                if (reportFailures === 0) {
                  matchFailed("\"TIMESTAMP\"");
                }
              }
              if (result2 !== null) {
                result0 = [result0, result1, result2];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          } else {
            result0 = null;
            pos = pos1;
          }
          if (result0 === null) {
            pos1 = pos;
            if (input.substr(pos, 3).toLowerCase() === "now") {
              result0 = input.substr(pos, 3);
              pos += 3;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"NOW\"");
              }
            }
            if (result0 !== null) {
              pos2 = pos;
              result1 = parse__();
              if (result1 !== null) {
                if (input.substr(pos, 2) === "()") {
                  result2 = "()";
                  pos += 2;
                } else {
                  result2 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"()\"");
                  }
                }
                if (result2 !== null) {
                  result1 = [result1, result2];
                } else {
                  result1 = null;
                  pos = pos2;
                }
              } else {
                result1 = null;
                pos = pos2;
              }
              result1 = result1 !== null ? result1 : "";
              if (result1 !== null) {
                result0 = [result0, result1];
              } else {
                result0 = null;
                pos = pos1;
              }
            } else {
              result0 = null;
              pos = pos1;
            }
          }
        }
        if (result0 !== null) {
          result0 = (function(offset) {
              return options.createValueCurrentTimestamp();
            })(pos0);
        }
        if (result0 === null) {
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_comment() {
        var cacheKey = "comment@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        result0 = parse_singleLineComment();
        if (result0 === null) {
          result0 = parse_multiLineComment();
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_singleLineComment() {
        var cacheKey = "singleLineComment@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        if (input.substr(pos, 2) === "--") {
          result0 = "--";
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"--\"");
          }
        }
        if (result0 !== null) {
          result1 = [];
          pos1 = pos;
          pos2 = pos;
          reportFailures++;
          result2 = parse_eolChar();
          reportFailures--;
          if (result2 === null) {
            result2 = "";
          } else {
            result2 = null;
            pos = pos2;
          }
          if (result2 !== null) {
            if (input.length > pos) {
              result3 = input.charAt(pos);
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("any character");
              }
            }
            if (result3 !== null) {
              result2 = [result2, result3];
            } else {
              result2 = null;
              pos = pos1;
            }
          } else {
            result2 = null;
            pos = pos1;
          }
          while (result2 !== null) {
            result1.push(result2);
            pos1 = pos;
            pos2 = pos;
            reportFailures++;
            result2 = parse_eolChar();
            reportFailures--;
            if (result2 === null) {
              result2 = "";
            } else {
              result2 = null;
              pos = pos2;
            }
            if (result2 !== null) {
              if (input.length > pos) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("any character");
                }
              }
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos1;
              }
            } else {
              result2 = null;
              pos = pos1;
            }
          }
          if (result1 !== null) {
            result0 = [result0, result1];
          } else {
            result0 = null;
            pos = pos0;
          }
        } else {
          result0 = null;
          pos = pos0;
        }
        if (result0 === null) {
          pos0 = pos;
          if (input.charCodeAt(pos) === 35) {
            result0 = "#";
            pos++;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"#\"");
            }
          }
          if (result0 !== null) {
            result1 = [];
            pos1 = pos;
            pos2 = pos;
            reportFailures++;
            result2 = parse_eolChar();
            reportFailures--;
            if (result2 === null) {
              result2 = "";
            } else {
              result2 = null;
              pos = pos2;
            }
            if (result2 !== null) {
              if (input.length > pos) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("any character");
                }
              }
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos1;
              }
            } else {
              result2 = null;
              pos = pos1;
            }
            while (result2 !== null) {
              result1.push(result2);
              pos1 = pos;
              pos2 = pos;
              reportFailures++;
              result2 = parse_eolChar();
              reportFailures--;
              if (result2 === null) {
                result2 = "";
              } else {
                result2 = null;
                pos = pos2;
              }
              if (result2 !== null) {
                if (input.length > pos) {
                  result3 = input.charAt(pos);
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("any character");
                  }
                }
                if (result3 !== null) {
                  result2 = [result2, result3];
                } else {
                  result2 = null;
                  pos = pos1;
                }
              } else {
                result2 = null;
                pos = pos1;
              }
            }
            if (result1 !== null) {
              result0 = [result0, result1];
            } else {
              result0 = null;
              pos = pos0;
            }
          } else {
            result0 = null;
            pos = pos0;
          }
          if (result0 === null) {
            pos0 = pos;
            if (input.substr(pos, 2) === "//") {
              result0 = "//";
              pos += 2;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"//\"");
              }
            }
            if (result0 !== null) {
              result1 = [];
              pos1 = pos;
              pos2 = pos;
              reportFailures++;
              result2 = parse_eolChar();
              reportFailures--;
              if (result2 === null) {
                result2 = "";
              } else {
                result2 = null;
                pos = pos2;
              }
              if (result2 !== null) {
                if (input.length > pos) {
                  result3 = input.charAt(pos);
                  pos++;
                } else {
                  result3 = null;
                  if (reportFailures === 0) {
                    matchFailed("any character");
                  }
                }
                if (result3 !== null) {
                  result2 = [result2, result3];
                } else {
                  result2 = null;
                  pos = pos1;
                }
              } else {
                result2 = null;
                pos = pos1;
              }
              while (result2 !== null) {
                result1.push(result2);
                pos1 = pos;
                pos2 = pos;
                reportFailures++;
                result2 = parse_eolChar();
                reportFailures--;
                if (result2 === null) {
                  result2 = "";
                } else {
                  result2 = null;
                  pos = pos2;
                }
                if (result2 !== null) {
                  if (input.length > pos) {
                    result3 = input.charAt(pos);
                    pos++;
                  } else {
                    result3 = null;
                    if (reportFailures === 0) {
                      matchFailed("any character");
                    }
                  }
                  if (result3 !== null) {
                    result2 = [result2, result3];
                  } else {
                    result2 = null;
                    pos = pos1;
                  }
                } else {
                  result2 = null;
                  pos = pos1;
                }
              }
              if (result1 !== null) {
                result0 = [result0, result1];
              } else {
                result0 = null;
                pos = pos0;
              }
            } else {
              result0 = null;
              pos = pos0;
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_multiLineComment() {
        var cacheKey = "multiLineComment@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1, result2, result3;
        var pos0, pos1, pos2;
        
        pos0 = pos;
        if (input.substr(pos, 2) === "/*") {
          result0 = "/*";
          pos += 2;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"/*\"");
          }
        }
        if (result0 !== null) {
          result1 = [];
          pos1 = pos;
          pos2 = pos;
          reportFailures++;
          if (input.substr(pos, 2) === "*/") {
            result2 = "*/";
            pos += 2;
          } else {
            result2 = null;
            if (reportFailures === 0) {
              matchFailed("\"*/\"");
            }
          }
          reportFailures--;
          if (result2 === null) {
            result2 = "";
          } else {
            result2 = null;
            pos = pos2;
          }
          if (result2 !== null) {
            if (input.length > pos) {
              result3 = input.charAt(pos);
              pos++;
            } else {
              result3 = null;
              if (reportFailures === 0) {
                matchFailed("any character");
              }
            }
            if (result3 !== null) {
              result2 = [result2, result3];
            } else {
              result2 = null;
              pos = pos1;
            }
          } else {
            result2 = null;
            pos = pos1;
          }
          while (result2 !== null) {
            result1.push(result2);
            pos1 = pos;
            pos2 = pos;
            reportFailures++;
            if (input.substr(pos, 2) === "*/") {
              result2 = "*/";
              pos += 2;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"*/\"");
              }
            }
            reportFailures--;
            if (result2 === null) {
              result2 = "";
            } else {
              result2 = null;
              pos = pos2;
            }
            if (result2 !== null) {
              if (input.length > pos) {
                result3 = input.charAt(pos);
                pos++;
              } else {
                result3 = null;
                if (reportFailures === 0) {
                  matchFailed("any character");
                }
              }
              if (result3 !== null) {
                result2 = [result2, result3];
              } else {
                result2 = null;
                pos = pos1;
              }
            } else {
              result2 = null;
              pos = pos1;
            }
          }
          if (result1 !== null) {
            if (input.substr(pos, 2) === "*/") {
              result2 = "*/";
              pos += 2;
            } else {
              result2 = null;
              if (reportFailures === 0) {
                matchFailed("\"*/\"");
              }
            }
            if (result2 !== null) {
              result0 = [result0, result1, result2];
            } else {
              result0 = null;
              pos = pos0;
            }
          } else {
            result0 = null;
            pos = pos0;
          }
        } else {
          result0 = null;
          pos = pos0;
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse__() {
        var cacheKey = "_@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        
        reportFailures++;
        result0 = [];
        result1 = parse_eol();
        if (result1 === null) {
          result1 = parse_whitespace();
          if (result1 === null) {
            result1 = parse_comment();
          }
        }
        while (result1 !== null) {
          result0.push(result1);
          result1 = parse_eol();
          if (result1 === null) {
            result1 = parse_whitespace();
            if (result1 === null) {
              result1 = parse_comment();
            }
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("whitespace");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse___() {
        var cacheKey = "__@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0, result1;
        
        reportFailures++;
        result1 = parse_eol();
        if (result1 === null) {
          result1 = parse_whitespace();
          if (result1 === null) {
            result1 = parse_comment();
          }
        }
        if (result1 !== null) {
          result0 = [];
          while (result1 !== null) {
            result0.push(result1);
            result1 = parse_eol();
            if (result1 === null) {
              result1 = parse_whitespace();
              if (result1 === null) {
                result1 = parse_comment();
              }
            }
          }
        } else {
          result0 = null;
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("whitespace");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_eol() {
        var cacheKey = "eol@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        if (input.charCodeAt(pos) === 10) {
          result0 = "\n";
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("\"\\n\"");
          }
        }
        if (result0 === null) {
          if (input.substr(pos, 2) === "\r\n") {
            result0 = "\r\n";
            pos += 2;
          } else {
            result0 = null;
            if (reportFailures === 0) {
              matchFailed("\"\\r\\n\"");
            }
          }
          if (result0 === null) {
            if (input.charCodeAt(pos) === 13) {
              result0 = "\r";
              pos++;
            } else {
              result0 = null;
              if (reportFailures === 0) {
                matchFailed("\"\\r\"");
              }
            }
            if (result0 === null) {
              if (input.charCodeAt(pos) === 8232) {
                result0 = "\u2028";
                pos++;
              } else {
                result0 = null;
                if (reportFailures === 0) {
                  matchFailed("\"\\u2028\"");
                }
              }
              if (result0 === null) {
                if (input.charCodeAt(pos) === 8233) {
                  result0 = "\u2029";
                  pos++;
                } else {
                  result0 = null;
                  if (reportFailures === 0) {
                    matchFailed("\"\\u2029\"");
                  }
                }
              }
            }
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_eolChar() {
        var cacheKey = "eolChar@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        if (/^[\n\r\u2028\u2029]/.test(input.charAt(pos))) {
          result0 = input.charAt(pos);
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("[\\n\\r\\u2028\\u2029]");
          }
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_whitespace() {
        var cacheKey = "whitespace@" + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        var result0;
        
        reportFailures++;
        if (/^[ \t\x0B\f\r\n\xA0\uFEFF\u1680\u180E\u2000-\u200A\u202F\u205F\u3000]/.test(input.charAt(pos))) {
          result0 = input.charAt(pos);
          pos++;
        } else {
          result0 = null;
          if (reportFailures === 0) {
            matchFailed("[ \\t\\x0B\\f\\r\\n\\xA0\\uFEFF\\u1680\\u180E\\u2000-\\u200A\\u202F\\u205F\\u3000]");
          }
        }
        reportFailures--;
        if (reportFailures === 0 && result0 === null) {
          matchFailed("whitespace");
        }
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      
      function cleanupExpected(expected) {
        expected.sort();
        
        var lastExpected = null;
        var cleanExpected = [];
        for (var i = 0; i < expected.length; i++) {
          if (expected[i] !== lastExpected) {
            cleanExpected.push(expected[i]);
            lastExpected = expected[i];
          }
        }
        return cleanExpected;
      }
      
      function computeErrorPosition() {
        /*
         * The first idea was to use |String.split| to break the input up to the
         * error position along newlines and derive the line and column from
         * there. However IE's |split| implementation is so broken that it was
         * enough to prevent it.
         */
        
        var line = 1;
        var column = 1;
        var seenCR = false;
        
        for (var i = 0; i < Math.max(pos, rightmostFailuresPos); i++) {
          var ch = input.charAt(i);
          if (ch === "\n") {
            if (!seenCR) { line++; }
            column = 1;
            seenCR = false;
          } else if (ch === "\r" || ch === "\u2028" || ch === "\u2029") {
            line++;
            column = 1;
            seenCR = true;
          } else {
            column++;
            seenCR = false;
          }
        }
        
        return { line: line, column: column };
      }
      
      
        var options = arguments[2];
        if(!(options && options.isParseOptions))
          throw new Error("Parser require ParseOptions instance as 3rd argument");
      
        function safeMergeObject(target, src, resolveCallback) {
          for(var name in src) {
            if(typeof target[name] === 'undefined') {
              target[name] = src[name];
            } else {
              var result;
              if(resolveCallback) {
                result = resolveCallback(name, target[name], src[name]);
                if(typeof result === 'undefined')
                  throw new Error('Ambiguous property '+name);
                target[name] = result;
              } else {
                throw new Error('Ambiguous property '+name);
              }
            }
          }
        }
      
      
      
      var result = parseFunctions[startRule]();
      
      /*
       * The parser is now in one of the following three states:
       *
       * 1. The parser successfully parsed the whole input.
       *
       *    - |result !== null|
       *    - |pos === input.length|
       *    - |rightmostFailuresExpected| may or may not contain something
       *
       * 2. The parser successfully parsed only a part of the input.
       *
       *    - |result !== null|
       *    - |pos < input.length|
       *    - |rightmostFailuresExpected| may or may not contain something
       *
       * 3. The parser did not successfully parse any part of the input.
       *
       *   - |result === null|
       *   - |pos === 0|
       *   - |rightmostFailuresExpected| contains at least one failure
       *
       * All code following this comment (including called functions) must
       * handle these states.
       */
      if (result === null || pos !== input.length) {
        var offset = Math.max(pos, rightmostFailuresPos);
        var found = offset < input.length ? input.charAt(offset) : null;
        var errorPosition = computeErrorPosition();
        
        throw new this.SyntaxError(
          cleanupExpected(rightmostFailuresExpected),
          found,
          offset,
          errorPosition.line,
          errorPosition.column
        );
      }
      
      return result;
    },
    
    /* Returns the parser source code. */
    toSource: function() { return this._source; }
  };
  
  /* Thrown when a parser encounters a syntax error. */
  
  result.SyntaxError = function(expected, found, offset, line, column) {
    function buildMessage(expected, found) {
      var expectedHumanized, foundHumanized;
      
      switch (expected.length) {
        case 0:
          expectedHumanized = "end of input";
          break;
        case 1:
          expectedHumanized = expected[0];
          break;
        default:
          expectedHumanized = expected.slice(0, expected.length - 1).join(", ")
            + " or "
            + expected[expected.length - 1];
      }
      
      foundHumanized = found ? quote(found) : "end of input";
      
      return "Expected " + expectedHumanized + " but " + foundHumanized + " found.";
    }
    
    this.name = "SyntaxError";
    this.expected = expected;
    this.found = found;
    this.message = buildMessage(expected, found);
    this.offset = offset;
    this.line = line;
    this.column = column;
  };
  
  result.SyntaxError.prototype = Error.prototype;
  
  return result;
})();

},{}],5:[function(require,module,exports){

var parser = exports.parser = require('./sqljs-parser');


exports.parse = parser.parse.bind(parser);


exports.ParseOptions = require('./parse-options');


exports.ParserError = exports.parser.SyntaxError;


exports.prettyError = require('./error-formatter');

},{"./error-formatter":2,"./parse-options":3,"./sqljs-parser":4}],6:[function(require,module,exports){
/*
colors.js

Copyright (c) 2010

Marak Squires
Alexis Sellier (cloudhead)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

var isHeadless = false;

if (typeof module !== 'undefined') {
  isHeadless = true;
}

if (!isHeadless) {
  var exports = {};
  var module = {};
  var colors = exports;
  exports.mode = "browser";
} else {
  exports.mode = "console";
}

//
// Prototypes the string object to have additional method calls that add terminal colors
//
var addProperty = function (color, func) {
  exports[color] = function (str) {
    return func.apply(str);
  };
  String.prototype.__defineGetter__(color, func);
};

function stylize(str, style) {

  var styles;

  if (exports.mode === 'console') {
    styles = {
      //styles
      'bold'      : ['\x1B[1m',  '\x1B[22m'],
      'italic'    : ['\x1B[3m',  '\x1B[23m'],
      'underline' : ['\x1B[4m',  '\x1B[24m'],
      'inverse'   : ['\x1B[7m',  '\x1B[27m'],
      'strikethrough' : ['\x1B[9m',  '\x1B[29m'],
      //text colors
      //grayscale
      'white'     : ['\x1B[37m', '\x1B[39m'],
      'grey'      : ['\x1B[90m', '\x1B[39m'],
      'black'     : ['\x1B[30m', '\x1B[39m'],
      //colors
      'blue'      : ['\x1B[34m', '\x1B[39m'],
      'cyan'      : ['\x1B[36m', '\x1B[39m'],
      'green'     : ['\x1B[32m', '\x1B[39m'],
      'magenta'   : ['\x1B[35m', '\x1B[39m'],
      'red'       : ['\x1B[31m', '\x1B[39m'],
      'yellow'    : ['\x1B[33m', '\x1B[39m'],
      //background colors
      //grayscale
      'whiteBG'     : ['\x1B[47m', '\x1B[49m'],
      'greyBG'      : ['\x1B[49;5;8m', '\x1B[49m'],
      'blackBG'     : ['\x1B[40m', '\x1B[49m'],
      //colors
      'blueBG'      : ['\x1B[44m', '\x1B[49m'],
      'cyanBG'      : ['\x1B[46m', '\x1B[49m'],
      'greenBG'     : ['\x1B[42m', '\x1B[49m'],
      'magentaBG'   : ['\x1B[45m', '\x1B[49m'],
      'redBG'       : ['\x1B[41m', '\x1B[49m'],
      'yellowBG'    : ['\x1B[43m', '\x1B[49m']
    };
  } else if (exports.mode === 'browser') {
    styles = {
      //styles
      'bold'      : ['<b>',  '</b>'],
      'italic'    : ['<i>',  '</i>'],
      'underline' : ['<u>',  '</u>'],
      'inverse'   : ['<span style="background-color:black;color:white;">',  '</span>'],
      'strikethrough' : ['<del>',  '</del>'],
      //text colors
      //grayscale
      'white'     : ['<span style="color:white;">',   '</span>'],
      'grey'      : ['<span style="color:gray;">',    '</span>'],
      'black'     : ['<span style="color:black;">',   '</span>'],
      //colors
      'blue'      : ['<span style="color:blue;">',    '</span>'],
      'cyan'      : ['<span style="color:cyan;">',    '</span>'],
      'green'     : ['<span style="color:green;">',   '</span>'],
      'magenta'   : ['<span style="color:magenta;">', '</span>'],
      'red'       : ['<span style="color:red;">',     '</span>'],
      'yellow'    : ['<span style="color:yellow;">',  '</span>'],
      //background colors
      //grayscale
      'whiteBG'     : ['<span style="background-color:white;">',   '</span>'],
      'greyBG'      : ['<span style="background-color:gray;">',    '</span>'],
      'blackBG'     : ['<span style="background-color:black;">',   '</span>'],
      //colors
      'blueBG'      : ['<span style="background-color:blue;">',    '</span>'],
      'cyanBG'      : ['<span style="background-color:cyan;">',    '</span>'],
      'greenBG'     : ['<span style="background-color:green;">',   '</span>'],
      'magentaBG'   : ['<span style="background-color:magenta;">', '</span>'],
      'redBG'       : ['<span style="background-color:red;">',     '</span>'],
      'yellowBG'    : ['<span style="background-color:yellow;">',  '</span>']
    };
  } else if (exports.mode === 'none') {
    return str + '';
  } else {
    console.log('unsupported mode, try "browser", "console" or "none"');
  }
  return styles[style][0] + str + styles[style][1];
}

function applyTheme(theme) {

  //
  // Remark: This is a list of methods that exist
  // on String that you should not overwrite.
  //
  var stringPrototypeBlacklist = [
    '__defineGetter__', '__defineSetter__', '__lookupGetter__', '__lookupSetter__', 'charAt', 'constructor',
    'hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable', 'toLocaleString', 'toString', 'valueOf', 'charCodeAt',
    'indexOf', 'lastIndexof', 'length', 'localeCompare', 'match', 'replace', 'search', 'slice', 'split', 'substring',
    'toLocaleLowerCase', 'toLocaleUpperCase', 'toLowerCase', 'toUpperCase', 'trim', 'trimLeft', 'trimRight'
  ];

  Object.keys(theme).forEach(function (prop) {
    if (stringPrototypeBlacklist.indexOf(prop) !== -1) {
      console.log('warn: '.red + ('String.prototype' + prop).magenta + ' is probably something you don\'t want to override. Ignoring style name');
    }
    else {
      if (typeof(theme[prop]) === 'string') {
        addProperty(prop, function () {
          return exports[theme[prop]](this);
        });
      }
      else {
        addProperty(prop, function () {
          var ret = this;
          for (var t = 0; t < theme[prop].length; t++) {
            ret = exports[theme[prop][t]](ret);
          }
          return ret;
        });
      }
    }
  });
}


//
// Iterate through all default styles and colors
//
var x = ['bold', 'underline', 'strikethrough', 'italic', 'inverse', 'grey', 'black', 'yellow', 'red', 'green', 'blue', 'white', 'cyan', 'magenta', 'greyBG', 'blackBG', 'yellowBG', 'redBG', 'greenBG', 'blueBG', 'whiteBG', 'cyanBG', 'magentaBG'];
x.forEach(function (style) {

  // __defineGetter__ at the least works in more browsers
  // http://robertnyman.com/javascript/javascript-getters-setters.html
  // Object.defineProperty only works in Chrome
  addProperty(style, function () {
    return stylize(this, style);
  });
});

function sequencer(map) {
  return function () {
    if (!isHeadless) {
      return this.replace(/( )/, '$1');
    }
    var exploded = this.split(""), i = 0;
    exploded = exploded.map(map);
    return exploded.join("");
  };
}

var rainbowMap = (function () {
  var rainbowColors = ['red', 'yellow', 'green', 'blue', 'magenta']; //RoY G BiV
  return function (letter, i, exploded) {
    if (letter === " ") {
      return letter;
    } else {
      return stylize(letter, rainbowColors[i++ % rainbowColors.length]);
    }
  };
})();

exports.themes = {};

exports.addSequencer = function (name, map) {
  addProperty(name, sequencer(map));
};

exports.addSequencer('rainbow', rainbowMap);
exports.addSequencer('zebra', function (letter, i, exploded) {
  return i % 2 === 0 ? letter : letter.inverse;
});

exports.setTheme = function (theme) {
  if (typeof theme === 'string') {
    try {
      exports.themes[theme] = require(theme);
      applyTheme(exports.themes[theme]);
      return exports.themes[theme];
    } catch (err) {
      console.log(err);
      return err;
    }
  } else {
    applyTheme(theme);
  }
};


addProperty('stripColors', function () {
  return ("" + this).replace(/\x1B\[\d+m/g, '');
});

// please no
function zalgo(text, options) {
  var soul = {
    "up" : [
      '̍', '̎', '̄', '̅',
      '̿', '̑', '̆', '̐',
      '͒', '͗', '͑', '̇',
      '̈', '̊', '͂', '̓',
      '̈', '͊', '͋', '͌',
      '̃', '̂', '̌', '͐',
      '̀', '́', '̋', '̏',
      '̒', '̓', '̔', '̽',
      '̉', 'ͣ', 'ͤ', 'ͥ',
      'ͦ', 'ͧ', 'ͨ', 'ͩ',
      'ͪ', 'ͫ', 'ͬ', 'ͭ',
      'ͮ', 'ͯ', '̾', '͛',
      '͆', '̚'
    ],
    "down" : [
      '̖', '̗', '̘', '̙',
      '̜', '̝', '̞', '̟',
      '̠', '̤', '̥', '̦',
      '̩', '̪', '̫', '̬',
      '̭', '̮', '̯', '̰',
      '̱', '̲', '̳', '̹',
      '̺', '̻', '̼', 'ͅ',
      '͇', '͈', '͉', '͍',
      '͎', '͓', '͔', '͕',
      '͖', '͙', '͚', '̣'
    ],
    "mid" : [
      '̕', '̛', '̀', '́',
      '͘', '̡', '̢', '̧',
      '̨', '̴', '̵', '̶',
      '͜', '͝', '͞',
      '͟', '͠', '͢', '̸',
      '̷', '͡', ' ҉'
    ]
  },
  all = [].concat(soul.up, soul.down, soul.mid),
  zalgo = {};

  function randomNumber(range) {
    var r = Math.floor(Math.random() * range);
    return r;
  }

  function is_char(character) {
    var bool = false;
    all.filter(function (i) {
      bool = (i === character);
    });
    return bool;
  }

  function heComes(text, options) {
    var result = '', counts, l;
    options = options || {};
    options["up"] = options["up"] || true;
    options["mid"] = options["mid"] || true;
    options["down"] = options["down"] || true;
    options["size"] = options["size"] || "maxi";
    text = text.split('');
    for (l in text) {
      if (is_char(l)) {
        continue;
      }
      result = result + text[l];
      counts = {"up" : 0, "down" : 0, "mid" : 0};
      switch (options.size) {
      case 'mini':
        counts.up = randomNumber(8);
        counts.min = randomNumber(2);
        counts.down = randomNumber(8);
        break;
      case 'maxi':
        counts.up = randomNumber(16) + 3;
        counts.min = randomNumber(4) + 1;
        counts.down = randomNumber(64) + 3;
        break;
      default:
        counts.up = randomNumber(8) + 1;
        counts.mid = randomNumber(6) / 2;
        counts.down = randomNumber(8) + 1;
        break;
      }

      var arr = ["up", "mid", "down"];
      for (var d in arr) {
        var index = arr[d];
        for (var i = 0 ; i <= counts[index]; i++) {
          if (options[index]) {
            result = result + soul[index][randomNumber(soul[index].length)];
          }
        }
      }
    }
    return result;
  }
  return heComes(text);
}


// don't summon zalgo
addProperty('zalgo', function () {
  return zalgo(this);
});

},{}]},{},[1])
;