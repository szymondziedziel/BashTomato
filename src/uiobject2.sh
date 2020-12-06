#!/bin/bash

# UIObject2 API start
#
#DOCS__
#
# ##### Docs from Google
# ###### clear()
# Clears the text content if this object is an editable field.
#
# ##### Docs from BashTomato
# ###### uio2_clear()
# Clears whole content for provided node on provided device.
# Focuses the node automatically.
# This is very poor in terms or performance for long contents.
# 
# ###### Parameters:
# - device_id
# - node
#
#__DOCS
function uio2_clear() {
  local device_id="$1"
  local node="$2"

  local length=`get_prop "$node" 'text' | wc -c`

  uio2_click "$device_id" "$node"
  uid_press_key_code "$device_id" $KEYCODE_MOVE_END
  for i in `seq $length`
  do
    uid_press_key_code "$device_id" $KEYCODE_DEL
  done
}
#
#DOCS__
#
# ##### Docs from Google
# ###### click()
# Clicks on this object.
#
# ##### Docs from BashTomato
# ###### uio2_click()
# Clicks on provided node on provided device.
# 
# ###### Parameters:
# - device_id
# - node
# - x
# - y
#
#__DOCS
function uio2_click() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local x=`default "$3" "$ANCHOR_POINT_CENTER"`
  local y=`default "$4" "$ANCHOR_POINT_MIDDLE"`

  local point_on_surface=`calc_point_on_surface "$node" "$x" "$y"`

  # It is not base on uio2_click_with_duration, because uses tap instead of swipe
  adb -s "$device_id" shell input tap "$point_on_surface"
}
#
#DOCS__
#
# ##### Docs from Google
# click(long duration)
# Performs a click on this object that lasts for duration milliseconds.
#
# ##### Docs from BashTomato
# ###### uio2_click_with_duration()
# Clicks on provided node on provided device.
# Gesture is longer than normal uio2_click()
# 
# ###### Parameters:
# - device_id
# - node
# - duration
# - x
# - y
#
#__DOCS
function uio2_click_with_duration() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local duration=`default "$3" 500`
  local x=`default "$4" "$ANCHOR_POINT_CENTER"`
  local y=`default "$5" "$ANCHOR_POINT_MIDDLE"`

  local point_on_surface=`calc_point_on_surface "$node" "$x" "$y"`

  adb -s "$device_id" shell input swipe "$point_on_surface" "$point_on_surface" "$duration"
}
#
#DOCS__
#
# ##### Docs from Google
# clickAndWait(EventCondition<R> condition, long timeout)
# Clicks on this object, and waits for the given condition to become true.
#
# ##### Docs from BashTomato
# ###### uio2_click_and_wait()
# Clicks on provided node on provided device and simply sleeps for some time.
# 
# ###### Parameters:
# - device_id
# - node
# - x
# - y
#
#__DOCS
function uio2_click_and_wait() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local wait_time=`default "$3" 5`
  local x=`default "$4" "$ANCHOR_POINT_CENTER"`
  local y=`default "$5" "$ANCHOR_POINT_MIDDLE"`

  uio2_click "$device_id" "$node" "$x" "$y"
  sleep $wait_time
}
#
#DOCS__
#
# ##### Docs from Google
# drag(Point dest)
# Drags this object to the specified location.
#
# ##### Docs from BashTomato
# ###### uio2_drag()
# Drags and drops from one node to another on provided device.
# Useful as allows to find one node, which wll be moved to another.
# The first one by default will be taken by center middle and dropped to center middle of another.
# 
# ###### Parameters:
# - device_id
# - node_from
# - node_to
# - duration
# - x_from
# - y_from
# - x_to
# - y_to
#
#__DOCS
function uio2_drag() {
  local device_id=`default "$1" ''`
  local node_from=`default "$2" ''`
  local node_to=`default "$3" ''`
  local duration=`default "$4" 500`
  local x_from=`default "$5" "$ANCHOR_POINT_CENTER"`
  local y_from=`default "$6" "$ANCHOR_POINT_MIDDLE"`
  local x_to=`default "$7" "$ANCHOR_POINT_CENTER"`
  local y_to=`default "$8" "$ANCHOR_POINT_MIDDLE"`

  local point_on_surface_from=`calc_point_on_surface "$node_from" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node_to" "$x_to" "$y_to"`

  adb -s "$device_id" shell input draganddrop "$point_on_surface_from" "$point_on_surface_to" "$duration"
}
#
#DOCS__
#
# ##### Docs from Google
# drag(Point dest, int speed)
# Drags this object to the specified location.
#
# ##### Docs from BashTomato
# ###### uio2_drag_with_speed()
# Like uio2_drag(), but takes speed instead of duration
# 
# ###### Parameters:
# - device_id
# - node_from
# - node_to
# - speed
# - x_from
# - y_from
# - x_to
# - y_to
#
#__DOCS
function uio2_drag_with_speed() {
  local device_id=`default "$1" ''`
  local node_from=`default "$2" ''`
  local node_to=`default "$3" ''`
  local speed=`default "$4" 1000`
  local x_from=`default "$5" "$ANCHOR_POINT_CENTER"`
  local y_from=`default "$6" "$ANCHOR_POINT_MIDDLE"`
  local x_to=`default "$7" "$ANCHOR_POINT_CENTER"`
  local y_to=`default "$8" "$ANCHOR_POINT_MIDDLE"`

  local point_on_surface_from=`calc_point_on_surface "$node_from" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node_to" "$x_to" "$y_to"`

  local duration=`calc_duration_from_distance_speed "$speed" "$point_on_surface_from" "$point_on_surface_to"`

  adb -s "$device_id" shell input draganddrop "$point_on_surface_from" "$point_on_surface_to" "$duration"
}
#
#DOCS__
#
# ##### Docs from Google
# equals(Object object)
#
# ##### Docs from BashTomato
# ###### uio2_equals()
# 
# ###### Parameters:
# - node_a
# - node_b
#
#__DOCS
function uio2_equals() {
  local node_a="$1"
  local node_b="$2"

  if [ "$node_a" == "$node_b" ]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}
