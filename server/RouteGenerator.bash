##
# This function prints code that specifies actions for a the defined route.
# unless the --default option is set, $1 is used as the route location.
# Options:
# -d --default                 | make this the default route, al undefined routes
#                              | are redirected here.
# -g --get-patams              | Include GET request parameters in the
#                              | arguments of the script in the format 
#                              | [ -g [ paramname] [ paramvalue ] ]
# -r --split-routes            | Split the remainder of the url at every '/' and
#                              | pass the result as arguments to the script
# -s --static [ route ] [ dir ]| Make this route action serve the files in the
#                              | defined directory.
route(){
  declare case="case '$1'"
  declare paramsParse=''
  while ! [ -z $1 ]; do
    case $1 in
      -d|--default)
        declare case="default"
        ;;
      -g|--get-params)
        paramsParse+="$(
          template -f $HERE/server_code/get_params.js\
            -t param_arr     -v params\
            -t get_params    -v 'urlObject.query'
        )"$'\n'
        ;; 
      -r|--split-routes)
        paramsParse+="$(
          template -f $HERE/server_code/split_routes.js\
            -t param_arr    -v params\
            -t splitted_url -v splittedPathname
        )"$'\n'
        ;;
      -s|--static)
        shift
        template -f $HERE/server_code/static_case.js\
          -t CASE         -v "case '$1'"\
          -t dir_name     -v "'$2'"\
          -t splitted_url -v 'splittedPathname'
        return
        ;;
    esac
    shift
  done
  template -f "$HERE/server_code/route_case.js"\
    -t CASE          -v "$case"\
    -t param_arr     -v "params"\
    -t param_parsers -v "$paramsParse"
}
