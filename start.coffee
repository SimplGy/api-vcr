server    = require './src/server'
minimist  = require 'minimist'
url       = require 'url'
config    = require './src/config'
dataStore = require './src/dataStore'

console.log ''
console.log 'apiVCR Starting'
console.log '---------------'

options = minimist process.argv.slice(2)

unless options.api then throw "Need an API server specified. eg: `node start.js --api=http://api.pickle.com`"
config.api      = url.parse options.api                # Need an API server for data storage scoping
config.port     = config.api.port if config.api.port   # Use the api port as the default port.
config.port     = options.port if options.port         # Support port overriding. Useful for running multiple servers at once
config.rootPath = options.data if options.data         # Support changing the path where the data lives
server.record() if options.record                      # Tell the server to proxy and record requests

#console.log 'config.api', config.api
config.computeFilePath()

server.start()













