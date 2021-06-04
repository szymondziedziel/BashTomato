#!/bin/bash

# UIObject2 API start

function uio2_clear() { # clears editable text, auto clicks on such element, very poor in terms of performance
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null

  local length=`get_prop "$node" 'text' | wc -c`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> length=<${length}>"

  uio2_click "$device_id" "$node"
  uid_press_key_code "$device_id" "$KEYCODE_MOVE_END"
  for i in `seq "$length"`
  do
    uid_press_key_code "$device_id" "$KEYCODE_DEL"
  done
}

function uio2_click() { # shortly clicks on element
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local x=`default "$3" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y=`default "$4" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> x=<${x}> y=<${y}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$x" "$TRUE" > /dev/null
  validators_integer_or_percent "$y" "$TRUE" > /dev/null

  local point_on_surface=`calc_point_on_surface "$node" "$x" "$y"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> point_on_surface=<${point_on_surface}>"

  # It is not base on uio2_click_with_duration, because uses tap instead of swipe
  adb -s "$device_id" shell input tap "$point_on_surface"
}

function uio2_click_with_duration() { # clicks with given duration, default 0.5 second
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local duration=`default "$3" 500` # expresed in milliseconds
  local x=`default "$4" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y=`default "$5" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> duration=<${duration}> x=<${x}> y=<${y}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$x" "$TRUE" > /dev/null
  validators_integer_or_percent "$y" "$TRUE" > /dev/null

  local point_on_surface=`calc_point_on_surface "$node" "$x" "$y"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> point_on_surface=<${point_on_surface}>"

  adb -s "$device_id" shell input swipe "$point_on_surface" "$point_on_surface" "$duration"
}

function uio2_click_and_wait() { # shortly clicks on element and waits, default 5 seconds
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local wait_time=`default "$3" 5` # expressed in seconds, bash greater than 3.2 it is possible to use values like 3.5, 1.6 etc.
  local x=`default "$4" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y=`default "$5" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> wait_time=<${wait_time}> x=<${x}> y=<${y}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_seconds "$wait_time" "$TRUE" > /dev/null
  validators_integer_or_percent "$x" "$TRUE" > /dev/null
  validators_integer_or_percent "$y" "$TRUE" > /dev/null

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  uio2_click "$device_id" "$node" "$x" "$y"
  sleep $wait_time
}

