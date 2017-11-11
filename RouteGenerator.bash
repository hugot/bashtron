#!/bin/bash

##
# Print code to route to a script.
# Default route:
# route [ -d ] [ scriptname ] [ --with-params [ params ] ]
# Route from a url path:
# route [ route path ] [ scriptname ] [ --with-params [ params ] ]
route(){
  declare case="case '$1'"
  declare paramsParse=''
  while ! [ -z $1 ]; do
    case $1 in
      -d|--default)
        declare case="default"
        ;;
      -e|--execute)
        shift
        declare scriptname="$1"
        ;;
      -g|--get-params)
        paramsParse+="$(
          template -f $HERE/server_code/get_params.js\
            -t param_arr     -v params\
            -t get_params    -v 'urlObject.query'
        )"
        ;; 
      -r|--split-routes)
        paramsParse+="$(
          template -f $HERE/server_code/split_routes.js\
            -t param_arr    -v params\
            -t splitted_url -v splittedPathname
        )"
        ;;
      -s|--static)
        shift
        template -f $HERE/server_code/static_case.js\
          -t CASE         -v "$case"\
          -t dir_name     -v "'$1'"\
          -t splitted_url -v 'splittedPathname'
        return
        ;;
    esac
    shift
  done
  template -f "$HERE/server_code/route_case.js"\
    -t CASE          -v "$case"\
    -t script_name   -v "$scriptname"\
    -t param_arr     -v "params"\
    -t param_parsers -v "$paramsParse"
}
