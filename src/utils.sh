#!/bin/bash

function utils_assert_null() { # exits with `success_message` and status 0 if `value` is `$NULL` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value" == "$NULL" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_not_null() { # exits with `success_message` and status 0 if `value` is NOT `$NULL` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value" != "$NULL" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_true() { # exits with `success_message` and status 0 if `value` is `$TRUE` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value" == "$TRUE" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_false() { # exits with `success_message` and status 0 if `value` is `$FALSE` else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value" == "$FALSE" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_string_is_empty() { # exits with `success_message` and status 0 if `value` expands to '' else prints `error_message` with status 1
  local value="$1" # value to operate on
  local success_message=`default "$2" ''` # self explanatory
  local error_message=`default "$3" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ -z "$value" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value=<${value}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_strings_are_equal() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to same values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" == "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_strings_are_different() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" != "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_less_than_second() { # exits with `success_message` and status 0 if `value_a` is less than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -lt "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_less_or_equal_than_second() { # exits with `success_message` and status 0 if `value_a` is less or equal than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -le "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_equals_second() { # exits with `success_message` and status 0 if `value_a` and `value_b` are equal else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -eq "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_greater_or_equal_than_second() { # exits with `success_message` and status 0 if `value_a` is greater or equal than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -ge "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_greater_than_second() { # exits with `success_message` and status 0 if `value_a` is greater than `value_b` else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -gt "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_assert_numbers_first_is_not_equal_to_second() { # exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
  local value_a="$1" # value to operate on
  local value_b="$2" # value to operate on
  local success_message=`default "$3" ''` # self explanatory
  local error_message=`default "$4" ''` # self explanatory

  logs_append "`logs_time` | UTILS_ASSERTION | INPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}> error_message=<${error_message}>"

  if [ "$value_a" -ne "$value_b" ]
  then
    if [ "$success_message" == "$NULL" ]
    then
      success_message="${FUNCNAME[0]} passed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_PASSED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> success_message=<${success_message}>"
  else
    if [ "$error_message" == "$NULL" ]
    then
      error_message="${FUNCNAME[0]} failed for [$value_a] and [$value_b]"
    fi
    logs_append "`logs_time` | UTILS_ASSERTION_FAILED | OUTPUT | function=<${FUNCNAME[0]}> value_a=<${value_a}> value_b=<${value_b}> error_message=<${error_message}>"
    logs_read
    exit 1
  fi
}

function utils_devices() { # returns all devices ids list or single device id if `device_index` passed
  local device_index=`default "$1" ''` # line number, which will be read as `device_id` from `adb devices` incremented by 1

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_index=<${device_index}>"
  validators_unsigned_integer "$device_index" "$TRUE" > /dev/null

  if [ -z "$device_index" ]
  then
    device_id=`adb devices`
  else
    device_id=`adb devices | sed -n "$((device_index + 1))p" | cut -f1`
  fi

  device_id=`val_or_null "$device_id"`

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"

  echo "$device_id"
}

function utils_is_device_connected() { # checks if device with `device_id` is reachable from ADB, returns `$TRUE`/ `$FALSE`
  local device_id="$1" # device id taken from `adb devices`

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local is_device_connected=`adb devices | grep "$device_id"`

  if [ -z "$device_id" ] || [ -z "$is_device_connected" ]
  then
    is_device_connected="$FALSE"
  else
    is_device_connected="$TRUE"
  fi

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> is_device_connected=<${is_device_connected}>"

  echo "$is_device_connected"
}

function utils_restart_server() { # restarts ADB server
  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}>"
  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb kill-server && adb start-server
}

function utils_reboot() { # reboots device by its `device_id`
  local device_id="$1" # device id taken from `adb devices`

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" reboot
}

function utils_set_display() { # sets resolution and density by provoding named params of deivce by `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local resolution=`echo "$@" | grep -oE '--resolution=[0-9]{1,4}x[0-9]{1,4}' | cut -d '=' -f2` # new screen resolution matching regexp [0-9]{1,4}x[0-9]{1,4}, non positional parameter
  local density=`echo "$@" | grep -oE '--density=[0-9]{1,4}' | cut -d '=' -f2` # new screen resolution matching regexp [0-9]{1,4}, non positional parameter

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> resolution=<${resolution}> density=<${density}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  resolution=`default "$resolution" 'reset'`
  density=`default "$density" 'reset'`

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> resolution=<${resolution}> density=<${density}>"

  adb -s "$device_id" shell wm size "$resolution"
  adb -s "$device_id" shell wm density "$density"
}

function utils_install_and_start() { # starts `package_name` on device with `device_id`, allows to install apk and force reinstall
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory
  local apkpath=`default "$3" ''` # self explanatory
  local force=`default "$4" ''` # if not bash-like-empty then it will force to reinstall

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> package_name=<${package_name}> apkpath=<${apkpath}> force=<${force}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local is_installed=`adb -s "$device_id" shell pm list packages | cut -d: -f2 | grep "$package_name"`
  if [ -z "$is_installed" ] || [ -n "$force" ]
  then
    if [ -n "$apkpath" ]
    then
      logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> installing"

      adb -s "$device_id" install -t "$apkpath"
    else
      logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> skipping"
    fi
  fi

  adb -s "$device_id" shell monkey -p "$package_name" -c android.intent.category.LAUNCHER 1
}

function utils_stop_app() { # stops app with `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> package_name=<${package_name}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell am force-stop "$package_name"
}

function utils_uninstall() { # uninstalls app with `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> package_name=<${package_name}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" uninstall "$package_name"
}