function uio2_drag() { # drags from one element to another. Start, end points can be changed by top, left margins for each
  local device_id="$1" # device id taken from `adb devices`
  local node_from="$2" # self explanatory
  local node_to="$3" # self explanatory
  local duration=`default "$4" 500` # expressed in milliseconds
  local x_from=`default "$5" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y_from=`default "$6" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent
  local x_to=`default "$7" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y_to=`default "$8" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node_from=<${node_from}> node_to=<${node_to}> duration=<${duration}> x_from=<${x_from}> y_from=<${y_from}> x_to=<${x_to}> y_to=<${y_to}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node_from" "$TRUE" > /dev/null
  validators_node "$node_to" "$TRUE" > /dev/null
  validators_seconds "$duration" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_to" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_to" "$TRUE" > /dev/null

  local point_on_surface_from=`calc_point_on_surface "$node_from" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node_to" "$x_to" "$y_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}>"

  adb -s "$device_id" shell input draganddrop "$point_on_surface_from" "$point_on_surface_to" "$duration"
}

function uio2_drag_with_speed() { # like uio2_drag, but speed may be defined instead fo duration
  local device_id="$1" # device id taken from `adb devices`
  local node_from="$2" # self explanatory
  local node_to="$3" # self explanatory
  local speed=`default "$4" 1000` # expressed in milliseconds
  local x_from=`default "$5" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y_from=`default "$6" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent
  local x_to=`default "$7" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y_to=`default "$8" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node_from=<${node_from}> node_to=<${node_to}> duration=<${duration}> x_from=<${x_from}> y_from=<${y_from}> x_to=<${x_to}> y_to=<${y_to}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node_from" "$TRUE" > /dev/null
  validators_node "$node_to" "$TRUE" > /dev/null
  validators_seconds "$duration" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_to" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_to" "$TRUE" > /dev/null

  local point_on_surface_from=`calc_point_on_surface "$node_from" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node_to" "$x_to" "$y_to"`
  local duration=`calc_duration_from_distance_speed "$speed" "$point_on_surface_from" "$point_on_surface_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}> duration=<${duration}>"

  adb -s "$device_id" shell input draganddrop "$point_on_surface_from" "$point_on_surface_to" "$duration"
}

function uio2_equals() { # compares elements like XML-strigs, not by reference
  local node_a="$1" # XML-string-like element, treated really as string not object reference in this case
  local node_b="$2" # XML-string-like element, treated really as string not object reference in this case

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node_a=<${node_a}> node_b=<${node_b}>"
  validators_node "$node_a" "$TRUE" > /dev/null
  validators_node "$node_b" "$TRUE" > /dev/null

  local test='UNDEFINED'

  if [ "$node_a" == "$node_b" ]
  then
    test="$TRUE"
  else
    test="$FALSE"
  fi

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> test=<${test}>"

  echo "$test"
}
# #SKIP Probably does no make what should do

function uio2_find_object() { # filters element from given XML-source matching regular expression pattern
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local filter="$2" # simple bash-grep-like expression passed with -oE options
  local index=`default "$3" 1` # instance number counting from 1

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> filter=<${filter}> index=<${index}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  # validators_node "$filter" "$TRUE" > /dev/null
  validators_unsigned_integer "$index" "$TRUE" > /dev/null

  local nodes=`uio2_find_objects "$xml" "$filter"`
  local node=`echo "$nodes" | sed -n "${index}p" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
  node=`val_or_null "$node"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> nodes=<(...NODES...) node=<${node}>>"

  echo "$node"
}

function uio2_find_objects() { # filters many element from given XML-source matching regular expression pattern
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local filter="$2" # simple bash-grep-like expression passed with -oE options

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> filter=<${filter}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  # validators_node "$filter" "$TRUE" > /dev/null

  local nodes=`echo "$xml" | grep -oE '<.+?>' | awk 'BEGIN{depth=0} { if (substr($0, length($0) - 1, 1) == "/") { printf("NR%d DEPTH%d %s\n", NR, depth, $0); } else if (substr($0, 2, 1) != "/") { printf("NR%d DEPTH%d %s\n", NR, depth, $0); depth++; } else { depth--; printf("NR%d DEPTH%d %s\n", NR, depth, $0); } }' | grep -oE "NR[0-9]{1,4} DEPTH[0-9]{1,4} <[^/].+?$filter.+?>"`
  nodes=`val_or_null "$nodes"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> nodes=<(...NODES...)>"

  echo "$nodes"
}
#
# fling(Direction direction, int speed)
# Performs a fling gesture on this object.
# #SKIP Please use uio2_swipe with duration from 50 to 200. Lower value means faster
# #SKIP I may be also helpful to experiment with different percents
#
# fling(Direction direction)
# Performs a fling gesture on this object.
# #SKIP Please use uio2_swipe with duration from 50 to 200. Lower value means faster
# #SKIP I may be also helpful to experiment with different percents
#
function uio2_get_application_package() { # get current package_name using ADB, may not work for all devices
  local device_id="$1" # device id taken from `adb devices`

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local package_name=`adb -s "$device_id" shell dumpsys window windows | grep "mCurrentFocus" | grep -oE '\{(.+?)\}' | tr '}' ' ' | cut -d ' ' -f3 | cut -d '/' -f1`
  package_name=`val_or_null "$package_name"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> package_name=<${package_name}>"

  echo "$package_name"
}
# #SKIP Not sure if will work for all devices

function uio2_get_children_count() { # count children of given node based on whole XML-source
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local node="$2" # XML-string-like element, which action will be performed at

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> node=<${node}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null

  local count=`uio2_get_children "$xml" "$node" | wc -l`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> count=<${count}>"

  echo "$count"
}

function uio2_get_children() { # filter childrens like XML-strings of given node from whole XML-source
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local node="$2" # XML-string-like element, which action will be performed at

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> node=<${node}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null

  xml=`uio2_find_objects "$xml"`
  local nodes_amount=`echo "$xml" | wc -l`
  local node_nr=`echo $node | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo $node | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local child_node_depth=$((node_depth + 1))
  xml=`echo "$xml" | sed -n "$((node_nr + 1)),${nodes_amount}p"`
  xml=`echo "$xml" | grep -oE 'NR[0-9]{1,4} DEPTH[0-9]{1,4} <[^\/].+?>'`

  local children=''
  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -eq $child_node_depth ]
    then
      if [ -z "$children" ]
      then
        children="$node"
      else
        children="
