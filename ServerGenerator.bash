#!/bin/bash
##
# Functions for generating the code to run a node js server that can
# serve bash scripts.

##
# Generate code for server with defined routes
server()(
  source $BASH_LIB/bashtron/Template.bash 
  source $BASH_LIB/bashtron/RouteGenerator.bash

  declare HERE=$BASH_LIB/bashtron
  declare -a routes=()
  while [[ $# -gt 0 ]]; do
    case $1 in
      route)
        shift
        declare cmd='route'
        while [[ $1 != 'route' ]] && [[ ! -z $1 ]]; do
          cmd+=" $1"
          shift
        done
        routes[${#routes[@]}]="$cmd"
        ;;
      *)
        echo Command $1 not found. >&2
        exit 200
    esac
  done
    template -f $HERE/server_code/server.js\
      -t require        -v "$(template -f $HERE/server_code/require.js)"\
      -t after_creation -v "console.log('server started at port $port')"\
      -t creation       -v "$(
          template -f $HERE/server_code/server_creation.js\
            -t port         -v $port\
            -t route_switch -v "$(
              template -f $HERE/server_code/route_switch.js\
                -t url_name -v urlPath\
                -t cases    -v "$(
                  for ((i=0; i < ${#routes[@]}; i++)); do 
                    ${routes[$i]}
                  done
                )"
            )"
      )"
)
