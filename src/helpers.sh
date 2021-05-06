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

# Colors
INFO=34
SUCCESS=92
WARNING=93
ERROR=91

# Helpers start

function echo_info() {
  message="$1"
  echo -e "\033[${INFO}m${message}\033[0m"
}

function echo_success() {
  message="$1"
  echo -e "\033[${SUCCESS}m${message}\033[0m"
}

function echo_warning() {
  message="$1"
  echo -e "\033[${WARNING}m${message}\033[0m"
}

function echo_error() {
  message="$1"
  echo -e "\033[${ERROR}m${message}\033[0m"
}

function val_or_null() { # takes care to return special `$NULL` when given value is bash-like-empty
  local value="$1" # value that may be normalized to `$NULL`

  if [ -n "$value" ]
  then
    echo "$value"
  else
    echo "$NULL"
  fi
}

function default() { # helps easily assign default value to variable when bash-like-empty value is provided
  local current_value="$1" # actual value
  local default_value="$2" # value to return when actual value will be bash-like-empty. If this value will be also bash-like-empty then `val_or_null` function will be applied to actual value

  if [ -z "$current_value" ]; then current_value=$default_value; fi

  val_or_null "$current_value"
}

function calc_point_on_section() { # calculates value from between `min` and `max`, distanced from min by number or percentage value. Currently function does not take care to keep result in bounds of `min` and `max`
  local value="$1" # distance from min expressed in pixels or percent from |max-min| result
  local min="$2" # lower border
  local max="$3" # higher border

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
  local node="$1" # XML-string-like element, which determines bounds of interaction like click, swipe etc. on the device's screen
  local x=`default "$2" "$ANCHOR_POINT_CENTER"` # distance from left edge of element
  local y=`default "$3" "$ANCHOR_POINT_MIDDLE"` # distance from top edge of element

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

function get_prop() { # element or node is simply XML-string-like element, this function extract given attribute's value
  local node="$1" # XML-string-like element from which attribute value will be extracted
  local prop_name="$2" # XML attribute name

  echo "$node" | grep -oE " $prop_name=\".*?\"" | cut -d '=' -f2 | cut -d '"' -f2 #PANICCHANGE
}

function calc_duration_from_distance_speed() { # calculates time needed to travel from one 2D point to another for given speed
  local x_from="$1" # self explanatory
  local y_from="$2" # self explanatory
  local x_to="$3" # self explanatory
  local y_to="$4" # self explanatory
  local speed=`default "$5" 1000` # self explanatory

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

function helper_string_length() { # returns string's length #TODO what will be the result of zero-length string?
  local string="$1" # string, which length will be calculated

  local length=`echo -n "$string" | wc -c`

  val_or_null "$length"
}

function helper_string_substring() { # returns substring with `length` starting from `from`, bash-like-empty string will result with `$NULL`
  local string="$1" # value to opearate on
  local from="$2" # start index, 0 means the very beginning; first string's character
  local length="$3" # length to cut out

  string=`echo "$string" | sed -E "s/^.{${from}}//"`

  if [ -n "$length" ]
  then
    string=`echo "$string" | grep -oE "^.{${length}}" | sed -n '1p'`
  fi

  val_or_null "$string"
}

function helper_string_to_lower() { # lowercase given string, bash-like-empty string will result with empty string instead of `$NULL`
  local string="$1" # self explanatory

  echo "$string" | tr '[:upper:]' '[:lower:]'
}

function helper_string_to_upper() { # uppercase given string, bash-like-empty string will result with empty string instead of `$NULL`
  local string="$1" # self explanatory

  echo "$string" | tr '[:lower:]' '[:upper:]'
}

function helper_string_capitalize() { # lowercase given string, except first character, which goes upper, bash-like-empty string will result with empty string instead of `$NULL`
  local string="$1" # self explanatory

  local first=`helper_substring "$string" 0 1`
  local rest=`helper_substring "$string" 1`
  first=`helper_to_upper "$first"`
  rest=`helper_to_lower "$rest"`

  echo "${first}${rest}"
}

function helper_objects_count() { # simply returns lines count, useful with `uio2_find_objects` as every XML-like-element is located in single line. It will cheat you if you accidentally pass `$NULL`, which may be returned from `uio2_find_objects`
  local objects="$1" # multiline text

  echo "$objects" | wc -l
}

function helper_string_does_string_starts_with() { # checks if given `string` starts with other string
  local string="$1" # value to operate on
  local start_string="$2" # value that is expected to be at the beginning of `string`

  if [[ "$string" == "$start_string"* ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_does_string_ends_with() { # checks if given `string` ends with other string
  local string="$1" # value to operate on
  local end_string="$2" # value that is expected to be at the end of `string`

  if [[ "$string" == *"$end_string" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_does_string_contains() { # checks if given `string` includes other string
  local string="$1" # value to operate on
  local substring="$2" # value that is expected to exists (entirely) within `string` at any index

  if [[ "$string" == *"$substring"* ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_lower_case() { # ckecks if whole string is build from lowercase letters
  local string="$1" # value to operate on

  local is_lower_case=`echo "$string" | grep '^[a-z]+$'`
  if [[ -n "$is_lower_case" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_upper_case() { # ckecks if whole string is build from uppercase letters
  local string="$1" # value to operate on

  local is_upper_case=`echo "$string" | grep '^[A-Z]+$'`
  if [[ -n "$is_upper_case" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_is_capitalised() { # ckecks if whole string is build from lower letters, except first which is uppercase
  local string="$1" # value to operate on

  local is_capitalized=`echo "$string" | grep '^[A-Z][a-z]+$'`
  if [[ -n "$is_capitalized" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_does_strings_are_equal() { # checks if two strings are same
  local string_a="$1" # self explanatory
  local string_b="$2" # self explanatory

  string_a=`helper_to_lower "$string_a"`
  string_b=`helper_to_lower "$string_b"`
  if [[ "$string_a" == "$string_b" ]]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}

function helper_string_join() { # joins all given strings with given glue-string
  local glue=`default "$1" ''` # string which will be added between all other passed to function (except beginning and end)
  shift

  echo "$@" | sed "s/ /$glue/g" #PANICCHANGE this is broken
}

function helper_string_index_of_string() { # finds index of first occurence of `string_b` in `string_a` starting from `start_from`
  local string_a="$1" # self explanatory
  local string_b="$2" # self explanatory
  local start_from=`default "$3" 0` # self explanatory

  string_a=`helper_substring "$string_a" "$start_from"`
  local match=`echo "$string_a" | grep -oE ".*?$string_b" | sed -n '1p'`
  local string_b_length=`helper_string_length "$string_b"`
  local match_length=`helper_string_length "$match"`
  local index=$((match_length - string_b_length))

  var_or_null "$index" #PANICCHANGE
}

function helper_string_to_bytes() { # self explanatory
  local string="$1" #self explanatory

  echo -n "$string" | xxd -C -u -p #PANICCHANGE
}

# function helper_string_trim() {
#   
# }

function helper_string_replace() { # replace all occurences of one string to another in the main one
  local string="$1" # value to operate on
  local string_a="$2" # string to search for
  local string_b="$3" # string to replace for

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
