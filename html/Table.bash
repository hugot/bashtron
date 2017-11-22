#!/bin/bash

openTable(){
  echo '<table>'
}

closeTable(){
  echo '</table>'
}

tHeaders() {
  echo "<tr>"
  for i in $(seq 1 $#); do
    echo "<th>$1</th>"
    shift
  done
  echo "</tr>"
}

tRow(){
  echo '<tr>'
  for i in $(seq 1 $#); do
    echo "<td>$1</td>"
    shift
  done
  echo "</tr>"
}
