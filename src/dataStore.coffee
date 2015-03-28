# Includes
fs = require 'fs-extra'
config = require './config'


# Given an API path, return a potential filename
pathToFilename = (path) ->
  filename = config.rootPath + path + '.json'

# Given a file on the file system, which api path should it respond to?
#fileToPath = (filePath) ->
#  apiPath = path = filePath.split('.json').join ''
#  apiPath.split(defaultPath).join ''

readFile = (file) ->
  console.log "dataStore readFile()", file
  contents = fs.readFileSync file, encoding: 'utf8'
#  console.warn "No file found named: `#{file}`" unless contents
  JSON.parse contents # TODO: be more robust about handling JSON.parse fails


# Given an api request and a data object, persist the data object to disk, or update the existing object
save = (httpRequest, data) ->
  return console.error "dataStore.save() doesn't work if you haven't configured a `record` server" unless config.record
  # Build a deep folder path to the file like `hostname/port/path/to/id`
  pathComponents = [
    config.rootPath
    config.apiUrl.hostname
    config.apiUrl.port || 80 # TODO: handle https
  ]
  route = httpRequest.path.split '/'
  if route[0] is '' then route.shift() # because the route can start with a '/', need to shift it off
  Array.prototype.push.apply pathComponents, route
  filename = pathComponents.join('/') + '.json'
  # TODO: support a flag that doesn't overwrite existing data
  fs.outputJson filename, data, (err) -> if err then console.log "Couldn't write file [#{file}]", err




dataStore =
  GET:    -> readFile pathToFilename arguments[0]
  POST:   -> console.log "dataStore.POST not yet supported",   arguments
  PUT:    -> console.log "dataStore.PUT not yet supported",    arguments
  DELETE: -> console.log "dataStore.DELETE not yet supported", arguments
  save: save
  fetchDataForRequest: (req, res, next) ->
    console.log "Request received: #{req.method} #{req.path}"
    data = dataStore[req.method] req.path
    if data then res.send data
    next()

module.exports = dataStore
