fs = require 'fs'
config = require './config'

jsonFiles = undefined # scope control


# Get a list of all the folders
# Recursively scan all files in the path to get a list of json files
readFiles = (path) ->
  path = path || config.rootPath
  try
    contents = fs.readdirSync path
  catch
    console.warn "`#{path}` is not a folder"
    return

  for file in contents
    fullPath = "#{path}/#{file}"
#    console.log fullPath
    # JSON File
    if file.indexOf('.json') >= 0
      jsonFiles.push fullPath
      # Folder
    else
      readFiles fullPath
  jsonFiles



module.exports =
  get: ->
    jsonFiles = []
    readFiles()
