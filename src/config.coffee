fs = require 'fs-extra'

config =
  port: 59007
  rootPath: './.api-vcr-data'
  # Compute the path using `root / hostname / port`
  computeFilePath: ->
    config.filePath = [
      config.rootPath
      config.api.hostname
      config.api.port || 80 # TODO: handle https
    ].join '/'
    console.log "Using file path: `#{config.filePath}`"
    fs.ensureDirSync config.filePath
    config.filePath



module.exports = config