$children"
      fi
    fi

    if [ $next_node_depth -lt $child_node_depth ]; then break; fi
  done <<<"$xml"

  children=`val_or_null "$children"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> chidren=<(...CHILDREN...)> nodes_amount=<${nodes_amount}> node_nr=<${node_nr}> node_depth=<${node_depth}> child_node_depth=<${child_node_depth}>"

  echo "$children"
}

function uio2_get_class_name() { # gets XML element's class attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local class=`get_prop "$node" 'class'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> class=<${class}>"

  echo "$class"
}

function uio2_get_content_description() { # gets XML element's content-description attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local content_description=`get_prop "$node" 'content-desc'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> content_description=<${content_description}>"

  echo "$content_description"
}

function uio2_get_parent() { # gets element's parent based on ginec element and whole XML-source
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local node="$2" # XML-string-like element, which action will be performed at

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> node=<${node}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null

  xml=`uio2_find_objects "$xml"`
  local node_nr=`echo "$node" | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local parent_node_depth=$((node_depth - 1))
  xml=`echo "$xml" | sed -n "1,${node_nr}p"`
  xml=`echo "$xml" | sed -n '1!G;h;$p'`

  local result=''
  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -eq $parent_node_depth ]
    then
      result=`val_or_null "$node"`
      break
    fi
  done<<<"$xml"

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> parent=<${parent}> node_nr=<${node_nr}> node_depth=<${node_depth}> parent_node_depth=<${parent_node_depth}>"

  echo "$result"
}

function uio2_get_resource_id() { # gets XML element's resource-id attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local resource_id=`get_prop "$node" 'resource-id'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> resource_id=<${resource_id}>"

  echo "$resource_id"
}

function uio2_get_text() { # gets XML element's text attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local text=`get_prop "$node" 'text'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> text=<${text}>"

  echo "$text"
}

function uio2_get_bounds() { # gets XML element's bounds attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted
  local bound_name="$2" # bounds name, one of `left`, `top`, `right`, `bottom`

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}> bound_name=<${bound_name}>"
  validators_node "$node" "$TRUE" > /dev/null
  validators_bounds_name "$bound_name" "$TRUE" > /dev/null

  local bounds=`get_prop "$node" 'bounds'`
  bounds=`echo "$bounds" | grep -oE '[0-9]+'`
  local left=`echo "$bounds" | sed -n '1p'`
  local top=`echo "$bounds" | sed -n '2p'`
  local right=`echo "$bounds" | sed -n '3p'`
  local bottom=`echo "$bounds" | sed -n '4p'`

  local bound_value='UNDEFINED'
  case $bound_name in
    left) bound_value="$left" ;;
    top) bound_value="$top" ;;
    right) bound_value="$right" ;;
    bottom) bound_value="$bottom" ;;
    *) bound_value="left=$left,top=$top,right=$right,bottom=$bottom" ;;
  esac

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> bound_value=<${bound_value}>"

  echo "$bound_value"
}

