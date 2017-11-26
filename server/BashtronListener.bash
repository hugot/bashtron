##
# Functions that listen for- and handle requests.

##
# Handle a request by passing the route and the parameters to
# the handleRoute function. The handleRoute function needs to be
# defined in the the shell that this function is called in.
handleRequest()({
  declare reqid="$1"
  shift
  echo RESPOND $reqid
  handleRoute $@
})

##
# Listen for request descriptions through a tcp connection.
# Responses are handled through calling the handleRequest function.
# Needs environment variable BASHTRON_LISTENER_PORT to be set to know
# to what port on localhost to send the response.
listener(){
  if [[ -z $BASHTRON_LISTENER_PORT ]]; then
    echo "LISTENER ERROR: BASHTRON_LISTENER_PORT NOT SET." >&2
    exit 200
  fi

  # Give the server some time to start
  sleep 5
  echo LISTENER STARTED
  exec 5<> /dev/tcp/127.0.0.1/$BASHTRON_LISTENER_PORT
  echo -n 'REQUEST??' >&5

  declare -a request=()
  declare -i handlers=0
  while read -ru 5 instruction; do
    if [[ $instruction == 'END' ]]; then
      handleRequest "${request[@]}" >/dev/tcp/127.0.0.1/$BASHTRON_LISTENER_PORT &
      let handlers++
      if [[ $handlers -eq 100 ]]; then
        disown -a
        handlers=0
      fi
      declare -a request=()
      continue
    fi
    declare request[${#request[@]}]="$instruction"
  done
}
