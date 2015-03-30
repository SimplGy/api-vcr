# Includes
fs            = require 'fs-extra'
config        = require './config'
fileScanner   = require './fileScanner'
path          = require 'path'


# Given a file on the file system, which api path should it respond to?
#fileToPath = (filePath) ->
#  apiPath = path = filePath.split('.json').join ''
#  apiPath.split(defaultPath).join ''


# Given an API path, return a potential filename
pathToFilename = (apiPath) -> config.filePath + apiPath + '.json'


# Given a path to a JSON file, return parsed contents
#readJsonFile = (file) ->
#  console.log "dataStore readJsonFile()", file
#  contents = fs.readFileSync file, encoding: 'utf8'
#  JSON.parse contents # TODO: be more robust about handling JSON.parse fails

# Given an API peth, fetch a corresponding file on the filesystem
# If a file isn't found, attempts to return one in the same path with a different id (config.bestAvailable)
get = (req, res, next) ->
#  fs.readJsonSync pathToFilename path                     # https://github.com/jprichardson/node-fs-extra#readjsonfile-options-callback
  file = pathToFilename req.path
  fileCallback = (err, data) ->
    if err?.code is 'ENOENT' and config.sameSameSiblings
      console.log "Didn't find #{req.path}. Looking for similar siblings..."
      sibling = fileScanner.getSiblingName file
      if sibling
        console.log "Found a sibling. Returning `#{path.basename sibling}`"
        fs.readJson sibling, fileCallback
    else if err?.code is 'ENOENT'
      console.log "File not found: #{file}"
      next()
    else if err
      console.log "Unhandled error", { err: err, data: data }
      next()
    else
      res.send data
      next()


  fs.readJson file, fileCallback  # https://github.com/jprichardson/node-fs-extra#readjsonfile-options-callback


#  if config.sameSameSiblings


# Given an api request and a data object, persist the data object to disk, or update the existing object
save = (req, data) ->
  filename = pathToFilename req.path
  fs.outputJson filename, data, (err) ->
    if err
      console.log "Couldn't write file `#{filename}`", err
    else
      console.log "Wrote file: `#{filename}`"


METHODS =
  GET:    get
  POST:   -> console.warn "dataStore.POST not yet supported",   arguments
  PUT:    -> console.warn "dataStore.PUT not yet supported",    arguments
  DELETE: -> console.warn "dataStore.DELETE not yet supported", arguments


# Publish
dataStore =
  save:   save
  fetchDataForRequest: (req) ->
    console.log "Request received: #{req.method} #{req.path}"
    METHODS[req.method].apply this, arguments
#    METHODS[req.method] req.path, (err, data) ->
#    if data then res.send data
#    next()


module.exports = dataStore
