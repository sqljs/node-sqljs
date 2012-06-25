
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

    opts = new sqljs.ParseOptions();

    if(Array.isArray(vals)) {
      input = vals[0];
      expected = vals[1];
      if(vals[2]) {
        if(vals[2].isParseOptions) {
          opts = vals[2];
        } else {
          for(var key in vals[2])
            opts[key] = vals[2][key];
        }
      }
    } else {
      input = expected = vals;
    }

    actual = null;

    if(expected === Error || expected === SyntaxError || expected === sqljs.SyntaxError) {
      test.throws(function() { 
        actual = sqljs.parse(input, rule_name, opts); 
      }, function(err) {
        return err instanceof expected;
      }, "Parser input: '"+input+"'");
    } else {
      try {
        actual = sqljs.parse(input, rule_name, opts); 
        test_method.call(test, actual, expected, "Parser input: '"+input+"'");
      } catch(err) {
        test.ok(false, "Exception: " + sqljs.prettyError(err, input, true));
      }
    }      

  });

  test.done();
};