# #SKIP Probably does no make what should do
#
# findObject(BySelector selector)
# Searches all elements under this object and returns the first object to match the criteria, or null if no matching objects are found.
function uio2_find_object() {
  local xml="$1"
  local filter="$2"
  local index=`default "$3" 1`

  local nodes=`uio2_find_objects "$xml" "$filter"`

  local node=`echo "$nodes" | sed -n "${index}p" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
  val_or_null "$node"
}
#
# findObjects(BySelector selector)
# Searches all elements under this object and returns all objects that match the criteria.
function uio2_find_objects() {
  local xml="$1"
  local filter="$2"

  local nodes=`echo "$xml" | grep -oE '<.+?>' | awk 'BEGIN{depth=0} { if (substr($0, length($0) - 1, 1) == "/") { printf("NR%d DEPTH%d %s\n", NR, depth, $0); } else if (substr($0, 2, 1) != "/") { printf("NR%d DEPTH%d %s\n", NR, depth, $0); depth++; } else { depth--; printf("NR%d DEPTH%d %s\n", NR, depth, $0); } }' | grep -oE "NR[0-9]{1,4} DEPTH[0-9]{1,4} <.+?$filter.+?>"`
  val_or_null "$nodes"
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
# getApplicationPackage()
# Returns the package name of the app that this object belongs to.
function uio2_get_application_package() {
  local device_id=`default "$1" ''`

  local package_name=`adb -s "$device_id" shell dumpsys window windows | grep "mCurrentFocus" | grep -oE '\{(.+?)\}' | tr '}' ' ' | cut -d ' ' -f3 | cut -d '/' -f1`
  val_or_null "$package_name"
}
# #SKIP Not sure if will work for all devices
#
# getChildCount()
# Returns the number of child elements directly under this object.
function uio2_get_children_count() {
  local xml="$1"
  local node="$2"

  echo `uio2_get_children "$xml" "$node" | wc -l`
}
#
# getChildren()
# Returns a collection of the child elements directly under this object.
function uio2_get_children() {
  local xml="$1"
  local node="$2"

  xml=`uio2_find_objects "$xml"`
  local nodes_amount=`echo "$xml" | wc -l`
  local node_nr=`echo $node | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo $node | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local child_node_depth=$((node_depth + 1))
  xml=`echo "$xml" | sed -n "$((node_nr + 1)),${nodes_amount}p"`
  xml=`echo "$xml" | grep -oE 'NR[0-9]{1,4} DEPTH[0-9]{1,4} <[^\/].+?>'`

  result=''
  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -eq $child_node_depth ]
    then
      if [ -z "$result" ]
      then
        result="$node"
      else
        result="
