#!/bin/bash

# Anchor points
ANCHOR_POINT_LEFT='1%'
ANCHOR_POINT_CENTER='50%'
ANCHOR_POINT_RIGHT='99%'
ANCHOR_POINT_TOP='1%'
ANCHOR_POINT_MIDDLE='50%'
ANCHOR_POINT_BOTTOM='99%'

# Directions' names
DIRECTION_DOWN='DOWN'
DIRECTION_LEFT='LEFT'
DIRECTION_RIGHT='RIGHT'
DIRECTION_UP='UP'

# Helpers start
#
function default() {
  local current_value="$1"
  local default_value="$2"

  if [ -z "$current_value" ]; then current_value=$default_value; fi

  echo "$current_value"
}

function calc_point_on_section() {
  local value="$1"
  local min="$2"
  local max="$3"
  local point=-1
  local is_percentage=`echo "$value" | grep '%'`

  if [ -n "$is_percentage" ]
  then
    local side=$((max - min))
    value=`echo $value | grep -oE '[0-9]+' | awk '{printf("%d", $1)}'`
    local pixels=`echo "$side $value" | awk '{printf("%d", ($1 / 100 * $2))}'`
    point=$((min + pixels))
  else
    point=$((min + value))
  fi

  #TODO consider keeping $point within min max range ???

  echo $point
}

function calc_point_on_surface() {
  local node="$1"
  local x=`default "$2" "$ANCHOR_POINT_CENTER"`
  local y=`default "$3" "$ANCHOR_POINT_MIDDLE"`

  local bounds=`get_prop "$node" 'bounds'`
  bounds=`echo "$bounds" | grep -oE '[0-9]+'`
  local left=`echo "$bounds" | sed -n '1p'`
  local top=`echo "$bounds" | sed -n '2p'`
  local right=`echo "$bounds" | sed -n '3p'`
  local bottom=`echo "$bounds" | sed -n '4p'`

  x=`calc_point_on_section "$x" "$left" "$right"`
  y=`calc_point_on_section "$y" "$top" "$bottom"`

  echo "$x $y"
}

function get_prop() {
  local node="$1"
  local prop_name="$2"

  echo "$node" | grep -oE "$prop_name=\".*?\"" | cut -d '=' -f 2 | cut -d '"' -f 2
}

function calc_duration_from_distance_speed() {
  local speed=`default "$1" 1000`
  local x_from="$2"
  local y_from="$3"
  local x_to="$4"
  local y_to="$5"

  local distance=`echo "$x_from $y_from $x_to $y_to" | awk '{printf("%d", sqrt(($1 - $3)^2 + ($2 - $4)^2))}'`
  local duration=`echo "$distance $speed" | awk '{printf("%d", ($1 / $2) * 1000)}'`

  echo "$duration"
}

# function calc_colors_distance() {
#   local color_1_red="$1"
#   local color_1_green="$2"
#   local color_1_blue="$3"
#   local color_2_red="$4"
#   local color_2_green="$5"
#   local color_2_blue="$6"
# 
#   local distance=`echo "$color_1_red $color_1_green $color_1_blue $color_2_red $color_2_green $color_2_blue" | awk '{printf("%d", sqrt(($1 - $4)^2 + ($2 - $5)^2 + ($3 - $6)^2))}'`
# 
#   echo "$distance"
# }
# 
# function find_closest_color() {
#   colors="Black 0,0,0
# White 255,255,255
# Red 255,0,0
# Lime 0,255,0
# Blue 0,0,255
# Yellow 255,255,0
# Cyan 0,255,255
# Magenta 255,0,255
# Silver 192,192,192
# Gray 128,128,128
# Maroon 128,0,0
# Olive 128,128,0
# Green 0,128,0
# Purple 128,0,128
# Teal 0,128,128
# Navy 0,0,128"
# }

# Helpers end
# 
# Other useful functions start
# 
# Returns string length
function helper_string_length() {
  local string="$1"

  echo "$string" | wc -c
}
# 
# Returns substring starting from with of length
function helper_substring() {
  local string="$1"
  local from="$2"
  local length="$3"

  string=`echo "$string" | sed -E "s/^.{${from}}//"`

  if [ -n "$length" ]
  then
    string=`echo "$string" | grep -oE "^.{${length}}" | sed -n '1p'`
  fi

  echo "$string"
}
#
# Transforms all characters to lower cases
function helper_to_lower() {
  local string="$1"
  echo "$string" | tr '[:upper:]' '[:lower:]'
}
#
# Transforms all characters to upper cases
function helper_to_upper() {
  local string="$1"
  echo "$string" | tr '[:lower:]' '[:upper:]'
}
#
# Transforms first letter to upper case and the rest to lower cases
function helper_capitalize() {
  local string="$1"

  local first=`helper_substring "$string" 0 1`
  local rest=`helper_substring "$string" 1`
  first=`helper_to_upper "$first"`
  rest=`helper_to_lower "$rest"`

  echo "${first}${rest}"
}
#
# Returns count of objects, but each must be in new line as it is based on wc program
# This should specially consume result from uio2_find_objects
function helper_objects_count() {
  local objects="$1"

  echo "$objects" | wc -l
}
#
# Other useful functions end
