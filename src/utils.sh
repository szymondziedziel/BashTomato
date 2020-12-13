#!/bin/bash

function utils_assert_null() {
  local value="$1"
  local success_message="$2"
  local error_message="$3"

  local function_name="${FUNCNAME[0]}"
  value=`echo "$value" | tr '[:upper:]' '[:lower:]'`

  if [ "$value" == "$NULL" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value]"
    fi
    exit 1
  fi
}

function utils_assert_not_null() {
  local value="$1"
  local success_message="$2"
  local error_message="$3"

  local function_name="${FUNCNAME[0]}"
  value=`echo "$value" | tr '[:upper:]' '[:lower:]'`

  if [ "$value" != "$NULL" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value]"
    fi
    exit 1
  fi
}

function utils_assert_true() {
  local value="$1"
  local success_message="$2"
  local error_message="$3"

  local function_name="${FUNCNAME[0]}"

  if [ "$value" == "$TRUE" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value]"
    fi
    exit 1
  fi
}

function utils_assert_false() {
  local value="$1"
  local success_message="$2"
  local error_message="$3"

  local function_name="${FUNCNAME[0]}"

  if [ "$value" == "$FALSE" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value]"
    fi
    exit 1
  fi
}

function utils_assert_string_is_empty() {
  local value="$1"
  local success_message="$2"
  local error_message="$3"

  local function_name="${FUNCNAME[0]}"

  if [ -z "$value" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value]"
    fi
    exit 1
  fi
}

function utils_assert_strings_are_equal() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" == "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_strings_are_different() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" != "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_less_than_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -lt "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_less_or_equal_than_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -le "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_equals_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -eq "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_greater_or_equal_than_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -ge "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_greater_than_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -gt "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}

