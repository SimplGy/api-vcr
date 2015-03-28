http  = require 'http'
https = require 'https'



createWatcher = (api) ->
  host = api.split(':')[0]
  port = api.split(':')[1]
  console.log "constructing a watcher for api: `#{host}:#{port}`"
  return (req, res, next) ->
    console.log "Proxying request: ", req.path

#    apiRequest =
#      hostname: host
#      port: port
#      method: req.method
#      path: req.path
#    console.log request: apiRequest
#    apiReq = http.request apiRequest, onApiResponse
#    apiReq.end()


    onApiResponse = (res) ->
      console.log "Got response from API server"
      console.log
        status: res.statusCode
        headers: JSON.stringify res.headers
      res.setEncoding 'utf8'
      res.on 'data', (chunk) -> console.log 'BODY: ' + chunk
      next()

    onApiErr = (err) ->
      console.warn 'problem with API request: ' + err.message
      next()

    apiReq = http.get "#{req.protocol}://#{host}:#{port}#{req.path}", onApiResponse
    apiReq.on 'error', onApiErr


module.exports =
  createWatcher: createWatcher