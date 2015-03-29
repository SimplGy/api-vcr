# Includes
fs = require 'fs-extra'
config = require './config'


# Given a file on the file system, which api path should it respond to?
#fileToPath = (filePath) ->
#  apiPath = path = filePath.split('.json').join ''
#  apiPath.split(defaultPath).join ''


# Given an API path, return a potential filename
pathToFilename = (path) ->
  filename = config.filePath + path + '.json'


# Given a path to a JSON file, return parsed contents
readJsonFile = (file) ->
  console.log "dataStore readJsonFile()", file
  contents = fs.readFileSync file, encoding: 'utf8'
  JSON.parse contents # TODO: be more robust about handling JSON.parse fails


# Given an api request and a data object, persist the data object to disk, or update the existing object
save = (req, data) ->
  filename = pathToFilename req.path
  fs.outputJson filename, data, (err) ->
    if err
      console.log "Couldn't write file `#{filename}`", err
    else
      console.log "Wrote file: `#{filename}`"


# Publish
dataStore =
  GET:    (path) -> fs.readJsonSync pathToFilename path                     # https://github.com/jprichardson/node-fs-extra#readjsonfile-options-callback
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
