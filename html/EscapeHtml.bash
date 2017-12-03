#!/bin/bash

#$'s/&/&amp;/g;
#  s/</&lt;/g;
#  s/>/&gt;/g;
#  s/"/&quot;/g;
#  s/\'/&#39;/g;
#  s///&#x2F;/g;
#  s/`/&#x60;/g;
#  s/=/&#x3D;/g'


##
# Escape html and assign the escaped string to a variable.
# Fails and returns 5 if the variable is not declared yet.
# $1: string to be escaped
# $2: nameof variable
# 
function HTML_escapeToVar {
  declare -p "$2" &>>/dev/null || return 5

  declare string="$1"
  declare -n var="$2"
  declare -A escapes=()

  escapes['<']='&lt;'
  escapes['>']='&gt;'
  escapes['"']='&#34;'
  escapes["'"]='&#39;'
  escapes['/']='&#x2F;'
  escapes['`']='&#x60;'
  escapes['=']='&#x3D;'

  for char in "${!escapes[@]}"; do
    string="${string//"$char"/"${escapes["$char"]}"}"
  done

  var="$string"
}

##
# Escape html and print it to stdout.
# $1: string to be escaped
function HTML_escape {
  declare echo_string=""
  HTML_escapeToVar "$1" echo_string
  
  echo "$echo_string"
}


