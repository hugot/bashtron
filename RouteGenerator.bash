#!/bin/bash

##
# Prints code that specifies actions for a the defined route.
# unless the --default option is set, $1 is used as the route location.
# Options:
# -d --default                 | make this the default route, al undefined routes
#                              | are redirected here.
# -e --execute [ scriptname ]  | define the script to execute
# -g --get-patams              | Include GET request parameters in the
#                              | arguments of the script in the format 
#                              | [ -g [ paramname] [ paramvalue ] ]
# -r --split-routes            | Split the remainder of the url at every '/' and
#                              | pass the result as arguments to the script
# -s --static [ dirname ]      | Make this route action serve the files in the
#                              | defined directory.
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
