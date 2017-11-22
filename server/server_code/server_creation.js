
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
  
  {{--ROUTE_SWITCH--}}
})
