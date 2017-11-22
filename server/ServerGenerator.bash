##
# Functions for generating the code to run a node js server that can
# serve bash scripts.

##
# Generate code for server with defined routes
# define routes by passing [ route [ options ] ] as argument
# for every route.
server()(
  source $BASH_LIB/bashtron/template/PreciseTemplate.bash 
  source $BASH_LIB/bashtron/server/RouteGenerator.bash

  if [ -z $BASHTRON_SERVER_PORT ]; then
    echo "SERVER ERROR: BASHTRON_SERVER_PORT IS NOT SET" >&2
    exit 200
  fi

  if [ -z $BASHTRON_LISTENER_PORT ]; then
    echo "SERVER ERROR: LISTENER PORT IS NOT SET" >&2
    exit 200
  fi

  declare HERE=$BASH_LIB/bashtron/server
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
      -t after_creation -v $"\
      $( template -f $HERE/server_code/request_handler.js\
            -t port -v $BASHTRON_LISTENER_PORT
        echo
      )
      server.listen($BASHTRON_SERVER_PORT);\
      console.error('server started at port $BASHTRON_SERVER_PORT')"\
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
