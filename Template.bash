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
    declare wordCount=0 firstChar='true' i
    declare -a whitespaceBefore=()
    for ((i=0; i < ${#line}; i++)); do
      if [[ "${line:$i:1}" == ' ' ]]; then
        whitespaceBefore[$wordCount]+=' '
        firstChar="true"
      else
        if $firstChar; then
          ((wordCount++))
          firstChar="false"
        fi
      fi
    done
    declare currentWord=0 word
    IFS=' '
    for word in $line; do
      declare -a matched=()
      for ((i=0; i < ${#tags[@]}; i++)); do
        case $word in
          *${tags[$i]}*)
            matched[${#matched[@]}]=$i
            ;;
        esac
      done
      if [[ -z $matched ]]; then
        echo -E -n "${whitespaceBefore[$currentWord]}$word"
      else 
        declare result="$word"
        for match in ${matched[*]};do
          if [[ "$result" =~  (.*)${tags[$match]//\{/\\{}(.*) ]]; then
            result="${BASH_REMATCH[1]}${values[$match]}${BASH_REMATCH[2]}"
            declare lastMatch="$match"
          fi
        done
        echo -E "${BASH_REMATCH[1]}${values[$lastMatch]}" |\
          while IFS='' read -r output; do 
            [[ ! -z $hallo ]] && printf '\n' 
            echo -E -n "${whitespaceBefore[$currentWord]}$output"
            hallo=true
          done
          echo -E -n "${BASH_REMATCH[2]}"
      fi
      ((currentWord++))
    done
    printf "\n"
  done < $FILE
}
