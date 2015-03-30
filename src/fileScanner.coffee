###
  Stateless utility methods for accessing api-vcr files.
###

fs = require 'fs'
config = require './config'
path = require 'path'


# Get a list of all the folders
# Recursively scan all files in the path to get a list of json files
readFiles = (filePath, jsonFiles) ->
  filePath = filePath || config.rootPath
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
getSiblingName = (filename) ->
  dirContents = readFiles path.dirname filename
  return dirContents[0] # ::shrug:: The first one. TODO: search for "most similar" by nearest ID or something?


count = ->
  count = readFiles().length
  if count is 0
    console.log "No JSON files found in `#{config.rootPath}`"
    if config.isRecording
      console.log "Good thing you're recording"
    else
      console.log "You should probably add some or run in `--record` mode first"
  else if count is 1
    console.log "Only found one file. What is this, don't trust me yet?"
  else
    console.log "Found #{count} JSON files. You're ready to jam."



module.exports =
  count: count
  getSiblingName: getSiblingName
  get: readFiles
