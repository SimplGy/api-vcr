#! /usr/bin/env node

// This file can't be in coffeescript, because of some baloney with parsing a she-bang comment as a comment:
// https://github.com/jashkenas/coffeescript/issues/2215
// The script must have a shebang in order to create the .cmd shim on windows:
// https://github.com/ForbesLindesay/cmd-shim/blob/f59af911f1373239a7537072641d55ff882c3701/index.js#L22

var config, minimist, options, url, vcr;

vcr      = require('./src/vcr');
minimist = require('minimist');
url      = require('url');
config   = require('./src/config');

console.log('');
console.log('apiVCR Starting');
console.log('---------------');

options = minimist(process.argv.slice(2));

if (!options.api) {
  throw "Need an API server specified. eg: `node start.js --api=http://api.pickle.com`";
}

config.api = url.parse(options.api);

if (options.noSiblings) {
  config.sameSameSiblings = false;
}
if (config.api.port) {
  config.port = config.api.port;
}
if (options.port) {
  config.port = options.port;
}
if (options.data) {
  config.rootPath = options.data;
}
if (options.record) {
  vcr.record();
}

config.computeFilePath();

vcr.start();