function utils_clear_data() { # clears app data of `package_name` on device with `device_id`
  local device_id="$1" # device id taken from `adb devices`
  local package_name="$2" # self explanatory

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> package_name=<${package_name}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  
  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell pm clear "$package_name"
}

function utils_record() { # records video from device with `device_id`, for now this probably locks device blockick possibility to execute other functions
  local device_id="$1" # device id taken from `adb devices`
  local filepath="$2" # self explanatory

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> filepath=<${filepath}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_filepath_with_extension "$filepath" 'mp4' "$TRUE" > /dev/null

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell screenrecord "/sdcard/${filename}.mp4"
}

function utils_wait_to_see() { # search for element on device's screen by `device_id`, dumps hierarchy until element appeared or attempts exhaust
  local device_id="$1" # device id taken from `adb devices`
  local filter="$2" #  # simple bash-grep-like expression passed with -oE options
  local index=`default "$3" 1` # instance number counting from 1
  local attempts=`default "$4" 30` # dumps to execute before return `$NULL`

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> filter=<${filter}> index=<${index}> attempts=<${attempts}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  # validators_filter "$filter" "$TRUE" > /dev/null
  validators_unsigned_integer "$index" "$TRUE" > /dev/null
  validators_unsigned_integer "$attempts" "$TRUE" > /dev/null

  rm temporary_xml_dump.xml > /dev/null

  local node='UNDEFINED'
  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    node=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$node" != "$NULL" ]
    then
      break
    fi

    logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> attempts=<${attempts}>"

    attempts=$((attempts - 1))
  done

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  
  node=`val_or_null "$node"`
  echo "$node"
}
# #TODO make waits to be able to be more generic

function utils_search_node() { # searches for element in advanced way, it scrolls horizontally or vertically through given element and searches for other element inside, moved by configurable steps, repeats `cycles` times
  local device_id="$1" # device id taken from `adb devices`
  local object_to_search_in="$2" # XML-string-like element (container) to search in
  local filter="$3" # simple bash-grep-like expression passed with -oE options
  local index=`default "$4" 1` # instance number counting from 1
  local swiping_direction=`default "$5" "$DIRECTION_VERTICAL"` # self explanatory
  local cycles=`default "$6" 1` # number of repeats (scroll back and forth) when scroll limit reached
  local swipe_length=`default "$7" '50%'` # self explanatory
  local swipes_count_left=`default "$8" 50` # general number of swipes before completely stop (returning `$NULL`), global limit unrelated with cycles

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> object_to_search_in=<${object_to_search_in}> filter=<${filter}> index=<${index}> swiping_direction=<${swiping_direction}> cycles=<${cycles}> swipe_length=<${swipe_length}> swipes_count_left=<${swipes_count_left}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_node "$object_to_search_in" "$TRUE" > /dev/null
  # validators_filter "$filter" "$TRUE" > /dev/null
  validators_unsigned_integer "$index" "$TRUE" > /dev/null
  validators_direction "$swiping_direction" "$TRUE" > /dev/null
  validators_unsigned_integer "$cycles" "$TRUE" > /dev/null
  validators_unsigned_integer "$swipe_length" "$TRUE" > /dev/null
  validators_unsigned_integer "$swipes_count_left" "$TRUE" > /dev/null

  local previous_xml_hash=`echo '' | md5`
  local direction_modifier=1

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> previous_xml_hash=<${previous_xml_hash}> direction_modifier=<${direction_modifier}>"

  rm temporary_xml_dump.xml > /dev/null

  while [ "$swipes_count_left" -gt 0 ] && [ "$cycles" -gt 0 ] 
  do
    previous_xml_hash=`cat temporary_xml_dump.xml | md5`
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local node=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$node" != "$NULL" ]
    then
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

      logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> previous_xml_hash=<${previous_xml_hash}> direction_modifier=<${direction_modifier}>"

      cycles=$((cycles - 1))
      direction_modifier=$((direction_modifier * -1))
    fi

    swipes_count_left=$((swipes_count_left - 1))
  done

  echo "$NULL"
}

function utils_wait_to_gone() { # search for element on device's screen by `device_id`, dumps hierarchy until element gone or attempts exhaust
  local device_id="$1" # device id taken from `adb devices`
  local filter="$2" # simple bash-grep-like expression passed with -oE options
  local index=`default "$3" 1` # instance number counting from 1
  local attempts=`default "$4" 30` # dumps to execute before return `$NULL`

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> filter=<${filter}> index=<${index}> attempts=<${attempts}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  # validators_filter "$filter" "$TRUE" > /dev/null
  validators_unsigned_integer "$index" "$TRUE" > /dev/null
  validators_unsigned_integer "$attempts" "$TRUE" > /dev/null

  rm temporary_xml_dump.xml > /dev/null

  while [ "$attempts" -gt 0 ]
  do
    uid_dump_window_hierarchy "$device_id" > /dev/null
    local xml=`cat temporary_xml_dump.xml`
    local node=`uio2_find_object "$xml" "$filter" "$index"`

    if [ "$node" == "$NULL" ]
    then
      break
    fi

    logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> attempts=<${attempts}>"

    attempts=$((attempts - 1))
  done

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}> node=<${node}>"
  
  node=`val_or_null "$node"`
  echo "$node"
}

function utils_get_device_orientation() { # gets device's orientation as number 0 to 3
  local device_id="$1" # device id taken from `adb devices`

  logs_append "`logs_time` | UTILS_ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | UTILS_ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s $device_id shell settings get system user_rotation
}
