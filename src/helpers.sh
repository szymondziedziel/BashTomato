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
function default() {
  current_value="$1"
  default_value="$2"

  if [ -z "$current_value" ]; then current_value=$default_value; fi

  echo "$current_value"
}

function calc_point_on_section() {
  value="$1"
  min="$2"
  max="$3"
  point=-1
  is_percentage=`echo "$value" | grep '%'`

  if [ -n "$is_percentage" ]
  then
    side=$((max - min))
    value=`echo $value | grep -oE '[0-9]+' | awk '{printf("%d", $1)}'`
    pixels=`echo "$side $value" | awk '{printf("%d", ($1 / 100 * $2))}'`
    point=$((min + pixels))
  else
    point=$((min + value))
  fi

  #TODO consider keeping $point within min max range ???

  echo $point
}

function calc_point_on_surface() {
  node="$1"
  x=`default "$2" "$ANCHOR_POINT_CENTER"`
  y=`default "$3" "$ANCHOR_POINT_MIDDLE"`

  bounds=`get_prop "$node" 'bounds'`
  bounds=`echo "$bounds" | grep -oE '[0-9]+'`
  left=`echo "$bounds" | sed -n '1p'`
  top=`echo "$bounds" | sed -n '2p'`
  right=`echo "$bounds" | sed -n '3p'`
  bottom=`echo "$bounds" | sed -n '4p'`

  x=`calc_point_on_section "$x" "$left" "$right"`
  y=`calc_point_on_section "$y" "$top" "$bottom"`

  echo "$x $y"
}

function get_prop() {
  node="$1"
  prop_name="$2"

  echo "$node" | grep -oE "$prop_name=\".*?\"" | cut -d '=' -f 2 | cut -d '"' -f 2
}

# function calc_duration_from_distance_speed() {
#   speed=`default "$1" 1000`
#   x_from=`default "$2" "$ANCHOR_POINT_CENTER"`
#   y_from=`default "$3" "$ANCHOR_POINT_MIDDLE"`
#   x_to=`default "$4" "$ANCHOR_POINT_CENTER"`
#   y_to=`default "$5" "$ANCHOR_POINT_MIDDLE"`
# 
#   distance=`echo "$x_from $y_from $x_to $y_to" | awk '{printf("%d", sqrt(($1 - $3)^2 + ($2 - $4)^2))}'`
#   duration=`echo "$distance $speed" | awk '{printf("%d", ($1 / $2))}'`
# 
#   echo "$duration"
# }
# Helpers end

# Other useful functions start
function helper_string_length() {
  string="$1"

  echo "$string" | wc -c
}

function helper_objects_count() {
  objects="$1"

  echo "$objects" | wc -l
}
# Other useful functions end
