http = require 'http'

server = http.createServer (request, response) ->
  response.writeHead 200, "Content-Type": "text/plain"
  response.end "Hello World\n"

port = process.env.PORT || 5000
server.listen port, ->
  console.log "Listening on " + port
