#!/bin/bash

function utils_assert_null() { # exits with `success_message` and status 0 if `value` is `$NULL` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

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

function utils_assert_not_null() { # exits with `success_message` and status 0 if `value` is NOT `$NULL` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

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

function utils_assert_true() { # exits with `success_message` and status 0 if `value` is `$TRUE` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

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

function utils_assert_false() { # exits with `success_message` and status 0 if `value` is `$FALSE` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

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

function utils_assert_string_is_empty() { # exits with `success_message` and status 0 if `value` expands to '' else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

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

function utils_assert_strings_are_equal() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to same values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_strings_are_different() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_less_than_second() { # exits with `success_message` and status 0 if `value_a` is less than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_less_or_equal_than_second() { # exits with `success_message` and status 0 if `value_a` is less or equal than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_equals_second() { # exits with `success_message` and status 0 if `value_a` and `value_b` are equal else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_greater_or_equal_than_second() { # exits with `success_message` and status 0 if `value_a` is greater or equal than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_greater_than_second() { # exits with `success_message` and status 0 if `value_a` is greater than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_assert_numbers_first_is_not_equal_to_second() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

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

function utils_devices() { # returns all devices ids list or single device id if `device_index` passed
  local device_index=`default "$1" ''` # line number, which will be read as `device_id` from `adb devices` incremented by 1

  if [ -z "$device_index" ]
  then
    device_id=`adb devices`
  else
    device_id=`adb devices | sed -n "$((device_index + 1))p" | cut -f1`
  fi

  val_or_null "$device_id"
}

function utils_is_device_connected() { # checks if device with `device_id` is reachable from ADB, returns `$TRUE`/ `$FALSE`
  local device_id="$1" # device id taken from `adb devices`

  local res=`adb devices | grep "$device_id"`

  if [ -z "$device_id" ] || [ -z "$res" ]; then echo "$FALSE"; else echo "$TRUE"; fi
}

function utils_restart_server() { # restarts ADB server
  adb kill-server && adb start-server
}

function utils_reboot() { # reboots device by its `device_id`
  local device_id="$1" # device id taken from `adb devices`

  adb -s "$device_id" reboot
}

function utils_set_display() { # sets resolution and density by provoding named params of deivce by `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local resolution=`echo "$@" | grep -oE '--resolution=[0-9]{1,4}x[0-9]{1,4}' | cut -d '=' -f2` # new screen resolution matching regexp [0-9]{1,4}x[0-9]{1,4}, non positional parameter
  local density=`echo "$@" | grep -oE '--density=[0-9]{1,4}' | cut -d '=' -f2` # new screen resolution matching regexp [0-9]{1,4}, non positional parameter
  resolution=`default "$resolution" 'reset'`
  density=`default "$density" 'reset'`

  adb -s "$device_id" shell wm size "$resolution"
  adb -s "$device_id" shell wm density "$density"
}

function utils_install_and_start() { # starts `package_name` on device with `device_id`, allows to install apk and force reinstall
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory
  local apkpath=`default "$3" ''` # self explanatory
  local force=`default "$4" ''` # if not bash-like-empty then it will force to reinstall

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

function utils_stop_app() { # stops app with `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  adb -s "$device_id" shell am force-stop "$package_name"
}

function utils_uninstall() { # uninstalls app with `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  adb -s "$device_id" uninstall "$package_name"
}

function utils_clear_data() { # clears app data of `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  adb -s "$device_id" shell pm clear "$package_name"
}

function utils_record() { # records video from device with `device_id`, for now this probably locks device blockick possibility to execute other functions
  local device_id="$1" # device id taken from `adb devices`
  local filename="$2"

  adb -s "$device_id" shell screenrecord "/sdcard/${filename}.mp4"
}

function utils_wait_to_see() { # search for element on device's screen by `device_id`, dumps hierarchy until element appeared or attempts exhaust
  local device_id="$1" # device id taken from `adb devices`
  local filter="$2" #  # simple bash-grep-like expression passed with -oE options
  local index=`default "$3" 1` # instance number counting from 1
  local attempts=`default "$4" 30` # dumps to execute before return `$NULL`

  rm temporary_xml_dump.xml > /dev/null

  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$o" != "$NULL" ]
    then
      echo "$o"
      break
    fi

    attempts=$((attempts - 1))
  done
  
  echo "$NULL"
}
# #TODO make waits to be able to be more generic

function utils_search_node() { # searches for element in advanced way, it scrolls horizontally or vertically through given element and searches for other element inside, moved by configurable steps, repeats `cycles` times
  local device_id="$1" # device id taken from `adb devices`
  local object_to_search_in=`default "$2" ''` # XML-string-like element (container) to saerch in
  local filter="$3" #  # simple bash-grep-like expression passed with -oE options
  local index=`default "$4" 1` # instance number counting from 1
  local swiping_direction=`default "$5" "$DIRECTION_VERTICAL"` # self explanatory
  local cycles=`default "$6" 1` # number of repeats (scroll back and forth) when scroll limit reached
  local swipe_length=`default "$7" '50%'` # self explanatory
  local swipes_count_left=`default "$8" 50` # general number of swipes before completely stop (returning `$NULL`), global limit unrelated with cycles

  local previous_xml_hash=`echo '' | md5`
  local direction_modifier=1

  rm temporary_xml_dump.xml > /dev/null

  while [ "$swipes_count_left" -gt 0 ] && [ "$cycles" -gt 0 ] 
  do
    previous_xml_hash=`cat temporary_xml_dump.xml | md5`
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$o" != "$NULL" ]
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
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_LEFT"
          ;;
        "${DIRECTION_HORIZONTAL}_-1")
          uio2_swipe "$device_id" "$object_to_search_in" "$DIRECTION_RIGHT"
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

    swipes_count_left=$((swipes_count_left - 1))
  done

  echo "$NULL"
}

function utils_wait_to_gone() { # search for element on device's screen by `device_id`, dumps hierarchy until element gone or attempts exhaust
  local device_id="$1" # device id taken from `adb devices`
  local filter="$2" #  # simple bash-grep-like expression passed with -oE options
  local index=`default "$3" 1` # instance number counting from 1
  local attempts=`default "$4" 30` # dumps to execute before return `$NULL`

  rm temporary_xml_dump.xml > /dev/null

  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local o=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$o" == "$NULL" ]
    then
      echo "$NULL"
      break
    fi

    attempts=$((attempts - 1))
  done
  
  echo "$o"
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

function utils_get_device_orientation() { # gets device's orientation as number 0 to 3
  local device_id="$1" # device id taken from `adb devices`

  adb -s $device_id shell settings get system user_rotation
}
