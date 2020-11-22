#!/bin/bash

function utils_assert_null() {
  local value="$1"
  if [ -z "$value" ]
  then
    echo "${FUNCNAME[0]} passed for [$value]"
  else
    echo "${FUNCNAME[0]} failed for [$value]"
    exit 1
  fi
}

function utils_assert_not_null() {
  local value="$1"
  if [ -n "$value" ]
  then
    echo "${FUNCNAME[0]} passed for [$value]"
  else
    echo "${FUNCNAME[0]} failed for [$value]"
    exit 1
  fi
}

function utils_assert_true() {
  local value="$1"
  if [ "$value" == 'true' ]
  then
    echo "${FUNCNAME[0]} passed for [$value]"
  else
    echo "${FUNCNAME[0]} failed for [$value]"
    exit 1
  fi
}

function utils_assert_false() {
  local value="$1"
  if [ "$value" == 'false' ]
  then
    echo "${FUNCNAME[0]} passed for [$value]"
  else
    echo "${FUNCNAME[0]} failed for [$value]"
    exit 1
  fi
}

function utils_assert_strings_are_equal() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" == "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_strings_are_different() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" != "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_less_than_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -lt "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_less_or_equal_than_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -le "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_equals_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -eq "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_greater_or_equal_than_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -ge "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_greater_than_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -gt "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}

function utils_assert_numbers_first_is_not_equal_to_second() {
  local value_a="$1"
  local value_b="$2"
  if [ "$value_a" -ne "$value_b" ]
  then
    echo "${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
  else
    echo "${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    exit 1
  fi
}
#
# devices
function utils_devices() {
  local device_index="$1"

  if [ -z "$device_index" ]
  then
    adb devices
  else
    adb devices | sed -n "$((device_index + 1))p" | cut -f1
  fi
}
#
# is_device_connected
function utils_is_device_connected() {
  local device_id="$1"

  local res=`adb devices | grep "$device_id"`

  if [ -z "$device_id" ] || [ -z "$res" ]; then echo false; else echo true; fi
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

  adb shell wm size "$resolution"
  adb shell wm density "$density"
}
#
# install & start
function utils_install_and_start() {
  local device_id="$1"
  local package_name="$2"
  local apkpath="$3"
  local force="$4"

  local is_installed=`adb -s "$device_id" shell pm list packages | cut -d: -f2 | grep "$package_name"`
  if [ -z "$is_installed" ] || [ -n "$force" ]
  then
    adb -s "$device_id" install -t "$apkpath"
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
  local device_id=`default "$1" ''`
  local filter="$2"
  local index=`default "$3" 1`
  local attempts=`default "$3" 30`

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
# wait_to_gone
function utils_wait_to_gone() {
  local device_id=`default "$1" ''`
  local filter="$2"
  local index=`default "$3" 1`
  local attempts=`default "$3" 30`

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
  local device_id=`default $1 ''`

  adb -s $device_id shell settings get system user_rotation
}
