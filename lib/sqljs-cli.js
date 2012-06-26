
var fs = require('fs');
var program = require('commander');
var pkg = require('../package');
var sqljs = require('..');
var colors = require('colors');
//var tty = require('tty');


var use_colors = true; //tty.isatty(console.error);

program
  .version(pkg.version)
  .usage('[options] [file]')
  .option('-e, --eval <string>', 'set input from argument instead of file or stdin')
  .option('-j, --json [file]', 'output parsed file as JSON')
  .option('--input-encoding <encoding>', 'input encoding (default utf8)')
  .option('--output-encoding <encoding>', 'output encoding (default utf8)')
  .option('--start-rule <rule>', 'grammar start rule')
  .parse(process.argv);


if(program.args.length === 0) {
  if(typeof program.eval !== 'undefined') {
    processInput(program.eval);
  } else {
    setInputStream(process.stdin);
  }
} else if(program.args.length === 1) {
  processInput(fs.readFileSync(program.args[0], program.inputEncoding || 'utf8'));
} else {
  console.error("Invalid arguments, see --help");
  process.exit(1);
}


function setInputStream(stream) {
  var data = [];
  stream.setEncoding(program.inputEncoding || 'utf8');
  stream.on('data', function (chunk) {
    data.push(chunk);
  });
  stream.once('end', function () {
    processInput(data.join(''));
  });
  stream.resume();
}



function processInput(text) {

  try {
    var parsed = sqljs.parse(text, program.startRule, new sqljs.ParseOptions);
    if(typeof parsed === 'undefined')
      throw new Error('Output is empty');
  } catch(err) {
    console.error(sqljs.prettyError(err, text, use_colors));
    return process.exit(1);
  }

  if(program.json) {
    var jsonfile = (program.json === true) 
      ? process.stdout 
      : fs.createWriteStream(program.json, {
          flags: 'w',
          encoding: program.outputEncoding || 'utf8'
        });

    jsonfile.write(JSON.stringify(parsed, null, 2));
    jsonfile.write('\n');

    if(jsonfile !== process.stdout)
      jsonfile.end();

  }

  // require('repl').start().context.p = program;
}