function uio2_get_visible_center() { # calculates center of visible element's part
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}> bound_name=<${bound_name}>"
  validators_node "$node" "$TRUE" > /dev/null

  local point_on_surface=`calc_point_on_surface "$node"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> point_on_surface=<${point_on_surface}>"

  echo "$point_on_surface"
}

function uio2_has_object() {
  local xml="$1" # XML-string-like hierarchy or any of its part where the search will be performed
  local node="$2" # XML-string-like element, which action will be performed at
  local filter="$3" # simple bash-grep-like expression passed with -oE options

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> xml=<(...XML...)> node=<${node}> filter=<${filter}>"
  # validators_node "$xml" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  # validators_node "$filter" "$TRUE" > /dev/null

  xml=`uio2_find_objects "$xml"`
  local nodes_amount=`echo "$xml" | wc -l`
  local node_nr=`echo $node | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo $node | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local child_node_depth=$((node_depth + 1))
  xml=`echo "$xml" | sed -n "$((node_nr + 1)),${nodes_amount}p"`
  xml=`echo "$xml" | grep -oE 'NR[0-9]{1,4} DEPTH[0-9]{1,4} <[^\/].+?>'`
  local result='UNDEFINED'

  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -ge $child_node_depth ]
    then
      result="$result
      $node"
    fi

    if [ $next_node_depth -lt $child_node_depth ]; then break; fi
  done <<<"$xml"

  result=`echo "$result" | grep -E "$filter"`

  if [ -n "$result" ]
  then
    result="$TRUE"
  else
    result="$FALSE"
  fi

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> has=<${result}> nodes_amount=<${nodes_amount}> node_nr=<${node_nr}> node_depth=<${node_depth}> chiled_node_depth=<${chiled_node_depth}>"

  echo "$result"
}
#
# hashCode()
# #SKIP Not sure if it may be helpful at all

function uio2_is_checkable() { # gets XML element's checkable attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local checkable=`get_prop "$node" 'checkable'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> checkable=<${checkable}>"

  echo "$checkable"
}

function uio2_is_checked() { # gets XML element's checked attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local checked=`get_prop "$node" 'checked'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> checked=<${checked}>"

  echo "$checked"
}

function uio2_is_clickable() { # gets XML element's clickable attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local clickable=`get_prop "$node" 'clickable'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> clickable=<${clickable}>"

  echo "$clickable"
}

function uio2_is_enabled() { # gets XML element's enabled attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local enabled=`get_prop "$node" 'enabled'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> enabled=<${enabled}>"

  echo "$enabled"
}

function uio2_is_focusable() { # gets XML element's focusable
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local focusable=`get_prop "$node" 'focusable'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> focusable=<${focusable}>"

  echo "$focusable"
}

function uio2_is_focused() { # gets XML element's focused attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local focused=`get_prop "$node" 'focused'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> focused=<${focused}>"

  echo "$focused"
}

function uio2_is_long_clickable() { # gets XML element's long-clickable attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local long_clickable=`get_prop "$node" 'long-clickable'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> long_clickable=<${long_clickable}>"

  echo "$long_clickable"
}

function uio2_is_scrollable() { # gets XML element's scrollable attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local scrollable=`get_prop "$node" 'scrollable'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> scrollable=<${scrollable}>"

  echo "$scrollable"
}

