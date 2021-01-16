#!/bin/bash

# Values
TRUE='true'
FALSE='false'
NULL='null'

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

# function echo_success() {
#   message="$1"
# 
#   echo -e '\033[33m'
#   echo -e "$message"
#   echo -e '\033[0m'
# }
# 
# function echo_warning() {
#   message="$1"
# 
#   echo -e '\033[32m'
#   echo -e "$message"
#   echo -e '\033[0m'
# }
# 
# function echo_error() {
#   message="$1"
# 
#   echo -e "\033[31m"
#   echo -e "$message"
#   echo -e "\033[0m"
# }

function val_or_null() { # takes care to return special `$NULL` when value is bash-like-empty
  local value="$1"

  if [ -n "$value" ]
  then
    echo "$value"
  else
    echo "$NULL"
  fi
}

function default() { # helps easily assign default value for variable when bash-like-empty value provided
  local current_value="$1"
  local default_value="$2"

  if [ -z "$current_value" ]; then current_value=$default_value; fi

  val_or_null "$current_value"
}

function calc_point_on_section() { # calculates value from between `min` and `max`, distanced from min by number or percentage value
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

  val_or_null "$point"
}

function calc_point_on_surface() { # calculates point in 2D within surface defined by element's bounds, appropriately distanced from top and left by number of percentage values

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

  val_or_null "$x $y"
}

function get_prop() { # element or node is simply XML tag, this function extract attribute's value
  local node="$1"
  local prop_name="$2"

  echo "$node" | grep -oE "$prop_name=\".*?\"" | cut -d '=' -f 2 | cut -d '"' -f 2
}

function calc_duration_from_distance_speed() { # calculates times needed to travel from one 2D point to another for given speed
  local speed=`default "$1" 1000`
  local x_from="$2"
  local y_from="$3"
  local x_to="$4"
  local y_to="$5"

  local distance=`echo "$x_from $y_from $x_to $y_to" | awk '{printf("%d", sqrt(($1 - $3)^2 + ($2 - $4)^2))}'`
  local duration=`echo "$distance $speed" | awk '{printf("%d", ($1 / $2) * 1000)}'`

  val_or_null "$duration"
}

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

# Helpers end



# Other useful functions start

function helper_string_length() { # returns string's length
  local string="$1"

  local length=`echo -n "$string" | wc -c`

  val_or_null "$length"
}

function helper_substring() { # return substring of `length` starting `from`
  local string="$1"
  local from="$2"
  local length="$3"

  string=`echo "$string" | sed -E "s/^.{${from}}//"`

  if [ -n "$length" ]
  then
    string=`echo "$string" | grep -oE "^.{${length}}" | sed -n '1p'`
  fi

  val_or_null "$string"
}

function helper_to_lower() { # lowercase the whole given string
  local string="$1"
  echo "$string" | tr '[:upper:]' '[:lower:]'
}

function helper_to_upper() { # uppercase the whole given string
  local string="$1"
  echo "$string" | tr '[:lower:]' '[:upper:]'
}

function helper_capitalize() { # lowercase the whole given string, except first character which goes upper
  local string="$1"

  local first=`helper_substring "$string" 0 1`
  local rest=`helper_substring "$string" 1`
  first=`helper_to_upper "$first"`
  rest=`helper_to_lower "$rest"`

  echo "${first}${rest}"
}

function helper_objects_count() { # simply return lines, useful with uio2_find_objects
  local objects="$1"

  echo "$objects" | wc -l
}

function helper_does_string_starts_with() { # checks if given `string` starts with other string
  local string="$1"
  local start_string="$2"

  if [[ "$string" == "$start_string"* ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_does_string_ends_with() { # checks if given `string` ends with other string
  local string="$1"
  local end_string="$2"

  if [[ "$string" == *"$end_string" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_does_string_contains() { # checks if given `string` includes other string
  local string="$1"
  local substring="$2"

  if [[ "$string" == *"$substring"* ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_lower_case() { # ckecks if whole string is build from lowercase letters
  local string="$1"

  local is_lower_case=`echo "$string" | grep '^[a-z]+$'`
  if [[ -n "$is_lower_case" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_upper_case() { # ckecks if whole string is build from uppercase letters
  local string="$1"

  local is_upper_case=`echo "$string" | grep '^[A-Z]+$'`
  if [[ -n "$is_upper_case" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_capitalised() { # ckecks if whole string is build from lower letters, except first which is uppercase
  local string="$1"

  local is_capitalized=`echo "$string" | grep '^[A-Z][a-z]+$'`
  if [[ -n "$is_capitalized" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_does_strings_are_equal() { # checks if two strings are same
  local string_a="$1"
  local string_b="$2"

  string_a=`helper_to_lower "$string_a"`
  string_b=`helper_to_lower "$string_b"`
  if [[ "$string_a" == "$string_b" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_strings_join() { # joins all given strings given glue-string
  local glue=`default "$1" ''`
  shift

  echo "$@" | sed "s/ /$glue/g"
}

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

function helper_string_to_bytes() {
  local string="$1"

  echo "$string" | xxd -C -u -p
}

# function helper_string_trim() {
#   
# }

function helper_string_replace() { # replace all occurences of one string to another in the main one
  local string="$1"
  local string_a="$2"
  local string_b="$3"

  echo "$string" | sed "s/$string_a/$string_b/g"
}

# function helper_numbers_max() {
# 
# }

# function helper_numbers_min() {
# 
# }

# function helper_numbers_sum() {
# 
# }

# function helper_numbers_count() {
# 
# }

# function helper_numbers_average() {
# 
# }
#
# Other useful functions end
