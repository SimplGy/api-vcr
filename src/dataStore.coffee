# Includes
fs = require 'fs'

# Config
defaultRoot = './data'


# Given an API path, return a potential filename
pathToFilename = (path) ->
  filename = defaultRoot + path + '.json'


readFile = (file) ->
  console.log "apiData readFile()", file
  contents = fs.readFileSync file, encoding: 'utf8'
#  console.warn "No file found named: `#{file}`" unless contents
  JSON.parse contents # TODO: be more robust about handling JSON.parse fails




module.exports =
  GET:    -> readFile pathToFilename arguments[0]
  POST:   -> console.log "apiData.POST not yet supported",   arguments
  PUT:    -> console.log "apiData.PUT not yet supported",    arguments
  DELETE: -> console.log "apiData.DELETE not yet supported", arguments


