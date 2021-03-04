#!/bin/bash

# Device API start

function uid_click() { # clicks on specified screen point, numbers x, y from top, left edges
  local device_id="$1" # device id taken from `adb devices`
  local x="$2" # distance in pixels from left screen edge
  local y="$3" # distance in pixels from top screen edge

  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> x=<${x}> y=<${y}>"

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input tap "$x" "$y"
}
#
# drag(int startX, int startY, int endX, int endY, int steps)
# Performs a swipe from one coordinate to another coordinate.
function uid_drag() { # drags from point to point, from x, y (pixels) from left, top edges to w, z (pixels) from left, top edges
  local device_id="$1" # device id taken from `adb devices`
  local x_from="$2" # self explanatory
  local y_from="$3" # self explanatory
  local x_to="$4" # self explanatory
  local y_to="$5" # self explanatory
  local duration="$6" # expressed in milliseconds

  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> x_from=<${x_from}> y_from=<${y_from}> x_to=<${x_to}> y_to=<${y_to}> duration=<${duration}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_from" "$TRUE" > /dev/null
  validators_integer_or_percent "$x_to" "$TRUE" > /dev/null
  validators_integer_or_percent "$y_to" "$TRUE" > /dev/null
  validators_milliseconds "$duration" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input draganddrop "$x_from" "$y_from" "$x_to" "$y_to" "$duration"
} 
#
# dumpWindowHierarchy(File dest)
# Dump the current window hierarchy to a File.
# Please use uid_dump_window_hierarchy
#
# dumpWindowHierarchy(OutputStream out)
# Dump the current window hierarchy to an OutputStream.
# Please use uid_dump_window_hierarchy
#
# dumpWindowHierarchy(String fileName)
# This method is deprecated. Use dumpWindowHierarchy(File) or dumpWindowHierarchy(OutputStream) instead.
# Please use uid_dump_window_hierarchy
function uid_dump_window_hierarchy() { # retrieve XML-source of current visible application screen. Unable to get complete XML for password/ pin screen, on-screen keyboard, webview is presented
  local device_id="$1" # device id taken from `adb devices`
  local dump_filepath=`default "$2" 'temporary_xml_dump.xml'` # path where entire dump hierarchy will be stored

  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> dump_filepath=<${dump_filepath}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_filepath_xml "$dump_filepath" "$TRUE" > /dev/null

  local dumppath=`adb -s "$device_id" shell uiautomator dump | cut -d ' ' -f5`
  local dumpfile=`basename "$dumppath"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> dumppath=<${dumppath}>"

  adb -s "$device_id" pull "$dumppath" "./$dump_filepath"
}
#
# findObject(UiSelector selector)
# Returns a UiObject which represents a view that matches the specified selector criteria.
# #SKIP Please use proper function from uiobject2.sh
#
# findObject(BySelector selector)
# Returns the first object to match the selector criteria, or null if no matching objects are found.
# #SKIP Please use proper function from uiobject2.sh
#
# findObjects(BySelector selector)
# Returns all objects that match the selector criteria.
# #SKIP Please use proper function from uiobject2.sh
#
# freezeRotation()
# Disables the sensors and freezes the device rotation at its current rotation state.
function uid_freeze_rotation() { # disables device's sensor
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell settings put system accelerometer_rotation 0
}
#
# getCurrentActivityName()
# This method is deprecated. The results returned should be considered unreliable
function uid_get_current_activity_name() { # dumps current visible activity's name
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local current_activity_name=`adb -s "$device_id" shell dumpsys window windows | grep "mCurrentFocus" | grep -oE '\{(.+?)\}' | tr '}' ' ' | cut -d ' ' -f3 | cut -d '/' -f2`
  current_activity_name=`val_or_null "$current_activity_name"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> current_activity_name=<${current_activity_name}>"

  echo "$current_activity_name"
}
# #SKIP But not sure if it will work for different devices for now
#
# getCurrentPackageName()
# Retrieves the name of the last package to report accessibility events.
# Please use uio2_get_application_package from uiobject2.sh
#
# getDisplayHeight()
# Gets the height of the display, in pixels.
function uid_get_display_height() { # gets screen height in pixels
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local height=`adb -s "$device_id" shell wm size | grep -oE '[0-9]+' | sed -n '2p'`
  height=`val_or_null "$height"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> height=<${height}>"

  echo "$height"
}
#
# getDisplayRotation()
# Returns the current rotation of the display, as defined in Surface
function uid_get_display_rotation() { # gets screen rotation value previously set
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local display_rotation=`adb -s "$device_id" shell settings get system accelerometer_rotation`
  display_rotation=`val_or_null "$display_rotation"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> display_rotation=<${display_rotation}>"

  echo "$display_rotation"
}
#
# getDisplaySizeDp()
# Returns the display size in dp (device-independent pixel) The returned display size is adjusted per screen rotation.
function uid_get_display_size_dp() { # gets screen density
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local display_size_dp=`adb -s "$device_id" shell wm density | grep -oE '[0-9]+'`
  display_size_dp=`val_or_null "$display_size_dp"`

    logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> display_size_dp=<${display_size_dp}>"

  echo "$display_size_dp"
}
#
# getDisplayWidth()
# Gets the width of the display, in pixels.
function uid_get_display_width() { # gets screen width in pixels
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local width=`adb -s "$device_id" shell wm size | grep -oE '[0-9]+' | sed -n '1p'`
  width=`val_or_null "$width"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> width=<${width}>"

  echo "$width"
}
#
# getInstance()
# This method is deprecated. Should use getInstance(Instrumentation) instead. This version hides UiDevice's dependency on having an Instrumentation reference and is prone to misuse.
# This will no be covered as it is deprecated
#
# getInstance(Instrumentation instrumentation)
# Retrieves a singleton instance of UiDevice
# #SKIP Probably not needed for ADB
#
# getLastTraversedText()
# Retrieves the text from the last UI traversal event received.
# #TODO
#
# getLauncherPackageName()
# Retrieves default launcher package name
# #SKIP Please try to use uio2_get_application_package from uiobject2.sh
#
# getProductName()
# Retrieves the product name of the device.
function uid_get_product_name() { # retrieves the product name of the device
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local product_name=`adb -s "$device_id" shell getprop ro.product.name`
  product_name=`val_or_null "$product_name"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> product_name=<${product_name}>"

  echo "$product_name"
}
#
# hasAnyWatcherTriggered()
# Checks if any registered UiWatcher have triggered.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# hasObject(BySelector selector)
# Returns whether there is a match for the given selector criteria.
# #SKIP Please use proper function from uiobject2.sh
#
# hasWatcherTriggered(String watcherName)
# Checks if a specific registered UiWatcher has triggered.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# isNaturalOrientation()
# Check if the device is in its natural orientation.
# #SKIP For different psyhical devices when autorotation was enabled I was always getting 0, but device wasn't in natural orientation
#
# isScreenOn()
# Checks the power manager if the screen is ON.
function uid_is_screen_on() { # checks if screen in turned on
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  local is_screen_on=`adb -s "$device_id" shell dumpsys power | grep 'Display Power: state=ON'`
  is_screen_on=`val_or_null "$is_screen_on"`

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}> is_screen_on=<${is_screen_on}>"

  echo "$is_screen_on"
}
# #SKIP Not sure if it will work on all devices
#
# openNotification()
# Opens the notification shade.
function uid_open_notification() { # drags menu from top device bar
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell cmd statusbar expand-notifications
}
#
# openQuickSettings()
# Opens the Quick Settings shade.
# #TODO
#
# performActionAndWait(Runnable action, EventCondition<R> condition, long timeout)
# Performs the provided action and waits for the condition to be met.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# pressBack()
# Simulates a short press on the BACK button.
# function uid_press_back() {
#   device_id="$1"
#
#   adb -s "$device_id" shell input keyevent "$KEYCODE_BACK"
# }
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDPadCenter()
# Simulates a short press on the CENTER button.
# function uid_press_d_pad_center() {
#   device_id="$1"
#
#   adb -s "$device_id" shell input keyevent "$KEYCODE_DPAD_CENTER"
# }
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDPadDown()
# Simulates a short press on the DOWN button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDPadLeft()
# Simulates a short press on the LEFT button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDPadRight()
# Simulates a short press on the RIGHT button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDPadUp()
# Simulates a short press on the UP button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressDelete()
# Simulates a short press on the DELETE key.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressEnter()
# Simulates a short press on the ENTER key.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressHome()
# Simulates a short press on the HOME button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressKeyCode(int keyCode)
# Simulates a short press using a key code.
function uid_press_key_code() { # sends key to the device to perform
  local device_id="$1" # device id taken from `adb devices`
  local keycode="$2" # keycode number, preferred way is to use named constants from within `keycodes.sh` or keycodes file fallback for bash 3.2
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> keycode=<${keycode}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  # validators_keycode "$keycode" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input keyevent "$keycode"
}
#
# pressKeyCode(int keyCode, int metaState)
# Simulates a short press using a key code.
# #SKIP Please use uid_press_key_code
#
# pressMenu()
# Simulates a short press on the MENU button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressRecentApps()
# Simulates a short press on the Recent Apps button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# pressSearch()
# Simulates a short press on the SEARCH button.
# #SKIP There is no sense to cover all of this functions see uid_press_back and uid_press_d_pad_center as we have named keycodes
#
# registerWatcher(String name, UiWatcher watcher)
# Registers a UiWatcher to run automatically when the testing framework is unable to find a match using a UiSelector.
# #SKIP Not sure if it is possible with just ADB
#
# removeWatcher(String name)
# Removes a previously registered UiWatcher.
# #SKIP Not sure if it is possible with just ADB
#
# resetWatcherTriggers()
# Resets a UiWatcher that has been triggered.
# #SKIP Not sure if it is possible with just ADB
#
# runWatchers()
# This method forces all registered watchers to run.
# #SKIP Not sure if it is possible with just ADB
#
# setCompressedLayoutHeirarchy(boolean compressed)
# Enables or disables layout hierarchy compression.
# #SKIP Not sure if it is possible with just ADB
#
# setOrientationLeft()
# Simulates orienting the device to the left and also freezes rotation by disabling the sensors.
function uid_set_orientation_left() { # rotates device to the left counting from natural portrait position
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  uid_freeze_rotation "$device_id"

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell settings put system user_rotation 1
}
#
# setOrientationNatural()
# Simulates orienting the device into its natural orientation and also freezes rotation by disabling the sensors.
function uid_set_orientation_natural() { # rotates device to natural portrait
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  uid_freeze_rotation "$device_id"

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell settings put system user_rotation 0
}
#
# setOrientationRight()
# Simulates orienting the device to the right and also freezes rotation by disabling the sensors.
function uid_set_orientation_right() {  # rotates device to the right counting from natural portrait position
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  uid_freeze_rotation "$device_id"

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell settings put system user_rotation 3
}
#
# sleep()
# This method simply presses the power button if the screen is ON else it does nothing if the screen is already OFF.
function uid_sleep() { # turns the screen off
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input keyevent "$KEYCODE_SLEEP"
}
#
# swipe(int startX, int startY, int endX, int endY, int steps)
# Performs a swipe from one coordinate to another using the number of steps to determine smoothness and speed.
function uid_swipe() { # performs swipe on screen instead of element, specify numbers x, y and w, z being margins from top, left edges
  local device_id="$1" # device id taken from `adb devices`
  local x_from="$2" # self explanatory
  local y_from="$3" # self explanatory
  local x_to="$4" # self explanatory
  local y_to="$5" # self explanatory
  local duration="$6" # expressed in milliseconds

  adb -s "$device_id" shell input swipe "$x_from" "$y_from" "$x_to" "$y_to" "$duration"
} 
#
# swipe(Point[] segments, int segmentSteps)
# Performs a swipe between points in the Point array.
# #SKIP Please use uid_swipe
#
# takeScreenshot(File storePath, float scale, int quality)
# Take a screenshot of current window and store it as PNG The screenshot is adjusted per screen rotation
# #SKIP Please use uid_take_screenshot
#
# takeScreenshot(File storePath)
# Take a screenshot of current window and store it as PNG Default scale of 1.0f (original size) and 90% quality is used The screenshot is adjusted per screen rotation
function uid_take_screenshot() { # takes screenshot to specified filename without .png extension
  local device_id="$1" # device id taken from `adb devices`
  local screenshot_path=`default "$2" 'temporary_screenshot_filename.png'` # path where the screenshot will be stored
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}> screenshot_path=<${screenshot_path}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null
  validators_filepath_png "$screenshot_path" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell screencap -p > "$screenshot_path"
}
#
# unfreezeRotation()
# Re-enables the sensors and un-freezes the device rotation allowing its contents to rotate with the device physical rotation.
function uid_unfreeze_rotation() { # unlock devide's reactions to rotations
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell settings put system accelerometer_rotation 1
}
#
# wait(SearchCondition<R> condition, long timeout)
# Waits for given the condition to be met.
# #SKIP Must be handled by custom function or see utils_wait_to_see or utils_wait_to_gone
#
# waitForIdle(long timeout)
# Waits for the current application to idle.
# #TODO
#
# waitForIdle()
# Waits for the current application to idle.
# #TODO
#
# waitForWindowUpdate(String packageName, long timeout)
# Waits for a window content update event to occur.
# #TODO
#
# wakeUp()
# This method simulates pressing the power button if the screen is OFF else it does nothing if the screen is already ON.
function uid_wake_up() { # turns the screen on
  local device_id="$1" # device id taken from `adb devices`
  
  logs_append "`logs_time` | ACTION | INPUT | function=<${FUNCNAME[0]}> device_id=<${device_id}>"
  validators_device_id "$device_id" "$TRUE" > /dev/null

  logs_append "`logs_time` | ACTION | OUTPUT | function=<${FUNCNAME[0]}>"

  adb -s "$device_id" shell input keyevent "$KEYCODE_WAKEUP"
}
#
# Device API end
