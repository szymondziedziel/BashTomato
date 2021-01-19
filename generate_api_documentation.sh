#!/bin/bash

api=`find ./src/* | xargs cat | grep -E '^(function|  local [a-z_]+?\=(\"\\$[0-9]|\`default))'`
api=`echo "$api" | sed -E 's/^function ([a-z0-9_]+)\(\) { \\# (.+)/\nFunction: \1\ndescription: \2/'`
api=`echo "$api" | sed -E 's/^  local ([a-z_]+)="\\$([0-9])"/Param\n  name: \1\n  position: \2\n  required\n  param_desc: /'`
api=`echo "$api" | sed -E 's/^  local ([a-z_]+)=\`default "\\$([0-9])" ([\\$a-zA-Z0-9\\%'\''"_\.]+)\`/Param\n  name: \1\n  position: \2\n  optional (default value \3)\n param_desc: /'`

function complete_descriptions() {
  while read -r line
  do
    local param_line=`echo "$line" | grep 'name:'`
    local desc_line=`echo "$line" | grep 'param_desc:'`
    local pos=`echo "$line" | grep 'position:'`
    local req=`echo "$line" | grep 'required'`
    local opt=`echo "$line" | grep 'optional'`

    if [ -n "$param_line" ]
    then
      # echo PARAM $line
      local param_name=`echo "$line" | sed 's/name: //'`
      local param_desc=`cat described-params.txt | grep "^$param_name : " | cut -d':' -f2`
      # echo "PARAMLINE [$line] [$param_name] [$param_desc]"
      echo "  $line"
    elif [ -n "$desc_line" ]
    then
      # echo DESC $line [$param_desc]
      echo "  description:${param_desc}"
    elif [ -n "$pos" ] || [ -n "$req" ] || [ -n "$opt" ]
    then
      echo "  $line"
    else
      echo "$line"
    fi
  done <<<"$api"
}

function format_to_md() {
  local api="$1"

  local is_prev_line_func=''

  while read -r line
  do
    local func=`echo "$line" | grep 'Function:'`
    local param=`echo "$line" | grep 'name:'`
    local desc=`echo "$line" | grep 'description:'`
    local pos=`echo "$line" | grep 'position:'`
    local req=`echo "$line" | grep 'required'`
    local opt=`echo "$line" | grep 'optional'`

    if [ -n "$func" ]
    then
      echo "#### $func"
    fi

    if [ -n "$desc" ]
    then
      echo "${desc}" | sed 's/:/ /' | awk '{ printf("`%s`: ", $1); if ($2) { $1=""; printf("%s\n", $0); } }'

      if [ -n "$is_prev_line_func" ]
      then
        echo "##### Params:
"
      else
        echo "---
"
      fi
    fi

    if [ -n "$param" ]
    then
      echo "${param}" | sed 's/:/ /' | awk '{ printf("`%s`: ", $1); if ($2) { $1=""; printf("%s\\\n", $0); } }'
    fi


    if [ -n "$pos" ]
    then
      echo "${pos}" | sed 's/:/ /' | awk '{ printf("`%s`: ", $1); if ($2) { $1=""; printf("%s\\\n", $0); } }'
    fi

    if [ -n "$req" ]
    then
      echo "${req}" | sed 's/:/ /' | awk '{ printf("`%s`\\\n", $1); }'
    fi

    if [ -n "$opt" ]
    then
      echo "${opt}" | sed 's/:/ /' | awk '{ printf("`%s`\\\n", $1); }'
    fi

    is_prev_line_func="$func"
  done <<<"$api"
}

api=`complete_descriptions`
format_to_md "$api"
