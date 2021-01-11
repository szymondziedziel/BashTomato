#!/bin/bash

api=`find ./src/* | xargs cat | grep -E '^(function|  local [a-z_]+?\=(\"\\$[0-9]|\`default))'`
api=`echo "$api" | sed -E 's/^function ([a-z0-9_]+)\(\) { \\# (.+)/\nFunction: \1\ndescription: \2/'`
api=`echo "$api" | sed -E 's/^  local ([a-z_]+)="\\$([0-9])"/Param\n  name: \1\n  position: \2\n  required\n  description: /'`
api=`echo "$api" | sed -E 's/^  local ([a-z_]+)=\`default "\\$([0-9])" ([\\$a-zA-Z0-9\\%'\''"_\.]+)\`/Param\n  name: \1\n  position: \2\n  optional (default value \3)\n  description: /'`
echo "$api"
