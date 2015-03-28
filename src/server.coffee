# Includes
express      = require 'express'
http         = require 'http'
dataStore    = require './dataStore'
recorder     = require './responseRecorder'
fileScanner  = require './fileScanner'
config       = require './config'



# -------------------------------------------------- Local Variables
app = express()
server = undefined # scope control


# -------------------------------------------------- Private Methods
onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log('Listening on ' + bind);

proxyRequestAndRecordResponse = (req, res, next) ->
  console.log "recording api responses"
  next()






# -------------------------------------------------- Public Methods/Exports
# Start with recording
record = (api) ->
  app.use proxyRequestAndRecordResponse
  start()

# Start without recording
start = (port) ->
  app.use dataStore.fetchDataForRequest
  console.log "Starting express server"
  server = http.createServer app
  server.listen port || config.defaultPort
  server.on 'error', onError
  server.on 'listening', onListening
#    console.log "Found the following JSON data: ", JSON.stringify fileScanner.get(), null, 2


module.exports =
  record: record
  start: start




