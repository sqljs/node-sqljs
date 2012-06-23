
var parser = exports.parser = require('./sqljs-parser');
var colors = require('colors');


exports.parse = parser.parse.bind(parser);


exports.ParserError = exports.parser.SyntaxError;


exports.prettyError = function(err, source, useColors) {
  var k = function(a) { return a; };
  var bold = k
    , yellow_bold = k
    , red_bold = k
    , underline = k
    ;

  if(useColors) {
    bold = function(str) { return colors.bold(str); }
    red_bold = function(str) { return colors.bold(colors.red(str)); }
    yellow_bold = function(str) { return colors.bold(colors.yellow(str)); }
    underline = function(str) { return colors.underline(str); }
  }


  if(err instanceof exports.ParserError) {
    console.error(red_bold(err.toString()));
    console.error([
      "At line ", bold(err.line),
      " column ", bold(err.column),
      " offset ", bold(err.offset),
      ].join(''));
    console.error("Expected one of:\n"+yellow_bold(err.expected.join('\t')));

    if(source) {
      console.error(underline("Source listing:"));
      var lines = source.split('\n');
      var start = Math.max(err.line-6, 0);
      lines = lines.slice(start, err.line+25);
      for(var i=0,l=lines.length; i<l; i++) {
        if(start+i+1 === err.line) {
          var line = lines[i];
          console.error('%s\t%s%s',(start+i+1).toString().green, line.slice(0, err.column-1), line.slice(err.column-1).red.bold);
        } else {
          console.error('%s\t%s',(start+i+1).toString().green,lines[i]);
        }
      }
    }
  } else {
    console.error(err);
  }
}