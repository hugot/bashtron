{{--CASE--}}:
  var dir = path.join(__dirname, {{--DIR_NAME--}})
  {{--SPLITTED_URL--}}.shift()
  var reqpath = {{--SPLITTED_URL--}}.join('/')
  if (request.method !== 'GET') {
    response.statusCode = 501
    response.setHeader('Content-Type', 'text/plain')
    response.end('Method not implemented')
    return
  }
  var file = path.join(dir, reqpath.replace(/\/$/, '/index.html'))
  if (file.indexOf(dir + path.sep) !== 0) {
    response.statusCode = 403
    response.setHeader('Content-Type', 'text/plain')
    response.end('Forbidden')
    return
  }
  var type = mime[path.extname(file).slice(1)] || 'text/plain'
  var s = fs.createReadStream(file);
  s.on('open', function () {
    response.setHeader('Content-Type', type)
    s.pipe(response)
  })
  s.on('error', function (error) {
    console.log(error)
  })
  break
