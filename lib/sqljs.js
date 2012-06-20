
var parser = exports.parser = require('./sqljs-parser');


exports.parse = parser.parse.bind(parser);


exports.ParserError = exports.parser.SyntaxError;


