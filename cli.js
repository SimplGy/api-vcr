#! /usr/bin/env node

// This file can't be in coffeescript, because of some baloney with parsing a she-bang comment as a comment:
// https://github.com/jashkenas/coffeescript/issues/2215
// The script must have a shebang in order to create the .cmd shim on windows:
// https://github.com/ForbesLindesay/cmd-shim/blob/f59af911f1373239a7537072641d55ff882c3701/index.js#L22

var config, minimist, options, url, vcr, pkg;

vcr      = require('./src/vcr');
minimist = require('minimist');
url      = require('url');
config   = require('./src/config');
fileIO   = require('./src/fileIO');
pkg      = require('./package.json');



console.log('');
console.log('apiVCR '+ pkg.version +' Starting');
console.log('----------------------');

options = minimist(process.argv.slice(2));

mightBeApi = options._[0]
if (!mightBeApi) {
  throw "Need an API server specified. eg: `api-vcr http://api.pickle.com`";
}
config.api = url.parse(mightBeApi);
if (config.api.pathname === config.api.href && config.api.path === config.api.href) {
  throw "API server specified doesn't look like a url: " + mightBeApi;
}

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

config.computeFilePath();

if (options.record) {
  vcr.record();
} else if (!fileIO.count()) {
  process.exit(12) // if we aren't recording AND there are no files, this is an error
}

vcr.start();

