#!/usr/bin/node

const http          = require('http')
const url           = require('url')
const child_process = require('child_process')
const path          = require('path');
const fs            = require('fs');
const net           = require('net')


const mime = {
    html: 'text/html',
    txt: 'text/plain',
    css: 'text/css',
    gif: 'image/gif',
    jpg: 'image/jpeg',
    png: 'image/png',
    svg: 'image/svg+xml',
    js: 'application/javascript'
};

var server = http.createServer(function (request, response) {
  var urlObject = url.parse(request.url, true)
  var splittedPathname = urlObject.pathname.split('/')
  splittedPathname.shift()
  var urlPath = splittedPathname[0]
  console.error('REQUEST FOR ' + request.url)

  switch(urlPath){
    {{--CASES--}}
  }
})

function RequestHandler(port) {
  var self = this
  this.responses    = new Map()
  this.requests     = []

  this.handleRequest = function (params, response){
    var reqID        = Date.now().toString()
    var scriptParams = params
    while (self.responses.has(reqID)){
      reqID += '1'
    }
    var request      = reqID + "\n"
    self.responses.set(reqID, response)

    console.error('new Request')

    // Pass request ID and params through pipe
    scriptParams.forEach(function (param) {
      request += param + "\n"
    })
    request += 'END\n'
    self.requests.push(request)

    return reqID
  }

  this.respond = function (reqID, response) {
    self.responses.get(reqID).connection.end(response)
  }

  this.nextRequest = function () {
    return self.requests.pop()
  }

}

var handlerServer = net.createServer(function (socket) {
  socket.reqID = null
  socket.recievedData = ''
  socket.setEncoding('utf-8')
  console.log('Connected' + socket.remoteAddress + ' ' + socket.remotePort)
  var idRegex = /RESPOND ([0-9]+)/

  socket.on('data', function (data) {
    console.log('recieved ' + data)
    if (data ===  'REQUEST??') {
      var waiter = setInterval(function () {
        var req = requestHandler.nextRequest()
        if (req !== undefined) {
          socket.write(req)
        }
      }, 1)
    } else if (socket.reqID != null) {
      socket.recievedData += data
    } else {
      splittedData = data.split('\n')
      var match = idRegex.exec(splittedData[0])
      if (match != null) {
             splittedData = data.split('\n')
        var match = idRegex.exec(splittedData[0])
        if (match != null) {
          socket.reqID = match[1]
          splittedData.shift()
          socket.recievedData += splittedData.join('\n')
}   socket.reqID = match[1]
        splittedData.shift()
        socket.recievedData += splittedData.join('\n')
      }
    }
  })

  socket.on('close', function () {
    requestHandler.respond(socket.reqID, socket.recievedData)
    console.error('Closed connection')
  })

  socket.on('error', function(err){
    console.error(err)
  })
})

var requestHandler = new RequestHandler()
handlerServer.listen({{--LISTENER_PORT--}})
server.listen({{--SERVER_PORT--}})      

console.error('server started at port PORT')
