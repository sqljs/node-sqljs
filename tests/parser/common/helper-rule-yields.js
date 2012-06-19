
var parser = require('../../../lib/sqljs-parser');



module.exports = function(rule_name, values, test_method, test) {

  if(!test) {
    test = test_method;
    test_method = undefined;
  }

  if(!test_method)
    test_method = test.strictEqual;
  if(typeof test_method === 'string')
    test_method = test[test_method];

  test.expect(values.length * 2);
  values.forEach(function(vals){
    var input, actual, expected;
    if(Array.isArray(vals)) {
      input = vals[0];
      expected = vals[1];
    } else {
      input = expected = vals;
    }

    actual = null;
    
    if(expected === Error || expected === SyntaxError || expected === parser.SyntaxError) {
      test.throws(function() { 
        actual = parser.parse(input, rule_name); 
      }, expected, "Parser input: '"+input+"'");
      test.ok(true); // fake - to count
    } else {
      test.doesNotThrow(function() { 
        actual = parser.parse(input, rule_name); 
      }, parser.SyntaxError, "Parser input: '"+input+"'");

      test_method.call(test, actual, expected, "Parser input: '"+input+"'");
    }      

  });

  test.done();
};

