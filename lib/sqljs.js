
var parser = exports.parser = require('./sqljs-parser');
var colors = require('colors');


exports.parse = parser.parse.bind(parser);


exports.ParserError = exports.parser.SyntaxError;


exports.prettyError = function(err, source, useColors) {

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
    output.push("Expected one of:", yellow_bold(err.expected.join('\t')));

  if(source && err.line) {
    output.push(underline("Source listing:"));
    var lines = source.split('\n');
    var start = Math.max(err.line-6, 0);
    lines = lines.slice(start, err.line+25);
    for(var i=0,l=lines.length; i<l; i++) {
      if(start+i+1 === err.line) {
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