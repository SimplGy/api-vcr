###
  Stateless utility methods for accessing api-vcr files.
  Any CRUD that is file system specific should go here
###

fs = require 'fs'
config = require './config'
path = require 'path'
_ = require 'lodash'

# config
queryStringIndicator = '__&__' # This file system safe flag is how I know there's a query string in the filename. It's a bit ghetto.

# Get a list of all the folders
# Recursively scan all files in the path to get a list of json files
readFiles = (filePath, jsonFiles) ->
  filePath = filePath || config.filePath
  jsonFiles = jsonFiles || []
  return if config.ignore.indexOf(path.basename filePath) isnt -1
  try
    contents = fs.readdirSync filePath # TODO: refactor to remove the blocking sync method
  catch
    console.log "`#{filePath}` is not a folder, skipping"
    return

  for file in contents
    fullPath = "#{filePath}/#{file}"
    # JSON File
    if file.indexOf('.json') >= 0
      jsonFiles.push fullPath
    # Folder
    else
      readFiles fullPath, jsonFiles
  jsonFiles


# Given a full file path and a callback, try to find a sibling.
# Assume the file does not exist, as that's the reason to call this method.
# TODO: First try to find any ID match without query params. If none of that matches, return any sibling
getSiblingName = (filename) ->
  dirContents = readFiles path.dirname filename
  if dirContents
    # TODO Is there one with the same ID but no query params?
    # TODO Is there one with the same id but different query params?
    return dirContents[0] # ::shrug:: The first one. TODO: search for "most similar" by nearest ID or something?
  else
    return undefined


count = ->
  count = readFiles().length
  if count is 0
    console.log "No JSON files found in `#{config.filePath}`"
    if config.isRecording
      console.log "Good thing you're recording"
    else
      console.log "You should probably add some or run in `--record` mode first"
  else if count is 1
    console.log "Only found one file. What is this, don't trust me yet?"
  else
    console.log "Found #{count} JSON files. You're ready to jam."
  return count

# Given a param object, turn it into a string that is always the same no matter the param order, and is safe for a filename
stringifyParams = (params) ->
  return '' unless params
  strings = []
  for own prop of params
    strings.push "#{prop}=#{params[prop]}"
  return '' if strings.length is 0
  sorted = _.sortBy strings, (s) -> s.charCodeAt 0
  return queryStringIndicator + sorted.join('&') # Using an `&` instead of `?` because I have the impression it's more file name safe. TODO: encode these properly.


# Given an HTTP request, convert it to a filename.
convertReqToFilename = (req) ->
  file = config.filePath + req.path # root path
  file += stringifyParams req.query
  file += '.json'

# Given a file on the file system, which api path should it respond to?
#convertFilenameToRequestPath = (filePath) ->
#  apiPath = path = filePath.split('.json').join ''
#  apiPath.split(defaultPath).join ''


module.exports =
  count: count
  getSiblingName: getSiblingName
  list: readFiles
  convertReqToFilename: convertReqToFilename
