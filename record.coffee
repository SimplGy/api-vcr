# This script starts the project in `record` mode, which proxies requests to a specified API server and records the responses as they come back

server = require './src/server.js'


# Get the name of the API server
api = process.argv[2]
if !api or api is ''
  console.warn "You must specify an api server to record: `node record.js http://api.magicalsailboat.com`"
  return 1
console.log "Asked to record this API: `#{api}`"


server.start()