##
# Functions that listen for- and handle requests.

##
# Handle a request by passing the route and the parameters to
# the handleRoute function. The handleRoute function needs to be
# defined in the the shell that this function is called in.
handleRequest(){
  declare reqid="$1"
  shift
  echo RESPOND $reqid
  handleRoute $@
}

##
# Listen for request descriptions through a pipe.
# Responses are handled through calling the handleRequest function.
# Needs environment variable BASHTRON_LISTENER_PORT to be set to know
# to what port on localhost to send the response.
listener(){
  if [[ -z $BASHTRON_LISTENER_PORT ]]; then
    echo "LISTENER ERROR: BASHTRON_LISTENER_PORT NOT SET." >&2
    exit 200
  fi

  while read instruction; do
    if [[  $instruction == +([0-9]) ]]; then
      declare -a request${instruction}
    elif [[ $instruction ==  +([0-9])' PARAM: '* ]]; then
      declare -n paramArr=request${instruction%% PARAM:*}
      declare param="${instruction##*PARAM: }"
      paramArr[${#paramArr[@]}]="$param"
    elif [[ $instruction ==  'END '+([0-9]) ]]; then
      declare id=${instruction##END }
      declare -n paramArr=request${id}
      (handleRequest "$id" ${paramArr[@]}) >/dev/tcp/127.0.0.1/$BASHTRON_LISTENER_PORT &
      unset -v paramArr
    fi
  done
}
