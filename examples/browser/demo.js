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
