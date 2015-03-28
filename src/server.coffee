# Includes
express      = require 'express'
http         = require 'http'
config       = require './config'
dataStore    = require './dataStore'
apiRecorder  = require './apiRecorder'
fileScanner  = require './fileScanner'




# -------------------------------------------------- Local Variables
app = express()
server = undefined # scope control


# -------------------------------------------------- Private Methods
onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log('Express server listening on ' + bind);






# -------------------------------------------------- Public Methods/Exports
# Start with recording
record = (api) ->
#  console.log "Configuring to record this api: #{api}"
  app.use apiRecorder.createWatcher(api)
  start()

# Start without recording
start = (port) ->
  app.use dataStore.fetchDataForRequest
  server = http.createServer app
  server.listen port || config.defaultPort
  server.on 'error', onError
  server.on 'listening', onListening
#    console.log "Found the following JSON data: ", JSON.stringify fileScanner.get(), null, 2


module.exports =
  record: record
  start: start




