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

# Searching swipe direction
DIRECTION_VERTICAL='DIRECTION_VERTICAL'
DIRECTION_HORIZONTAL='DIRECTION_HORIZONTAL'

# Helpers start
#
# default
# Helps setup default value for variable
function default() {
  local current_value="$1"
  local default_value="$2"

  if [ -z "$current_value" ]; then current_value=$default_value; fi

  echo "$current_value"
}
# 
# calc_point_on_section
# Returns 1-dimentional-point (single number) from between two points
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
#
# calc_point_on_surface
# Calculates 2-dimentional-point (two numbers separated by single space) within given rectangle
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
#
# get prop
# Searches for any given XML node attribute's value. Uses regular expression, some attributes may collide like for example click and long-click. Be carefuli as all matches will be returned in separate lines.
function get_prop() {
  local node="$1"
  local prop_name="$2"

  echo "$node" | grep -oE "$prop_name=\".*?\"" | cut -d '=' -f 2 | cut -d '"' -f 2
}

# calc_duration_from_distance_speed
# Function nam is self explanatory
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
# 
# calc_colors_distance
# Helps in color normalization
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
#
# }
#
# Helpers end



# Other useful functions start
#
# helper_string_length
# Returns string length
function helper_string_length() {
  local string="$1"

  local length=`echo "$string" | wc -c`
  length=$((length - 1))
  echo "$length"
}
# 
# helper_substring
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
# helper_to_lower
# Transforms all characters to lower cases
function helper_to_lower() {
  local string="$1"
  echo "$string" | tr '[:upper:]' '[:lower:]'
}
#
# helper_to_upper
# Transforms all characters to upper cases
function helper_to_upper() {
  local string="$1"
  echo "$string" | tr '[:lower:]' '[:upper:]'
}
#
# helper_capitalize
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
# helper_objects_count
# Returns count of objects, but each must be in new line as it is based on wc program
# This should specially consume result from uio2_find_objects
function helper_objects_count() {
  local objects="$1"

  echo "$objects" | wc -l
}
#
# helper_does_string_starts_with
# Docs here
function helper_does_string_starts_with() {
  local string="$1"
  local start_string="$2"

  if [[ "$string" == "$start_string"* ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_does_string_ends_with
# Docs here
function helper_does_string_ends_with() {
  local string="$1"
  local end_string="$2"

  if [[ "$string" == *"$end_string" ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_does_string_contains
# Docs here
function helper_does_string_contains() {
  local string="$1"
  local substring="$2"

  if [[ "$string" == *"$substring"* ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_string_is_lower_case
# Docs here
function helper_string_is_lower_case() {
  local string="$1"

  local is_lower_case=`echo "$string" | grep '^[a-z]+$'`
  if [[ -n "$is_lower_case" ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_string_is_upper_case
# Docs here
function helper_string_is_upper_case() {
  local string="$1"

  local is_upper_case=`echo "$string" | grep '^[A-Z]+$'`
  if [[ -n "$is_upper_case" ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_string_is_capitalised
# Docs here
function helper_string_is_capitalised() {
  local string="$1"

  local is_capitalized=`echo "$string" | grep '^[A-Z][a-z]+$'`
  if [[ -n "$is_capitalized" ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_does_strings_are_equal
# Docs here
function helper_does_strings_are_equal() {
  local string_a="$1"
  local string_b="$2"

  string_a=`helper_to_lower "$string_a"`
  string_b=`helper_to_lower "$string_b"`
  if [[ "$string_a" == "$string_b" ]]
  then
    echo 'true'
  else
    echo 'false'
  fi
}
#
# helper_strings_join
# Docs here
function helper_strings_join() {
  echo "$@" | sed 's/ //g'
}
#
# helper_string_index_of_string
# Docs here
function helper_string_index_of_string() {
  local string_a="$1"
  local string_b="$2"
  local start_from=`default "$3" 0`

  string_a=`helper_substring "$string_a" "$start_from"`
  local match=`echo "$string_a" | grep -oE ".*?$string_b" | sed -n '1p'`
  local string_b_length=`helper_string_length "$string_b"`
  local match_length=`helper_string_length "$match"`
  local index=$((match_length - string_b_length))

  echo "$index"
}
#
# helper_string_to_bytes
# Docs here
function helper_string_to_bytes() {
  local string="$1"

  echo "$string" | xxd -C -u -p
}
#
# helper_string_trim
# Docs here
# function helper_string_trim() {
#   
# }
#
# helper_string_replace
# Docs here
function helper_string_replace() {
  local string_a="$1"
  local string_b="$2"

  echo "$string_a" | sed "s/$string_a/$string_b/g"
}
#
# helper_numbers_max
# Docs here
# function helper_numbers_max() {
# 
# }
#
# helper_numbers_min
# Docs here
# function helper_numbers_min() {
# 
# }
#
# helper_numbers_sum
# Docs here
# function helper_numbers_sum() {
# 
# }
#
# helper_numbers_count
# Docs here
# function helper_numbers_count() {
# 
# }
#
# helper_numbers_average
# Docs here
# function helper_numbers_average() {
# 
# }
#
# Other useful functions end
