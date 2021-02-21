#!/bin/bash

api=`find ./src/* | xargs cat | grep -E '^(function|  local).+?#'`

position=0

while read -r line
do
  is_function=`echo "$line" | grep -E '^function'`
  is_param=`echo "$line" | grep -E 'local'`

  if [ -n "$is_function" ]
  then
    position=0

    function_name=`echo "$line" | cut -d' ' -f2`
    function_desc=`echo "$line" | cut -d'#' -f2`
    
    printf '\n### Function: %s\n' "$function_name"
    printf '`%s`: %s\n' 'description' "$function_desc"
    printf '%s\n' '#### Params:'
  elif [ -n "$is_param" ]
  then
    position=$((position + 1))

    param_name=`echo "$line" | grep -oE 'local [a-z_]+=' | cut -d' ' -f2 | tr -d '='`
    param_position=$position
    param_required=`echo "$line" | grep -v default`
    param_optional=`echo "$line" | grep default`
    param_default=`echo "$line" | grep -E '\`default.+?\`' | cut -d' ' -f4 | tr -d '\`'`
    param_desc=`echo "$line" | cut -d'#' -f2`
    
    printf '\n\n`%s`: %s\\\n' 'name' "$param_name"
    printf '`%s`: %s\\\n' 'position' "$param_position"
    if [ -n "$param_required" ]
    then
      printf '`%s`\\\n' 'required'
    elif [ -n "$param_optional" ]
    then
      printf '`%s`\\\n' 'optional'
      printf '`%s`: %s\\\n' 'default' "$param_default"
    fi
    printf '`%s`: %s\n' 'description' "$param_desc"
  fi
done <<<"$api"