function uio2_is_selected() { # gets XML element's selected attribute
  local node="$1" # XML-like-string element from which attribute's value will be extracted

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  validators_node "$node" "$TRUE" > /dev/null

  local selected=`get_prop "$node" 'selected'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> selected=<${selected}>"

  echo "$selected"
}

function uio2_long_click() { # clicks 0.5 seconds long on element
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local x=`default "$3" "$ANCHOR_POINT_CENTER"` # value in pixels or percent
  local y=`default "$4" "$ANCHOR_POINT_MIDDLE"` # value in pixels or percent

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> x=<${x}> y=<${y}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$x" "$TRUE" > /dev/null
  validators_integer_or_percent "$y" "$TRUE" > /dev/null

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  uio2_click_with_duration "$device_id" "$node" "$x" "$y" 500
} 

function uio2_pinch_close() { # performs pinch close gesture on elemetn with specified size
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local percent=`default "$3" '50%'` # self explanatory
  local duration=`default "$4" 500` # expressed in milliseconds

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> percent=<${percent}> duration=<${duration}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$percent" "$TRUE" > /dev/null
  validators_milliseconds "$duration" "$TRUE" > /dev/null

  local percent_amount=`echo "$percent" | grep -oE '[0-9]+'`

  if [ "$percent_amount" -gt 100 ]
  then
    percent_amount=100
    percent="100%"
  fi

  local offset=`echo "$percent_amount" | awk '{printf("%d", ((100 - $1) / 2))}'`
  
  local start="$offset%"
  local end="$((percent_amount + offset))%"

  local y_from="$start"
  local y_to="$end"

  local point_on_surface_from=`calc_point_on_surface "$node" "$ANCHOR_POINT_CENTER" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$ANCHOR_POINT_CENTER" "$y_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> percent_amount=<${percent_amount}> offset=<${offset}> start=<${start}> end=<${end}> y_from=<${y_from}> y_to=<${y_to}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}>"

  adb -s "$device_id" shell input tap "$point_on_surface_from" &
  pid1=$!
  sleep 0.1
  adb -s "$device_id" shell input swipe "$point_on_surface_to" "$point_on_surface_from" "$duration" &
  pid2=$!
  wait $pid1
  wait $pid2
}
#
# pinchClose(float percent, int speed)
# Performs a pinch close gesture on this object.
# #SKIP As uio2_pinch_close works, but in weird way in my opinion. It needs further investigation.
#
# pinchOpen(float percent)
# Performs a pinch open gesture on this object.
function uio2_pinch_open() { # performs pinch open gesture on elemetn with specified size
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local percent=`default "$3" '50%'` # self explanatory
  local duration=`default "$4" 500` # expressed in milliseconds

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> percent=<${percent}> duration=<${duration}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$percent" "$TRUE" > /dev/null
  validators_milliseconds "$duration" "$TRUE" > /dev/null

  local percent_amount=`echo "$percent" | grep -oE '[0-9]+'`

  if [ "$percent_amount" -gt 100 ]
  then
    percent_amount=100
    percent="100%"
  fi

  local offset=`echo "$percent_amount" | awk '{printf("%d", ((100 - $1) / 2))}'`
  
  local start="$offset%"
  local end="$((percent_amount + offset))%"

  local y_from="$start"
  local y_to="$end"

  local point_on_surface_from=`calc_point_on_surface "$node" "$ANCHOR_POINT_CENTER" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$ANCHOR_POINT_CENTER" "$y_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> percent_amount=<${percent_amount}> offset=<${offset}> start=<${start}> end=<${end}> y_from=<${y_from}> y_to=<${y_to}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}>"

  adb -s "$device_id" shell input tap "$point_on_surface_from" &
  pid1=$!
  sleep 0.1
  adb -s "$device_id" shell input swipe "$point_on_surface_from" "$point_on_surface_to" "$duration" &
  pid2=$!
  wait $pid1
  wait $pid2
}
#
# pinchOpen(float percent, int speed)
# Performs a pinch open gesture on this object.
# #SKIP As uio2_pinch_open works, but in weird way in my opinion. It needs further investigation.
#
# recycle()
# Recycle this object.
# #SKIP I do not know now what does recycle mean
#
# scroll(Direction direction, float percent)
# Performs a scroll gesture on this object.
# #SKIP Please use uio2_swipe
#
# scroll(Direction direction, float percent, int speed)
# Performs a scroll gesture on this object.
# #SKIP Please use uio2_swipe
#
# setGestureMargin(int margin)
# Sets the margins used for gestures in pixels.
# #SKIP I don't think this is helpful as uio2_click* consumes left-to-right and top-to-bottom in percents from 0 to 100
#
# setGestureMargins(int left, int top, int right, int bottom)
# Sets the margins used for gestures in pixels.
# #SKIP I don't think this is helpful as uio2_click* consumes left-to-right and top-to-bottom in percents from 0 to 100
#
# setText(String text)
# Sets the text content if this object is an editable field.
function uio2_set_text() { # write text to editable, auto clicks the element
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local content=`default "$3" ''` # text to be typed inside editable

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> content=<${content}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null

  uio2_click "$device_id" "$node"
  content=`echo "$content" | sed -E 's/(.)/_BTSEP_\1/g' | sed -E 's/_BTSEP_/\\\\/g'`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input text "$content"
}
# #TODO this is not able to type everything. Need huge improvement.

function uio2_swipe_with_speed() { # like uio2_swipe, but need speed instead of duration
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local direction=`default "$3" "$DIRECTION_DOWN"` # direction to which gesture should be moved
  local percent=`default "$4" '50%'` # self explanatory
  local speed=`default "$5" 1000` # expressed in milliseconds

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> percent=<${percent}> speed=<${speed}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$percent" "$TRUE" > /dev/null
  validators_unsigned_integer "$speed" "$TRUE" > /dev/null

  local percent_amount=`echo "$percent" | grep -oE '[0-9]+'`

  if [ "$percent_amount" -gt 100 ]
  then
    percent_amount=100
    percent="100%"
  fi

  local offset=`echo "$percent_amount" | awk '{printf("%d", ((100 - $1) / 2))}'`

  local start="$offset%"
  local end="$((percent_amount + offset))%"

  local x_from="$ANCHOR_POINT_CENTER"
  local x_to="$ANCHOR_POINT_CENTER"
  local y_from="$ANCHOR_POINT_MIDDLE"
  local y_to="$ANCHOR_POINT_MIDDLE"
  case $direction in
    $DIRECTION_DOWN)
      y_from="$end"
      y_to="$start"
      ;;
    $DIRECTION_LEFT)
      x_from="$end"
      x_to="$start"
      ;;
    $DIRECTION_RIGHT)
      x_from="$start"
      x_to="$end"
      ;;
    $DIRECTION_UP)
      y_from="$start"
      y_to="$end"
      ;;
  esac

  local point_on_surface_from=`calc_point_on_surface "$node" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$x_to" "$y_to"`

  local duration=`calc_duration_from_distance_speed "$speed" "$point_on_surface_from" "$point_on_surface_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> percent_amount=<${percent_amount}> offset=<${offset}> start=<${start}> end=<${end}> x_from=<${x_from}> x_to=<${x_to}> y_from=<${y_from}> y_to=<${y_to}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}> duration=<${duration}>"

  adb -s "$device_id" shell input swipe $point_on_surface_from $point_on_surface_to $duration
}

function uio2_swipe() { # performs swipe on element from its one point to another
  local device_id="$1" # device id taken from `adb devices`
  local node="$2" # XML-string-like element, which action will be performed at
  local direction=`default "$3" "$DIRECTION_DOWN"` # direction to which gesture should be moved
  local percent=`default "$4" '50%'` # self explanatory
  local duration=`default "$5" 500` # expressed in milliseconds

  logs_append "`logs_time` | UIOBJECT2_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> node=<${node}> percent=<${percent}> duration=<${duration}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$node" "$TRUE" > /dev/null
  validators_integer_or_percent "$percent" "$TRUE" > /dev/null
  validators_unsigned_integer "$duration" "$TRUE" > /dev/null

  local percent_amount=`echo "$percent" | grep -oE '[0-9]+'`

  if [ "$percent_amount" -gt 100 ]
  then
    percent_amount=100
    percent="100%"
  fi

  local offset=`echo "$percent_amount" | awk '{printf("%d", ((100 - $1) / 2))}'`

  local start="$offset%"
  local end="$((percent_amount + offset))%"

  local x_from="$ANCHOR_POINT_CENTER"
  local x_to="$ANCHOR_POINT_CENTER"
  local y_from="$ANCHOR_POINT_MIDDLE"
  local y_to="$ANCHOR_POINT_MIDDLE"
  case $direction in
    $DIRECTION_UP)
      y_from="$end"
      y_to="$start"
      ;;
    $DIRECTION_LEFT)
      x_from="$end"
      x_to="$start"
      ;;
    $DIRECTION_RIGHT)
      x_from="$start"
      x_to="$end"
      ;;
    $DIRECTION_DOWN)
      y_from="$start"
      y_to="$end"
      ;;
  esac

  local point_on_surface_from=`calc_point_on_surface "$node" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$x_to" "$y_to"`

  logs_append "`logs_time` | UIOBJECT2_ACTION | OUTPUT | function=<${FUNCNAME[0]}> percent_amount=<${percent_amount}> offset=<${offset}> start=<${start}> end=<${end}> x_from=<${x_from}> x_to=<${x_to}> y_from=<${y_from}> y_to=<${y_to}> point_on_surface_from=<${point_on_surface_from}> point_on_surface_to=<${point_on_surface_to}>"

  adb -s "$device_id" shell input swipe $point_on_surface_from $point_on_surface_to $duration
}
#
# wait(SearchCondition<R> condition, long timeout)
# Waits for given the condition to be met.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# wait(UiObject2Condition<R> condition, long timeout)
# Waits for given the condition to be met.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# UIObject2 API end
