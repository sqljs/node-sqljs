
var fs = require('fs');
var program = require('commander');
var pkg = require('../package');
var sqljs = require('..');
var colors = require('colors');



program
  .version(pkg.version)
  .usage('[options] [file]')
  .option('-e, --eval <string>', 'set input from argument instead of file or stdin')
  .option('-j, --json [file]', 'output parsed file as JSON')
  .option('--input-encoding <encoding>', 'input encoding (default utf8)')
  .option('--output-encoding <encoding>', 'output encoding (default utf8)')
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
    var parsed = sqljs.parse(text);
  } catch(err) {
    if(err instanceof sqljs.ParserError) {
      console.error(err.toString().red.bold);
      console.error([
        "At line ", colors.bold(err.line),
        " column ", colors.bold(err.column),
        " offset ", colors.bold(err.offset),
        ].join(''));
      console.error("Expected one of:\n\t"+err.expected.join('\n\t').yellow.bold);

      console.error("Source listing:".underline);
      var lines = text.split('\n');
      var start = Math.max(err.line-6, 0);
      lines = lines.slice(start, err.line+5);
      for(var i=0,l=lines.length; i<l; i++) {
        if(start+i+1 === err.line) {
          var line = lines[i];
          console.error('%s\t%s%s',(start+i+1).toString().green, line.slice(0, err.column-1), line.slice(err.column-1).red.bold);
        } else {
          console.error('%s\t%s',(start+i+1).toString().green,lines[i]);
        }
      }
    } else {
      console.error(err);
    }
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