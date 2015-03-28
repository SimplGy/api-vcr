# Includes
express      = require 'express'
http         = require 'http'
dataStore    = require './dataStore'
recorder     = require './responseRecorder'
fileScanner  = require './fileScanner'
config       = require './config'


onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = @server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log('Listening on ' + bind);

proxyRequestAndRecordResponse = (req, res, next) ->
  console.log "record"
  next()






Server = ->
  console.log "Constructing a server instance"

Server.prototype =

  start: (port) ->
    @app = express()
    @app.use proxyRequestAndRecordResponse
    @app.use dataStore.fetchDataForRequest
    console.log "Starting express server"
    @server = http.createServer @app
    @server.listen port || config.defaultPort
    @server.on 'error', onError
    @server.on 'listening', onListening.bind @
#    console.log "Found the following JSON data: ", JSON.stringify fileScanner.get(), null, 2




module.exports = new Server()
