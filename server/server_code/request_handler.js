
function RequestHandler(port) {
  var self = this

  this.responses  = []
  this.requestsID = 0;

  this.handleRequest = function (response, params){
    var reqID        = self.requestsID
    var scriptParams = params
    self.requestsID++
    this.responses[reqID] = response
    console.error('new Request')
    console.log(reqID + "\n")
    scriptParams.forEach(function (param) {
      console.log(reqID + ' PARAM: ' + param + "\n")
    })
    console.log('END ' + reqID + '\n')
  }

  this.server = net.createServer(function (socket) {
    socket.reqID = null
    socket.recievedData = ''
    socket.setEncoding('utf-8')
    console.error('Connected' + socket.remoteAddress + ' ' + socket.remotePort)
    var idRegex = /RESPOND ([0-9]+)/

    socket.on('data', function (data) {
      if (socket.reqID != null) {
        socket.recievedData += data
      } else {
        splittedData = data.split('\n')
        var match = idRegex.exec(splittedData[0])
        if (match != null) {
          socket.reqID = match[1]
          splittedData.shift()
          socket.recievedData += splittedData.join('\n')
        }
      }
    })

    socket.on('close', function () {
      self.responses[socket.reqID].connection.end(socket.recievedData)
      console.error('Closed connection')
    })

    socket.on('error', function(err){
      console.error(err)
    })
  })

  this.server.listen(port)
}
var requestHandler = new RequestHandler({{--PORT--}})

