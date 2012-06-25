
var parser = exports.parser = require('./sqljs-parser');


exports.parse = parser.parse.bind(parser);


exports.ParseOptions = require('./parse-options');


exports.ParserError = exports.parser.SyntaxError;


exports.prettyError = require('./error-formatter');
