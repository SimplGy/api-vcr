server    = require './src/server'
minimist  = require 'minimist'
url       = require 'url'
config    = require './src/config'


console.log ''
console.log 'Starting apiVCR'
console.log '---------------'

options = minimist process.argv.slice(2)

# If we're starting with the recording option set, get the server proxying those requests
if options.record
  if url.parse(options.record).href
    config.record = options.record # so other modules can get to it
    server.record config.record
  else
    console.warn "Need to specify a valid url if you want to record: `node start.js --record=api.magicalsailboat.com`"
    console.warn "Your `record` option parsed to this url: ", url.parse(options.record)
    return 61

# Support port overriding. Important for running multiple servers at once
config.port = options.port if options.port

server.start()













