#!/bin/bash

##
# Log something to a specified file
log(){
  echo "$(date)" >> "var/log/$1.log"
  echo "${@:2}" >> "var/log/$1.log"
}
