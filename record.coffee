# This script starts the project in `record` mode, which proxies requests to a specified API server and records the responses as they come back
console.log 'Starting apiVCR in record mode'
console.log ''
console.log '      ᕙ༼ ,,ԾܫԾ,, ༽ᕗ        '
console.log ''

# Get the name of the API server
api = process.argv[2]
if !api or api is ''
  console.warn "You must specify an api server to record: `node record.js http://api.magicalsailboat.com`"
  return 1

require('./src/server.js').record api