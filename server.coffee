http = require 'http'
url = require 'url'

# shamelessly copied from http://stackoverflow.com/a/4826179/203137
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

THRESHOLD = 0.01
TIMEOUT = 30000

# an array of [request,response]
pending = []
pluckPending = (latitude, longitude) ->
  for rr in pending
    req = rr[0]
    adlat = Math.abs(latitude - req.latitude)
    adlng = Math.abs(longitude - req.longitude)
    if adlat + adlng < THRESHOLD
      clearTimeout rr[2]
      pending.remove(rr)
      return rr
  return null

server = http.createServer (request, response) ->
  console.log request.url
  params = (url.parse request.url, true).query
  latitude = parseFloat params['latitude']
  longitude = parseFloat params['longitude']

  if isNaN(latitude) || isNaN(longitude)
    response.writeHead 400, "Content-Type": "application/json"
    response.end '{"status":"bad_request","body":{"message":"Could not parse latitude and longitude. Please send a query string like `?latitude=12.345&longitude=67.890`."}}' + "\n"
    return

  console.log 'Request received from (' + latitude + ', ' + longitude + ')'

  if found = pluckPending latitude, longitude
    console.log('Match found! Responding to request from (' + latitude + ', ' + longitude + ')')
    response.writeHead 200, "Content-Type": "application/json"
    response.end '{"status":"success","body":{"uptop":true}}' + "\n"
    console.log('Responding also to request from (' + found[0].latitude + ', ' + found[0].longitude + ')')
    found[1].writeHead 200, "Content-Type": "application/json"
    found[1].end '{"status":"success","body":{"uptop":true}}' + "\n"
  else
    request.latitude = latitude
    request.longitude = longitude
    pendingEl = [request, response]
    timeoutId = setTimeout ( ->
      console.log('No match found. Removing request from (' + latitude + ', ' + longitude + ')')
      pending.remove pendingEl
      response.writeHead 404, "Content-Type": "application/json"
      response.end '{"status":"not_found","body":{"uptop":false}}' + "\n"
    ), TIMEOUT
    pendingEl.push timeoutId
    pending.push(pendingEl)

port = process.env.PORT || 5000
server.listen port, ->
  console.log "Listening on " + port
