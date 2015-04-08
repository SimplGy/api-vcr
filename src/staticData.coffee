# Includes
fs            = require 'fs-extra'
config        = require './config'
fileIO        = require './fileIO'
path          = require 'path'



# Given an API peth, fetch a corresponding file on the filesystem
# If a file isn't found, attempts to return one in the same path with a different id (config.bestAvailable)
###
  TODO: Ideal similarity search when recorded data is not found:
  Individual resource
  1. Return exact item
  2. Return sibling with nearby id
  3. Return first item of a list with the same resource name (eg: request for animal/7 can return JSON.parse(animals.json)[0])
  4. 404
  Individual resource w/ query params
  1. Return exact item with exact query params
  2. Find same resource with a similar query (scoring similar queries should be fun)
  3. Find same resource with no query
  4. Find sibling resource with exact query params
  5. Find sibling resource with similar query
  6. Find sibling resource with no query
  7. 404
  Collection
  1. return exact collection
  2. Search for a child item(s). If there are any, add them all to an array and return that. (eg: [1.json, 2.json])
  3. 404
  Collection w/ query params
  1. return exact collection w/ matching params
  2. return exact collection with similar query
  3. exact colleciton no query
  4. child items merged into an array
  5. 404
###
get = (req, res, next) ->
  file = fileIO.convertReqToFilename req
  fileCallback = (err, data) ->
    if err?.code is 'ENOENT' and config.sameSameSiblings
      console.log "  Didn't find `#{file}`. Looking for similar siblings..."
      sibling = fileIO.getSiblingName file
      if sibling
        console.log "  Found a sibling. Returning `#{path.basename sibling}`"
        fs.readJson sibling, fileCallback
      else
        next()
    else if err?.code is 'ENOENT'
      console.log "  File not found: #{file}"
      next()
    else if err
      console.log "  Unhandled error", { err: err, data: data }
      next()
    else
      res.send data
      next()


  fs.readJson file, fileCallback  # https://github.com/jprichardson/node-fs-extra#readjsonfile-options-callback


#  if config.sameSameSiblings


# Given an api request and a data object, persist the data object to disk, or update the existing object
save = (req, data) ->
  filename = fileIO.convertReqToFilename req
  fs.outputJson filename, data, (err) ->
    if err
      console.log "Couldn't write file `#{filename}`", err
    else
      console.log "Wrote file: `#{filename}`"


METHODS =
  GET:    get
  POST:   (req, res, next) -> next(); console.warn "staticData.POST not yet supported",   arguments
  PUT:    (req, res, next) -> next(); console.warn "staticData.PUT not yet supported",    arguments
  DELETE: (req, res, next) -> next(); console.warn "staticData.DELETE not yet supported", arguments


module.exports =
  save:   save
  fetchDataForRequest: (req) ->
    console.log "#{req.method} localhost:#{config.port} #{req.path}" # TODO: print the query params, too
    METHODS[req.method].apply this, arguments
#    METHODS[req.method] req.path, (err, data) ->
#    if data then res.send data
#    next()
