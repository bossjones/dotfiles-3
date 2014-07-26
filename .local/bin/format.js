#!/usr/bin/env node

var fs = require('fs');

process.argv.slice(2).forEach(function(filePath) {
  var data;

  var opts = { encoding: 'utf8' };

  try {
    data = fs.readFileSync(filePath, opts);
    data = JSON.parse(data);
    data = JSON.stringify(data, null, 2);

    fs.writeFileSync(filePath, data, opts);
  } catch (err) {
    console.log('error: ' + filePath + ': ' + err.message);
    return;
  }
});
