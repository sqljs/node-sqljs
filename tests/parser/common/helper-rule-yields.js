
var sqljs = require('../../../.');


module.exports = function(rule_name, values, test_method, test) {

  if(!test) {
    test = test_method;
    test_method = undefined;
  }

  if(!test_method)
    test_method = test.strictEqual;
  if(typeof test_method === 'string')
    test_method = test[test_method];

  test.expect(values.length);
  values.forEach(function(vals){
    var input, actual, expected, opts;
    if(Array.isArray(vals)) {
      input = vals[0];
      expected = vals[1];
      opts = vals[2] || {};
    } else {
      input = expected = vals;
      opts = {};
    }

    actual = null;
    
    if(expected === Error || expected === SyntaxError || expected === sqljs.SyntaxError) {
      test.throws(function() { 
        actual = sqljs.parse(input, rule_name, opts); 
      }, expected, "Parser input: '"+input+"'");
    } else {
      try {
        actual = sqljs.parse(input, rule_name, opts); 
        test_method.call(test, actual, expected, "Parser input: '"+input+"'");
      } catch(err) {
        test.ok(false, "Unexpected exception");
        console.log(sqljs.prettyError(err, input, true));
      }
    }      

  });

  test.done();
};

