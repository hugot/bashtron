#!/bin/bash

##
# Listen for messages and log them. Supposed to run as a coprocess.
# Easy way to log server errors and events by redirecting stderr and
# stdout to the coproc filedescriptor.
logger(){
  touch "$1"
  while read -r line; do
    date
    echo -E "$line"
  done >> "$1"
}
