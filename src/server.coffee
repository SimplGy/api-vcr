# Includes
express      = require 'express'
http         = require 'http'
config       = require './config'
dataStore    = require './dataStore'
apiRecorder  = require './apiRecorder'
fileScanner  = require './fileScanner'
proxy        = require 'express-http-proxy'
url          = require 'url'

# -------------------------------------------------- Local Variables
app = express()
server = undefined # scope control


# -------------------------------------------------- Private Methods
onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log "(つ -‘ _ ‘- )つ    Listening on #{bind}   "
  console.log ''

startServer = ->
  server = http.createServer app
  server.listen config.port
  server.on 'error', onError
  server.on 'listening', onListening


# -------------------------------------------------- Public Methods/Exports
# Pass requests on to an api server
record = (api) ->
  console.log ''
  console.log "Recording #{api}     ᕙ༼ ,,ԾܫԾ,, ༽ᕗ "
  console.log ''

  #  app.use apiRecorder.createWatcher(api)

  app.use proxy api,
    decorateRequest: (req) ->
      # https://github.com/villadora/express-http-proxy/issues/9
      req.headers[ 'Accept-Encoding' ] = 'utf8'
      delete req.headers['if-modified-since']
      delete req.headers['if-none-match']
      req
    intercept: (data, req, res, callback) ->
      data = data.toString 'utf8'
      try
        data = JSON.parse data
        dataStore.save req, data
        callback null, JSON.stringify(data) # Continue on to the proxy library
      catch
        console.warn "unable to parse JSON response from API server",
          req_path: req.path
          data: data
        callback null, data

#    forwardPath: (req, res) -> url.parse(req.url).path
#    intercept: (data, req, res, callback) ->
#      data = data.toString 'utf8'
#      callback(null, JSON.stringify(data))
#      console.log 'intercept', data
#      data

# Start without recording
start = ->
  app.use dataStore.fetchDataForRequest
  startServer()
#  console.log "Found the following JSON data: ", JSON.stringify fileScanner.get(), null, 2

module.exports =
  record: record
  start: start