$result"
      fi
    fi

    if [ $next_node_depth -lt $child_node_depth ]; then break; fi
  done <<<"$xml"

  val_or_null "$result"
}
#
# getClassName()
# Returns the class name of the underlying View represented by this object.
function uio2_get_class_name() {
  local node="$1"

  echo `get_prop "$node" 'class'`
}
#
# getContentDescription()
# Returns the content description for this object.
function uio2_get_content_description() {
  local node="$1"

  echo `get_prop "$node" 'content-desc'`
}
#
# getParent()
# Returns this object's parent, or null if it has no parent.
function uio2_get_parent() {
  local xml="$1"
  local node="$2"

  xml=`uio2_find_objects "$xml"`
  local node_nr=`echo "$node" | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local parent_node_depth=$((node_depth - 1))
  xml=`echo "$xml" | sed -n "1,${node_nr}p"`
  xml=`echo "$xml" | sed -n '1!G;h;$p'`

  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -eq $parent_node_depth ]
    then
      val_or_null "$node"
      break
    fi
  done <<<"$xml"
}
#
# getResourceName()
# Returns the fully qualified resource name for this object's id.
function uio2_get_resource_id() {
  local node="$1"

  echo `get_prop "$node" 'resource-id'`
}
#
# getText()
# Returns the text value for this object.
function uio2_get_text() {
  local node="$1"

  echo `get_prop "$node" 'text'`
}
#
# getVisibleBounds()
# Returns the visible bounds of this object in screen coordinates.
function uio2_get_bounds() {
  local node="$1"
  local which="$2"

  local bounds=`get_prop "$node" 'bounds'`
  bounds=`echo "$bounds" | grep -oE '[0-9]+'`
  local left=`echo "$bounds" | sed -n '1p'`
  local top=`echo "$bounds" | sed -n '2p'`
  local right=`echo "$bounds" | sed -n '3p'`
  local bottom=`echo "$bounds" | sed -n '4p'`

  case $which in
    left) echo $left ;;
    top) echo $top ;;
    right) echo $right ;;
    bottom) echo $bottom ;;
    *) echo "left=$left,top=$top,right=$right,bottom=$bottom" ;;
  esac
}
# getVisibleCenter()
# Returns a point in the center of the visible bounds of this object.
function uio2_get_visible_center() {
  local node="$1"

  calc_point_on_surface "$node"
}
#
# hasObject(BySelector selector)
# Returns whether there is a match for the given criteria under this object.
function uio2_has_object() {
  local xml="$1"
  local node="$2"
  local filter="$3"

  xml=`uio2_find_objects "$xml"`
  local nodes_amount=`echo "$xml" | wc -l`
  local node_nr=`echo $node | grep -oE 'NR[0-9]{1,4}' | grep -oE '[0-9]+'`
  local node_depth=`echo $node | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]+'`
  local child_node_depth=$((node_depth + 1))
  xml=`echo "$xml" | sed -n "$((node_nr + 1)),${nodes_amount}p"`
  xml=`echo "$xml" | grep -oE 'NR[0-9]{1,4} DEPTH[0-9]{1,4} <[^\/].+?>'`
  local res=''

  while read -r node
  do
    local next_node_depth=`echo "$node" | grep -oE 'DEPTH[0-9]{1,4}' | grep -oE '[0-9]{1,4}'`

    if [ $next_node_depth -ge $child_node_depth ]
    then
      res="$res
      $node"
    fi

    if [ $next_node_depth -lt $child_node_depth ]; then break; fi
  done <<<"$xml"

  res=`echo "$res" | grep "$filter"`
  # echo $res

  if [ -n "$res" ]
  then
    echo "$TRUE"
  else
    echo "$FALSE"
  fi
}
#
# hashCode()
# #SKIP Not sure if it may be helpful at all
#
# isCheckable()
# Returns whether this object is checkable.
function uio2_is_checkable() {
  local node="$1"

  echo `get_prop "$node" 'checkable'`
}
#
# isChecked()
# Returns whether this object is checked.
function uio2_is_checked() {
  local node="$1"

  echo `get_prop "$node" 'checked'`
}
#
# isClickable()
# Returns whether this object is clickable.
function uio2_is_clickable() {
  local node="$1"

  echo `get_prop "$node" '[^-]clickable'`
}
#
# isEnabled()
# Returns whether this object is enabled.
function uio2_is_enabled() {
  local node="$1"

  echo `get_prop "$node" 'enabled'`
}
#
# isFocusable()
# Returns whether this object is focusable.
function uio2_is_focusable() {
  local node="$1"

  echo `get_prop "$node" 'focusable'`
}
#
# isFocused()
# Returns whether this object is focused.
function uio2_is_focused() {
  local node="$1"

  echo `get_prop "$node" 'focused'`
}
#
# isLongClickable()
# Returns whether this object is long clickable.
function uio2_is_long_clickable() {
  local node="$1"

  echo `get_prop "$node" 'long-clickable'`
}
#
# isScrollable()
# Returns whether this object is scrollable.
function uio2_is_scrollable() {
  local node="$1"

  echo `get_prop "$node" 'scrollable'`
}
#
# isSelected()
# Returns whether this object is selected.
function uio2_is_selected() {
  local node="$1"

  echo `get_prop "$node" 'selected'`
}
#
# longClick()
# Performs a long click on this object.
function uio2_long_click() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local x=`default "$3" "$ANCHOR_POINT_CENTER"`
  local y=`default "$4" "$ANCHOR_POINT_MIDDLE"`

  uio2_click_with_duration "$device_id" "$node" "$x" "$y" 500
} 
#
# pinchClose(float percent)
# Performs a pinch close gesture on this object.
function uio2_pinch_close() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local percent=`default "$3" '50%'`
  local duration=`default "$4" 500`

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
function uio2_pinch_open() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local percent=`default "$3" '50%'`
  local duration=`default "$4" 500`

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
function uio2_set_text() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local content=`default "$3" ''`
  content=`echo "$content" | sed -E 's/(.)/_BTSEP_\1/g' | sed -E 's/_BTSEP_/\\\\/g'`

  uio2_click "$device_id" "$node"

  adb -s "$device_id" shell input text "$content"
}
# #TODO this is not able to type everything. Need huge improvement.
#
# swipe(Direction direction, float percent, int speed)
# Performs a swipe gesture on this object.
function uio2_swipe_with_speed() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local direction=`default "$3" "$DIRECTION_DOWN"`
  local percent=`default "$4" '50%'`
  local speed=`default "$5" 1000`

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
      x_from="$start"
      x_to="$end"
      ;;
    $DIRECTION_RIGHT)
      x_from="$end"
      x_to="$start"
      ;;
    $DIRECTION_UP)
      y_from="$start"
      y_to="$end"
      ;;
  esac

  local point_on_surface_from=`calc_point_on_surface "$node" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$x_to" "$y_to"`

  local duration=`calc_duration_from_distance_speed "$speed" "$point_on_surface_from" "$point_on_surface_to"`

  adb -s "$device_id" shell input swipe $point_on_surface_from $point_on_surface_to $duration
}
#
# swipe(Direction direction, float percent)
# Performs a swipe gesture on this object.
function uio2_swipe() {
  local device_id=`default "$1" ''`
  local node=`default "$2" ''`
  local direction=`default "$3" "$DIRECTION_DOWN"`
  local percent=`default "$4" '50%'`
  local duration=`default "$5" 500`

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
      x_from="$start"
      x_to="$end"
      ;;
    $DIRECTION_RIGHT)
      x_from="$end"
      x_to="$start"
      ;;
    $DIRECTION_UP)
      y_from="$start"
      y_to="$end"
      ;;
  esac

  local point_on_surface_from=`calc_point_on_surface "$node" "$x_from" "$y_from"`
  local point_on_surface_to=`calc_point_on_surface "$node" "$x_to" "$y_to"`

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
