# Includes
fs        = require 'fs'
express   = require 'express'
http      = require 'http'

# Config
defaultPath = './data'
port = 59007


# Get a list of all the folders
# Recursively scan all files in the path
jsonFiles = []
readFiles = (path) ->
  try
    contents = fs.readdirSync path
  catch
    console.warn "`#{path}` is not a folder"
    return

  for file in contents
    fullPath = "#{path}/#{file}"
    console.log fullPath
    # JSON File
    if file.indexOf('.json') >= 0
      jsonFiles.push fullPath
    # Folder
    else
      readFiles fullPath
  jsonFiles


# Given a path to a file on the file system, which api path should it respond to?
fileToApiPath = (filePath) ->
  apiPath = path = filePath.split('.json').join ''
  apiPath.split(defaultPath).join ''


# Build a hash that contains the content of each file
getContents = (paths) ->
  contentsByPath = {}
  for path in paths
    data = fs.readFileSync path, encoding: 'utf8'
    continue unless data
    contentsByPath[fileToApiPath path] = JSON.parse data # TODO: be more robust about handling JSON.parse fails
  contentsByPath





console.log 'Creating APIs for the following content:', readFiles defaultPath
jsonContents = getContents jsonFiles
console.log ''
#console.log 'json data by api path', jsonContents
#console.log ''

app = express()


# Catch and log all requests
app.use (req, res, next) ->
  console.log "Request recieved: #{req.method} #{req.path}"
#    method: req.method
#    path: req.path
#    params: req.params
#    query: req.query # an object with all the query params
  next()


console.log 'Listening for the following Routes:'
for file in jsonFiles
  do -> # Close over the `path` variable
    path = fileToApiPath file
    console.log "GET " + path
    app.get path, (req, res) ->
      console.log "Returning JSON for `#{path}`", jsonContents[path]
      res.send jsonContents[path]
console.log ''







onError = (error) -> if (error.syscall isnt 'listen') then throw error;

onListening = ->
  addr = server.address();
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port;
  console.log('Listening on ' + bind);



console.log "Starting express server"
server = http.createServer app
server.listen port
server.on 'error', onError
server.on 'listening', onListening



