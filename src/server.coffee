# Includes
express      = require 'express'
http         = require 'http'
config       = require './config'
dataStore    = require './dataStore'
fileScanner  = require './fileScanner'
proxy        = require 'express-http-proxy'

# -------------------------------------------------- Local Variables
app = express()
server = undefined # scope control


# -------------------------------------------------- Private Methods
onError =(error) -> if (error.syscall isnt 'listen') then throw error;
onListening = ->
  addr = server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log "(つ -‘ _ ‘- )つ    Listening on #{bind}     "
  console.log ''

startServer = ->
  server = http.createServer app
  server.listen config.port
  server.on 'error', onError
  server.on 'listening', onListening

decorateProxiedRequest = (req) ->
#  console.log "decorating", req
  # Fixes issue: https://github.com/villadora/express-http-proxy/issues/9
  req.headers[ 'Accept-Encoding' ] = 'utf8' #TODO: only accept application/json?
  delete req.headers['if-modified-since']
  delete req.headers['if-none-match']
  req

interceptProxiedResponse = (data, req, res, callback) ->
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


# -------------------------------------------------- Public Methods/Exports
# Pass requests on to an api server
record = ->
  # proxy-express can't deal with a trailing slash. Strip it out.
  if config.api.href[config.api.href.length - 1] is '/'
    safeHref = config.api.href.substr 0, config.api.href.length - 1
  console.log ''
  console.log "Recording #{safeHref}     ᕙ༼ ,,ԾܫԾ,, ༽ᕗ "
  console.log ''
  app.use proxy safeHref,
    decorateRequest: decorateProxiedRequest
    intercept: interceptProxiedResponse

# Start without recording
start = ->
  app.use dataStore.fetchDataForRequest
  startServer()
#  console.log "Found the following JSON data: ", JSON.stringify fileScanner.get(), null, 2

module.exports =
  record: record
  start: start




