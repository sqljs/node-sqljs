
var parser = require('../../../lib/sqljs-parser');



module.exports = function(rule_name, values, test, test_method) {

  if(!test_method)
    test_method = test.strictEqual;

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
    
    test.doesNotThrow(function() { 
      actual = parser.parse(input, rule_name); 
    }, parser.SyntaxError);

    test_method.call(test, actual, expected);

  });

  test.done();
};

