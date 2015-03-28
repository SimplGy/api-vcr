# Includes
fs = require 'fs'
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




dataStore =
  GET:    -> readFile pathToFilename arguments[0]
  POST:   -> console.log "dataStore.POST not yet supported",   arguments
  PUT:    -> console.log "dataStore.PUT not yet supported",    arguments
  DELETE: -> console.log "dataStore.DELETE not yet supported", arguments
  fetchDataForRequest: (req, res, next) ->
    console.log "Request received: #{req.method} #{req.path}"
    data = dataStore[req.method] req.path
    if data then res.send data
    next()


module.exports = dataStore