function utils_assert_numbers_first_is_not_equal_to_second() {
  local value_a="$1"
  local value_b="$2"
  local success_message="$3"
  local error_message="$4"

  local function_name="${FUNCNAME[0]}"

  if [ "$value_a" -ne "$value_b" ]
  then
    success_message=`echo "$success_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$success_message" ]
    then
      echo "$success_message"
    else
      echo "$function_name passed for [$value_a] and [$value_b]"
    fi
  else
    error_message=`echo "$error_message" | sed "s/__FUNCTION_NAME__/$function_name/g" | sed "s/__VALUE__/$value/g"`
    if [ -n "$error_message" ]
    then
      echo "$error_message"
    else
      echo "$function_name failed for [$value_a] and [$value_b]"
    fi
    exit 1
  fi
}
#
# devices
function utils_devices() {
  local device_index="$1"

  if [ -z "$device_index" ]
  then
    device_id=`adb devices`
  else
    device_id=`adb devices | sed -n "$((device_index + 1))p" | cut -f1`
  fi

  val_or_null "$device_id"
}
#
# is_device_connected
function utils_is_device_connected() {
  local device_id="$1"

  local res=`adb devices | grep "$device_id"`

  if [ -z "$device_id" ] || [ -z "$res" ]; then echo "$FALSE"; else echo "$TRUE"; fi
}
#
# restart_server
function utils_restart_server() {
  adb kill-server && adb start-server
}
#
# reboot
function utils_reboot() {
  local device_id="$1"

  adb -s "$device_id" reboot
}
# display
function utils_set_display() {
  local device_id="$1"
  local resolution=`echo "$@" | grep -oE '--resolution=[0-9]{1,4}x[0-9]{1,4}' | cut -d '=' -f2`
  local density=`echo "$@" | grep -oE '--density=[0-9]{1,4}' | cut -d '=' -f2`
  resolution=`default "$resolution" 'reset'`
  density=`default "$density" 'reset'`

  adb -s "$device_id" shell wm size "$resolution"
  adb -s "$device_id" shell wm density "$density"
}
#
# install & start
function utils_install_and_start() {
  local device_id="$1"
  local package_name="$2"
  local apkpath="$3"
  local force=`default "$4" ''`

  local is_installed=`adb -s "$device_id" shell pm list packages | cut -d: -f2 | grep "$package_name"`
  if [ -z "$is_installed" ] || [ -n "$force" ]
  then
    if [ -n "$apkpath" ]
    then
      adb -s "$device_id" install -t "$apkpath"
    fi
  fi

  adb -s "$device_id" shell monkey -p "$package_name" -c android.intent.category.LAUNCHER 1
}
#
# kill_app
function utils_stop_app() {
  local device_id="$1"
  local package_name="$2"

  adb -s "$device_id" shell am force-stop "$package_name"
}
# 
# uninstall_app
function utils_uninstall() {
  local device_id="$1"
  local package_name="$2"

  adb -s "$device_id" uninstall "$package_name"
}
#
# clear_data
function utils_clear_data() {
  local device_id="$1"
  local package_name="$2"

  adb -s "$device_id" shell pm clear "$package_name"
}
# 
# record
function utils_record() {
  local device_id="$1"
  local filename="$2"

  adb -s "$device_id" shell screenrecord "/sdcard/${filename}.mp4"
}
#
# wait_to_see
function utils_wait_to_see() {
  local device_id="$1"
  local filter="$2"
  local index=`default "$3" 1`
  local attempts=`default "$4" 30`

  rm temporary_xml_dump.xml

  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ -n "$o" ]
    then
      echo "$o"
      break
    fi

    attempts=$((attempts - 1))
  done
}
# #TODO make waits to be able to be more generic
#
function utils_search_node() {
  local device_id="$1"
  local object_to_search_in=`default "$2" ''`
  local filter="$3"
  local index=`default "$4" 1`
  local swiping_direction=`default "$5" "$DIRECTION_VERTICAL"`
  local cycles=`default "$6" 1`
  local swipe_length=`default $7 '50%'`
  local swipes_left=`default "$8" 50`

  local previous_xml_hash=`echo '' | md5`
  local direction_modifier=1

  rm temporary_xml_dump.xml

  while [ "$swipes_left" -gt 0 ] && [ "$cycles" -gt 0 ] 
  do
    previous_xml_hash=`cat temporary_xml_dump.xml | md5`
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ -n "$o" ]
    then
      echo "$o"
      break
    else
      case_value="${swiping_direction}_${direction_modifier}"
      case $case_value in
        "${DIRECTION_VERTICAL}_1")
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_DOWN"
          ;;
        "${DIRECTION_VERTICAL}_-1")
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_UP"
          ;;
        "${DIRECTION_HORIZONTAL}_1")
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_RIGHT"
          ;;
        "${DIRECTION_HORIZONTAL}_-1")
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_LEFT"
          ;;
        *)
          echo "Wrong direction. Do not know how to search."
          exit
          ;;
      esac
    fi

    uid_dump_window_hierarchy "$device_id" > /dev/null
    xml=`cat temporary_xml_dump.xml`
    current_xml_hash=`cat temporary_xml_dump.xml | md5`
    if [ "$current_xml_hash" == "$previous_xml_hash" ]
    then
      cycles=$((cycles - 1))
      direction_modifier=$((direction_modifier * -1))
    fi

    swipes_left=$((swipes_left - 1))
  done
}
#
# wait_to_gone
function utils_wait_to_gone() {
  local device_id="$1"
  local filter="$2"
  local index=`default "$3" 1`
  local attempts=`default "$4" 30`

  rm temporary_xml_dump.xml

  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ -z "$o" ]
    then
      echo "$o"
      break
    fi

    attempts=$((attempts - 1))
  done
}
# TODO make waits to be able to be more generic

# function utils_wait_to() {
#   local function_name="$1"
#   local attempts=`default "$2" 30`
#   local error=`default "$3" 'bashtomato_default_error'`
#   shift 2
#   local rest="$@"
#   
#   while [ "$attempts" -gt 0 ]
#   do
#     result=`"$function_name" "$rest"`
# 
#     if [ -n "$result" ]
#     then
#       echo "$result"
#       break
#     fi
# 
#     attempts=$((attempts - 1))
#   done
# }

function utils_get_device_orientation() {
  local device_id="$1"

  adb -s $device_id shell settings get system user_rotation
}
