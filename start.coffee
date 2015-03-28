server    = require './src/server'
minimist  = require 'minimist'
url       = require 'url'
config    = require './src/config'


console.log ''
console.log 'apiVCR Starting'
console.log '---------------'

options = minimist process.argv.slice(2)

# Support changing the path where the data lives
if options.data
  config.rootPath = options.data
console.log "Using data directory: `#{config.rootPath}`"

# If we're starting with the recording option set, get the server proxying those requests
if options.record

  apiUrl = url.parse options.record
  if apiUrl.hostname
    config.api = apiUrl # so other modules can get to it
    server.record()
  else
    console.warn "Need to specify a valid url if you want to record: `node start.js --record=api.magicalsailboat.com`"
    console.warn "Your `record` option parsed to this url object: ", apiUrl
    return 61

  # Use the api port as the default port. Makes keeping proxies straight a little easier if you have remote APIs identified by port.
  config.port = config.api.port if config.api.port




# Support port overriding. Important for running multiple servers at once
config.port = options.port if options.port



server.start()













