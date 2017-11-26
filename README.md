# Attention: this README is not up to date, a new one is being worked on.
In the mean time, please see [https://github.com/redrock9/bashlord.com](https://github.com/redrock9/bashlord.com)
as an example project that works with the the latest version of bashtron.

# bashtron - a web framework for bash
Bashtron is a web framework for the bash programming language. It leverages
the nodejs http library to host bash scripts that function as controllers and generate html.

## How does it work?
The ServerGenerator script in the root of the project generates javascript code for the nodejs
runtime. The generated code will run a server that listens on the port that is defined in the `port`
variable in the current shell. You can add routes to the server by appending the `route` command.

## Dependencies
Except for depending on nodejs, bashtron is written in pure bash and the generated javascript
exclusively uses the native nodejs libraries. So no `node_modules` with the weight of ten cities
for this framework!

## Examples
You can see this framework in action at [bashlord.com](http://bashlord.com) ([GitHub link](https://github.com/redrock9/bashlord.com))

### Creating a server that routes all requests to a script
```bash
    source $BASH_LIB/bashtron/ServerGenerator.bash 

{ 
    port=3000 # Define the port that the server should listen on.

    ##
    # Generate javascript code.
    # The --default option tells the bashtron where to route any undefined routes to.
    # The --execute flag tells bashtron which script to execute
    # The --get-params option tells bashtron to append the GET parameters of the request
    # to the parameters of your script in the form [-g [ param_name ] [ param_value ]]
    # a request to /?hi=bye would result in the parameters -g hi bye for example.

    server route --default --execute SomeScript.bash --get-params

} | node # Pipe into node for execution
```

### More advanced routing
```bash
source $BASH_LIB/bashtron/ServerGenerator.bash

{
    port=3000
  
    ##
    # The --default flag tells bashtron what page to use for non defined routes.
    # The --execute flag tells bashtron what script to execute for this route.
    # When not using the --default flag, the first argument after `route` is used
    # as the url path. So route somewhere will result in a route for /somewhere.
    # The --split-routes splits the remainder of the url string into command line arguments
    # at every forward slash, so /somewhere/else/route will result in the execution of 
    # SubRouter.bash with the arguments else route (else is $1, route is $2)
    # the last route tells bashtron to serve the files in the dir 'public' at the
    # url path '/public'
    server\ 
      route --default --execute Index.bash\
      route somewhere --execute SubRouter.bash --split-routes\
      route public --static public
} | node 
```

