# Includes
express   = require 'express'
http      = require 'http'
dataStore = require './dataStore'
recorder  = require './responseRecorder'

# Config
#defaultPath = './data'
port = 59007


onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = @server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log('Listening on ' + bind);

proxyRequestAndRecordResponse = (req, res, next) ->
  console.log "record"
  next()

fetchDataForRequest = (req, res, next) ->
  console.log "Request received: #{req.method} #{req.path}"
  data = dataStore[req.method] req.path
  if data then res.send data
  next()





Server = ->
  console.log "Constructing a server instance"

Server.prototype =

  start: ->
    @app = express()
    @app.use proxyRequestAndRecordResponse
    @app.use fetchDataForRequest
    console.log "Starting express server"
    @server = http.createServer @app
    @server.listen port
    @server.on 'error', onError
    @server.on 'listening', onListening.bind @



module.exports = new Server()
