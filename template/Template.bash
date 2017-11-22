#!/bin/bash
#
# Parse temlates and fill in values for tags.
# Template tags look like this: {{--TAG_NAME--}}.
# tagnames passed in params are uppercased automatically.

template(){
  declare -a tags=() values=()

  while [ $# -gt 0 ]; do
    case $1 in
      -t|--tag)
        declare -u tags[${#tags[@]}]="{{--${2}--}}"
        ;;
      -v|--value)
        declare values[${#values[@]}]="$2"
        ;;
      -f|--file)
        declare FILE="$2"
        ;;
    esac
    shift
  done

  if [[ -z $FILE ]]; then
    echo No filename specified for template. >&2
    exit 200
  elif [[ ! -f $FILE ]]; then
    echo File $FILE not found. >&2
    exit 201
  fi

  if [[ ${#tags[@]} -ne ${#values[@]} ]]; then
    echo Error: all tags need to have a replacement value. >&2
    exit 202
  fi

  declare line
  while IFS='' read -r line; do
    declare tagno=0
    for tag in ${tags[@]};do
        line="${line//$tag/${values[$tagno]}}"
        ((tagno++))
    done
    echo -E "$line"
  done < $FILE
}
