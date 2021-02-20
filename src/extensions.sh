#!/bin/bash

# BashTomato Extensions API start

function ext_screenshot_node() { # makes screenshot and cuts out image of given element
  local node="$1" # XML-string-like element of which screenshot is to be done
  local screenshot_filename=`default "$2" 'temporary_screenshot_filename.png'` # path to full screenshot with `.png` extension from which node screenshot will be taken
  local node_screenshot_filename=`default "$3" 'temporary_node_screenshot_filename.png'` # path to point to where node screenshot will be stored
  
  left=`uio2_get_bounds "$node" left`
  top=`uio2_get_bounds "$node" top`
  right=`uio2_get_bounds "$node" right`
  bottom=`uio2_get_bounds "$node" bottom`
  width=$((right - left))
  height=$((bottom - top))

  convert "$screenshot_filename" -crop "${width}x${height}+${left}+${top}" "${node_screenshot_filename}"
}

function ext_inspect_window_hierarchy() { # makes full screenshot and then images of all nodes in hierarchy
  local xml=`default "$1" ''` # XML-like-string of entire window hierarchy or any of its subnode. 
  local screenshot_filename=`default "$2" 'temporary_screenshot_filename.png'` # path to full screenshot with `.png` extension from which node screenshot will be taken
  local directory=`default "$3" 'inspect'` # directory path where to store all nodes' screenshots

  local nodes=`uio2_find_objects "$xml"`

  mkdir -p "$directory"

  while read -r node
  do
    nr_depth_id=`echo "$node" | cut -d' ' -f1-2 | sed 's/ /_/' | tr '[:upper:]' '[:lower:]'`
    ext_screenshot_node "$node" "$screenshot_filename" "$directory/${nr_depth_id}.png"
  done <<<"$nodes"

  # #TODO create html with hierarchy tree
}
#
# ext_get_node_colors_description
# Docs here
# function ext_get_node_colors_description() {
#   local node="$1"
#   local node_screenshot_filename=`default "$2" 'temporary_node_screenshot_filename.png'`
#   local node_screenshot_temp_for_processing=`default "$3" 'node_screenshot_temp_for_processing.png'`
# 
#   # convert 1_18.jpg +dither -colors 5 -unique-colors txt:
# 
#   # convert "$node_screenshot_filename" -resize "$sample_resize" "$node_screenshot_temp_for_processing"
# 
#   # size=`identify -format "%w %h" "$node_screenshot_temp_for_processing"`
#   # width=`echo "$size" | cut -d' ' -f1`
#   # height=`echo "$size" | cut -d' ' -f2`
# 
#   # for i in `seq 0 "$((width - 1))"`
#   # do
#   #   for j in `seq 0 "$((height - 1))"`
#   #   do
#   #     echo "I, J: $i, $j\n"
#   #     # image_color=`convert "$node_screenshot_temp_for_processing" -crop "${i}x${j}+0+0" txt: | grep -oE '\(([0-9]{1,3},){3}' | sed -e 's/(//' -e 's/,/ /g' -ne '1p'`
#   #     image_color=`convert "$node_screenshot_temp_for_processing" -crop "${i}x${j}+0+0" txt:`
#   #     echo "$image_color"
#   #   done
#   # done
# }
#
# BashTomato Extensions API end
