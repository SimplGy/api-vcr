# Includes
fs = require 'fs.extra'
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
  console.log 'dataStore.save()',
    headers_host: httpRequest.headers.host
    hostname: httpRequest.hostname
    originalUrl: httpRequest.originalUrl
    method: httpRequest.method
    data: data

  return console.error "dataStore.save() doesn't work if you haven't configured a `record` server" unless config.record

  # Build a deep folder path like `hostname/port/path/to/id`
  pathComponents = [
    config.rootPath
    config.record.split(':')[0]
    config.record.split(':')[1] || 80
  ]
  route = httpRequest.path.split '/'
  if route[0] is '' then route.shift() # because the route can start with a '/', need to shift it off
  Array.prototype.push.apply pathComponents, route
  finalResource = pathComponents.pop() # the last element is the actual resource list or id requested

  path = pathComponents.join '/'
  console.log "Make a deep path: ", path
  fs.mkdirRecursive path, (err) -> if err then console.warn "Couldn't make dir [#{path}]", err

  file = "#{path}/#{finalResource}.json"
  console.log "Create file: ", file
  contents = JSON.stringify data, null, 2
  console.log "...with contents: ", contents
  fs.writeFile file, contents, (err) -> if err then console.log "Couldn't write file [#{file}]", err


#  fs.mkdir './data/foo/bar'


#  makeFolderThatMightExist pathComponents[0], (err) ->
#    pathComponents.push
#    path = pathComponents.join '/'
#    console.log 'make folder: ' + path
#    makeFolderThatMightExist path, (err) ->


#  makeFolderThatMightExist config.rootPath + httpRequest.host.split(':')[1] or 80




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
