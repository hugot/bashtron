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

/**
 * The web server, communication to the outside world.
 */
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

/**
 * Constructor for a requestHandler object.
 */
function RequestHandler() {
  var self       = this
  this.responses = new Map()
  this.listeners = []

  /**
   * Handle a request by passing the parameters and a response
   * through a connection with a Bashtron Listener.
   * @param params
   * @param response
   */
  this.handleRequest = function (params, response){
    var reqID        = Date.now().toString()
    var scriptParams = params
    while (self.responses.has(reqID)){
      reqID += '1'
    }
    var request      = reqID + "\n"
    self.responses.set(reqID, response)

    scriptParams.forEach(function (param) {
      request += param + "\n"
    })
    request += 'END\n'

    var listener = self.listeners.pop()
    if (listener === undefined) {
      response.end('No listener for server. Please notify the site owner.')
      return
    }
    listener.write(request)
    self.listeners.unshift(listener)
  }

  /**
   * Send response to client.
   * @param int    reqID
   * @param string response
   */
  this.respond = function (reqID, response) {
    var response = self.responses.get(reqID)
    if (response !== undefined && response.connection != null) {
      self.responses.get(reqID).connection.end(response)
    }
  }

  /**
   * Add a listener to the listener array.
   */
  this.addListener = function (socket) {
    self.listeners.push(socket)
  }

}

// Create the server that will communicate with the external bash processes
var handlerServer = net.createServer(function (socket) {
  console.log('Connected' + socket.remoteAddress + ' ' + socket.remotePort)
  socket.reqID = null
  socket.recievedData = ''
  socket.setEncoding('utf-8')
  var idRegex = /RESPOND ([0-9]+)/

  socket.on('data', function (data) {
    // Listener initalisation
    if (data ===  'REQUEST??') {
      requestHandler.addListener(socket)
    } 
    // Handling response data for request
    else if (socket.reqID != null) {
      socket.recievedData += data
    } 
    // checking if a new response is being communicated
    else {
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
    if (socket.recievedData !== undefined && socket.reqID !== undefined){
      requestHandler.respond(socket.reqID, socket.recievedData)
    }
    console.log('Closed connection')
  })

  socket.on('error', function(err){
    console.error(err)
  })
})

// Make servers listen and communicate through requestHandler
var requestHandler = new RequestHandler()
handlerServer.listen({{--LISTENER_PORT--}})
server.listen({{--SERVER_PORT--}})      

console.log('server started at port {{--SERVER_PORT--}}')
