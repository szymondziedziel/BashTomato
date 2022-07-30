# BashTomato

Simply just wrapper over ADB written in Bash to automate tasks on devices and/ or emulators.

BashTomato is a hobby project. It is a small script that offers part of functionality from:

- https://developer.android.com/reference/androidx/test/uiautomator/UiObject2
- https://developer.android.com/reference/androidx/test/uiautomator/UiDevice
- https://developer.android.com/reference/android/view/KeyEvent
- and couple of other ADB's commands

and is created to automate simple, daily repetitive work in simple (or not that simple, because of Bash) way.

## Requirements

- ADB installed
- device or emulator properly configured
- ./src/extensions.sh may require additional libs and packages like for example imagemagick for handling better screenshots and inspecting the screen hierarchy in more friendly graphical way

## Benefits

- compatibility with different Androids based on installed ADB
- works with device/ emulator immediately after script started, no code compilation
- Bash is present on most unix-like systems, so no additional configurations and dependencies needed

## Unfortunately (Update: I added appium as better dumper)

It uses `adb shell uiautomator dump` to get window's hierarchy, so it causes that BashTomato is not able to:

- touch on screen keyboard
- inspect webview's content

## Appium as better dumper

Better right after it starts server, creates session on the device, install all additional APKs (may require to user-click-agree), and then will no crash

### Additional requirements:

- Install NodeJS
- Install Appium through NodeJS to make it available globally (I will consider to make it possible to use local Appium installation)
- Install `jq` program. It is for easier Appium server responses handling
- Appium asked me to install Android SDK, so I did just by installing Android Studio (I also have adb thanks to Android Studio)
- And there were problems with lack of exported variables (I have macOS and use ZSH), so:

I added:

```
export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/$USER/Library/Android/sdk"
```

to my `~/.zshrc`

To force BashTomato to use Appium export everytime `export BASHTOMATO_HIERARCHY_DUMPER='appium'` (for example in each test before sourcing ./dist/bashtomato.sh) or also add this to your shell file (my is ~/.zshrc)

And that's it. You should not care about starting appium server or preparing annoying capabilities. BashTomato will do the rest for you

### Simple speed test

So I used some old devices. My macOS is simple MacBook Air (13-inch, 2017) and used real device/ smartphone is some huawei with sdk 27; android 8.1.0. So the test says you probably nothing and has nothing to says about your hardrware.

For test I used `utils_wait_to_see` function that fetches whole hierarchy from the device and checks if proper element is visible (by default `utils_wait_to_see` tries 30 times, I searched for non-existing element):

```
#!/bin/bash

device_id="$1"

export BASHTOMATO_HIERARCHY_DUMPER='appium'

source ./BashTomato/dist/bashtomato.sh

date
utils_wait_to_see "$device_id" 'Jetsurvey2'
date
```

And results I got are:
For ADB uiautomator dump:
```
start Sat Jul 30 11:14:34 CEST 2022
null
stop Sat Jul 30 11:15:54 CEST 2022
```
For Appium when server is down (I have put 10 second sleep to give server chance to be fully ready !that should be done better!):
```
start Sat Jul 30 11:42:20 CEST 2022
null
stop Sat Jul 30 11:42:51 CEST 2022
```
For Appium when server is up:
```
start Sat Jul 30 11:42:58 CEST 2022
null
stop Sat Jul 30 11:43:17 CEST 2022
```

It about 300% of previous speed. It is better?
- Yes because tests can be more accurate
- No because functions like `utils_wait_to_see` that are attempts count based works faster so waits shorter
- Yes because it's faster
- No because it adds more dependencies that can complicated the process, crash, block ports etc.

### Appium as better dumper troubleshooting

As this is only test of such extension, so it runs on default 0.0.0.0:4723 (I will consider to make it configurable if it will work stable enough)
In case of any error try to kill all appium services, but before you will restart everything, please try to investigate problem with:

`pgrep appium`, `ps | grep appium` and/ or `lsof -i :4723` and/ or `kill $PID` where $PID can be taken from two first commands

### Appium as better dumper LICENSE

Please see NOTICE.md

## How to use it

- clone repository to your local machine
- create new shell-like script file
- include ./src/bashtomato.sh or a bit minified version ./dist/bashtomato.sh. To have ./dist/bashtomato.sh it is required to execute ./clean_install_build_test.sh (unit and E2E test will be automatically executed. E2E will fail for sure, but BashTomato should work correctly)
- start automate

```sh
#!/bin/bash

source './dist/bashtomato.sh'

# your code goes here
```

for more what your testing code should look like you can refer to ./tests/e2e/example.sh. I used there most of functions offered by BashTomato to test them and show sample usage

## Testing

I used [shUnit2](https://github.com/kward/shunit2#shunit2) to write some unit tests, but also prepared simple apk in ./tests/e2e to be able to run most of BashTomato's functions.

Of course not everything is fully tested as this is very early version.

I run test on emulator Nexus 6 with API 27, 1440x2560 560dpi as tests strictly checks sleep, wake up, resolution, dpi etc., so running on any device will probably fail fast, because there will be nothing to uninstall, no data to clean, device may have screen locked with PIN etc. and/ or resolution may not match.

## Autogenerated API


### Function: ext_screenshot_node()
`description`:  makes screenshot and cuts out image of given element
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-string-like element of which screenshot is to be done


`name`: screenshot_filename\
`position`: 2\
`optional`\
`default`: 'temporary_screenshot_filename.png'\
`description`:  path to full screenshot with `.png` extension from which node screenshot will be taken


`name`: node_screenshot_filename\
`position`: 3\
`optional`\
`default`: 'temporary_node_screenshot_filename.png'\
`description`:  path to point to where node screenshot will be stored

### Function: ext_inspect_window_hierarchy()
`description`:  makes full screenshot and then images of all nodes in hierarchy (very poor performance)
#### Params:


`name`: xml\
`position`: 1\
`optional`\
`default`: ''\
`description`:  XML-like-string of entire window hierarchy or any of its subnode.


`name`: screenshot_filename\
`position`: 2\
`optional`\
`default`: 'temporary_screenshot_filename.png'\
`description`:  path to full screenshot with `.png` extension from which node screenshot will be taken


`name`: directory\
`position`: 3\
`optional`\
`default`: 'inspect'\
`description`:  directory path where to store all nodes' screenshots

### Function: val_or_null()
`description`:  takes care to return special `$NULL` when given value is bash-like-empty
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value that may be normalized to `$NULL`

### Function: default()
`description`:  helps easily assign default value to variable when bash-like-empty value is provided
#### Params:


`name`: current_value\
`position`: 1\
`required`\
`description`:  actual value


`name`: default_value\
`position`: 2\
`optional`\
`default`: \
`description`:  value to return when actual value will be bash-like-empty. If this value will be also bash-like-empty then `val_or_null` function will be applied to actual value

### Function: calc_point_on_section()
`description`:  calculates value from between `min` and `max`, distanced from min by number or percentage value. Currently function does not take care to keep result in bounds of `min` and `max`
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  distance from min expressed in pixels or percent from |max-min| result


`name`: min\
`position`: 2\
`required`\
`description`:  lower border


`name`: max\
`position`: 3\
`required`\
`description`:  higher border

### Function: calc_point_on_surface()
`description`:  calculates point in 2D within surface defined by element's bounds, appropriately distanced from top and left by number of percentage values
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-string-like element, which determines bounds of interaction like click, swipe etc. on the device's screen


`name`: x\
`position`: 2\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  distance from left edge of element


`name`: y\
`position`: 3\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  distance from top edge of element

### Function: get_prop()
`description`:  element or node is simply XML-string-like element, this function extract given attribute's value
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-string-like element from which attribute value will be extracted


`name`: prop_name\
`position`: 2\
`required`\
`description`:  XML attribute name

### Function: calc_duration_from_distance_speed()
`description`:  calculates time needed to travel from one 2D point to another for given speed
#### Params:


`name`: x_from\
`position`: 1\
`required`\
`description`:  self explanatory


`name`: y_from\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: x_to\
`position`: 3\
`required`\
`description`:  self explanatory


`name`: y_to\
`position`: 4\
`required`\
`description`:  self explanatory


`name`: speed\
`position`: 5\
`optional`\
`default`: 1000\
`description`:  self explanatory

### Function: helper_string_length()
`description`:  returns string's length 
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  string, which length will be calculated

### Function: helper_string_substring()
`description`:  returns substring with `length` starting from `from`, bash-like-empty string will result with `$NULL`
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to opearate on


`name`: from\
`position`: 2\
`required`\
`description`:  start index, 0 means the very beginning; first string's character


`name`: length\
`position`: 3\
`required`\
`description`:  length to cut out

### Function: helper_string_to_lower()
`description`:  lowercase given string, bash-like-empty string will result with empty string instead of `$NULL`
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  self explanatory

### Function: helper_string_to_upper()
`description`:  uppercase given string, bash-like-empty string will result with empty string instead of `$NULL`
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  self explanatory

### Function: helper_string_capitalize()
`description`:  lowercase given string, except first character, which goes upper, bash-like-empty string will result with empty string instead of `$NULL`
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  self explanatory

### Function: helper_objects_count()
`description`:  simply returns lines count, useful with `uio2_find_objects` as every XML-like-element is located in single line. It will cheat you if you accidentally pass `$NULL`, which may be returned from `uio2_find_objects`
#### Params:


`name`: objects\
`position`: 1\
`required`\
`description`:  multiline text

### Function: helper_string_does_string_starts_with()
`description`:  checks if given `string` starts with other string
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: start_string\
`position`: 2\
`required`\
`description`:  value that is expected to be at the beginning of `string`

### Function: helper_string_does_string_ends_with()
`description`:  checks if given `string` ends with other string
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: end_string\
`position`: 2\
`required`\
`description`:  value that is expected to be at the end of `string`

### Function: helper_string_does_string_contains()
`description`:  checks if given `string` includes other string
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: substring\
`position`: 2\
`required`\
`description`:  value that is expected to exists (entirely) within `string` at any index

### Function: helper_string_is_lower_case()
`description`:  ckecks if whole string is build from lowercase letters
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on

### Function: helper_string_is_upper_case()
`description`:  ckecks if whole string is build from uppercase letters
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on

### Function: helper_string_is_capitalised()
`description`:  ckecks if whole string is build from lower letters, except first which is uppercase
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on

### Function: helper_string_does_strings_are_equal()
`description`:  checks if two strings are same
#### Params:


`name`: string_a\
`position`: 1\
`required`\
`description`:  self explanatory


`name`: string_b\
`position`: 2\
`required`\
`description`:  self explanatory

### Function: helper_string_join()
`description`:  joins all given strings with given glue-string
#### Params:


`name`: glue\
`position`: 1\
`optional`\
`default`: ''\
`description`:  string which will be added between all other passed to function (except beginning and end)

### Function: helper_string_index_of_string()
`description`:  finds index of first occurence of `string_b` in `string_a` starting from `start_from`
#### Params:


`name`: string_a\
`position`: 1\
`required`\
`description`:  self explanatory


`name`: string_b\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: start_from\
`position`: 3\
`optional`\
`default`: 0\
`description`:  self explanatory

### Function: helper_string_to_bytes()
`description`:  self explanatory
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`: self explanatory

### Function: helper_string_replace()
`description`:  replace all occurences of one string to another in the main one
#### Params:


`name`: string\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: string_a\
`position`: 2\
`required`\
`description`:  string to search for


`name`: string_b\
`position`: 3\
`required`\
`description`:  string to replace for

### Function: uid_click()
`description`:  clicks on specified screen point, numbers x, y from top, left edges
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: x\
`position`: 2\
`required`\
`description`:  distance in pixels from left screen edge


`name`: y\
`position`: 3\
`required`\
`description`:  distance in pixels from top screen edge

### Function: uid_drag()
`description`:  drags from point to point, from x, y (pixels) from left, top edges to w, z (pixels) from left, top edges
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: x_from\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: y_from\
`position`: 3\
`required`\
`description`:  self explanatory


`name`: x_to\
`position`: 4\
`required`\
`description`:  self explanatory


`name`: y_to\
`position`: 5\
`required`\
`description`:  self explanatory


`name`: duration\
`position`: 6\
`required`\
`description`:  expressed in milliseconds


`name`: device_id\
`position`: 7\
`required`\
`description`:  device id taken from `adb devices`


`name`: dump_filepath\
`position`: 8\
`optional`\
`default`: 'temporary_xml_dump.xml'\
`description`:  path where entire dump hierarchy will be stored

### Function: uid_dump_window_hierarchy_with_adb_automator_dump()
`description`:  retrieve XML-source of current visible application screen. Unable to get complete XML for password/ pin screen, on-screen keyboard, webview is presented
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: dump_filepath\
`position`: 2\
`optional`\
`default`: 'temporary_xml_dump.xml'\
`description`:  path where entire dump hierarchy will be stored

### Function: uid_dump_window_hierarchy()
`description`:  retrieve XML-source of current visible application screen. Unable to get complete XML for password/ pin screen, on-screen keyboard, webview is presented
#### Params:

### Function: uid_freeze_rotation()
`description`:  disables device's sensor
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_current_activity_name()
`description`:  dumps current visible activity's name
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_display_height()
`description`:  gets screen height in pixels
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_display_rotation()
`description`:  gets screen rotation value previously set
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_display_size_dp()
`description`:  gets screen density
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_display_width()
`description`:  gets screen width in pixels
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_get_product_name()
`description`:  retrieves the product name of the device
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_is_screen_on()
`description`:  checks if screen in turned on
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_open_notification()
`description`:  drags menu from top device bar
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_press_key_code()
`description`:  sends key to the device to perform
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: keycode\
`position`: 2\
`required`\
`description`:  keycode number, preferred way is to use named constants from within `keycodes.sh` or keycodes file fallback for bash 3.2

### Function: uid_set_orientation_left()
`description`:  rotates device to the left counting from natural portrait position
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_set_orientation_natural()
`description`:  rotates device to natural portrait
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_set_orientation_right()
`description`:  rotates device to the right counting from natural portrait position
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_sleep()
`description`:  turns the screen off
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_swipe()
`description`:  performs swipe on screen instead of element, specify numbers x, y and w, z being margins from top, left edges
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: x_from\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: y_from\
`position`: 3\
`required`\
`description`:  self explanatory


`name`: x_to\
`position`: 4\
`required`\
`description`:  self explanatory


`name`: y_to\
`position`: 5\
`required`\
`description`:  self explanatory


`name`: duration\
`position`: 6\
`required`\
`description`:  expressed in milliseconds

### Function: uid_take_screenshot()
`description`:  takes screenshot to specified filename without .png extension
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: screenshot_path\
`position`: 2\
`optional`\
`default`: 'temporary_screenshot_filename.png'\
`description`:  path where the screenshot will be stored

### Function: uid_unfreeze_rotation()
`description`:  unlock devide's reactions to rotations
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uid_wake_up()
`description`:  turns the screen on
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uio2_clear()
`description`:  clears editable text, auto clicks on such element, very poor in terms of performance
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at

### Function: uio2_click()
`description`:  shortly clicks on element
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: x\
`position`: 3\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y\
`position`: 4\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_click_with_duration()
`description`:  clicks with given duration, default 0.5 second
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: duration\
`position`: 3\
`optional`\
`default`: 500\
`description`:  expresed in milliseconds


`name`: x\
`position`: 4\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y\
`position`: 5\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_click_and_wait()
`description`:  shortly clicks on element and waits, default 5 seconds
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: wait_time\
`position`: 3\
`optional`\
`default`: 5\
`description`:  expressed in seconds, bash greater than 3.2 it is possible to use values like 3.5, 1.6 etc.


`name`: x\
`position`: 4\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y\
`position`: 5\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_drag()
`description`:  drags from one element to another. Start, end points can be changed by top, left margins for each
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node_from\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: node_to\
`position`: 3\
`required`\
`description`:  self explanatory


`name`: duration\
`position`: 4\
`optional`\
`default`: 500\
`description`:  expressed in milliseconds


`name`: x_from\
`position`: 5\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y_from\
`position`: 6\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent


`name`: x_to\
`position`: 7\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y_to\
`position`: 8\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_drag_with_speed()
`description`:  like uio2_drag, but speed may be defined instead fo duration
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node_from\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: node_to\
`position`: 3\
`required`\
`description`:  self explanatory


`name`: speed\
`position`: 4\
`optional`\
`default`: 1000\
`description`:  expressed in milliseconds


`name`: x_from\
`position`: 5\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y_from\
`position`: 6\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent


`name`: x_to\
`position`: 7\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y_to\
`position`: 8\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_equals()
`description`:  compares elements like XML-strigs, not by reference
#### Params:


`name`: node_a\
`position`: 1\
`required`\
`description`:  XML-string-like element, treated really as string not object reference in this case


`name`: node_b\
`position`: 2\
`required`\
`description`:  XML-string-like element, treated really as string not object reference in this case

### Function: uio2_find_object()
`description`:  filters element from given XML-source matching regular expression pattern
#### Params:


`name`: xml\
`position`: 1\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: filter\
`position`: 2\
`required`\
`description`:  simple bash-grep-like expression passed with -oE options


`name`: index\
`position`: 3\
`optional`\
`default`: 1\
`description`:  instance number counting from 1

### Function: uio2_find_objects()
`description`:  filters many element from given XML-source matching regular expression pattern
#### Params:


`name`: xml\
`position`: 1\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: filter\
`position`: 2\
`required`\
`description`:  simple bash-grep-like expression passed with -oE options

### Function: uio2_get_application_package()
`description`:  get current package_name using ADB, may not work for all devices
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: uio2_get_children_count()
`description`:  count children of given node based on whole XML-source
#### Params:


`name`: xml\
`position`: 1\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at

### Function: uio2_get_children()
`description`:  filter childrens like XML-strings of given node from whole XML-source
#### Params:


`name`: xml\
`position`: 1\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at

### Function: uio2_get_class_name()
`description`:  gets XML element's class attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_get_content_description()
`description`:  gets XML element's content-description attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_get_parent()
`description`:  gets element's parent based on ginec element and whole XML-source
#### Params:


`name`: xml\
`position`: 1\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at

### Function: uio2_get_resource_id()
`description`:  gets XML element's resource-id attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_get_text()
`description`:  gets XML element's text attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_get_bounds()
`description`:  gets XML element's bounds attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted


`name`: bound_name\
`position`: 2\
`required`\
`description`:  bounds name, one of `left`, `top`, `right`, `bottom`

### Function: uio2_get_visible_center()
`description`:  calculates center of visible element's part
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted


`name`: xml\
`position`: 2\
`required`\
`description`:  XML-string-like hierarchy or any of its part where the search will be performed


`name`: node\
`position`: 3\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: filter\
`position`: 4\
`required`\
`description`:  simple bash-grep-like expression passed with -oE options

### Function: uio2_is_checkable()
`description`:  gets XML element's checkable attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_checked()
`description`:  gets XML element's checked attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_clickable()
`description`:  gets XML element's clickable attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_enabled()
`description`:  gets XML element's enabled attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_focusable()
`description`:  gets XML element's focusable
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_focused()
`description`:  gets XML element's focused attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_long_clickable()
`description`:  gets XML element's long-clickable attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_scrollable()
`description`:  gets XML element's scrollable attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_is_selected()
`description`:  gets XML element's selected attribute
#### Params:


`name`: node\
`position`: 1\
`required`\
`description`:  XML-like-string element from which attribute's value will be extracted

### Function: uio2_long_click()
`description`:  clicks 0.5 seconds long on element
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: x\
`position`: 3\
`optional`\
`default`: "$ANCHOR_POINT_CENTER"\
`description`:  value in pixels or percent


`name`: y\
`position`: 4\
`optional`\
`default`: "$ANCHOR_POINT_MIDDLE"\
`description`:  value in pixels or percent

### Function: uio2_pinch_close()
`description`:  performs pinch close gesture on elemetn with specified size
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: percent\
`position`: 3\
`optional`\
`default`: '50%'\
`description`:  self explanatory


`name`: duration\
`position`: 4\
`optional`\
`default`: 500\
`description`:  expressed in milliseconds

### Function: uio2_pinch_open()
`description`:  performs pinch open gesture on elemetn with specified size
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: percent\
`position`: 3\
`optional`\
`default`: '50%'\
`description`:  self explanatory


`name`: duration\
`position`: 4\
`optional`\
`default`: 500\
`description`:  expressed in milliseconds

### Function: uio2_set_text()
`description`:  write text to editable, auto clicks the element
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: content\
`position`: 3\
`optional`\
`default`: ''\
`description`:  text to be typed inside editable

### Function: uio2_swipe_with_speed()
`description`:  like uio2_swipe, but need speed instead of duration
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: direction\
`position`: 3\
`optional`\
`default`: "$DIRECTION_DOWN"\
`description`:  direction to which gesture should be moved


`name`: percent\
`position`: 4\
`optional`\
`default`: '50%'\
`description`:  self explanatory


`name`: speed\
`position`: 5\
`optional`\
`default`: 1000\
`description`:  expressed in milliseconds

### Function: uio2_swipe()
`description`:  performs swipe on element from its one point to another
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: node\
`position`: 2\
`required`\
`description`:  XML-string-like element, which action will be performed at


`name`: direction\
`position`: 3\
`optional`\
`default`: "$DIRECTION_DOWN"\
`description`:  direction to which gesture should be moved


`name`: percent\
`position`: 4\
`optional`\
`default`: '50%'\
`description`:  self explanatory


`name`: duration\
`position`: 5\
`optional`\
`default`: 500\
`description`:  expressed in milliseconds

### Function: utils_assert_null()
`description`:  exits with `success_message` and status 0 if `value` is `$NULL` else prints `error_message` with status 1
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 2\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_not_null()
`description`:  exits with `success_message` and status 0 if `value` is NOT `$NULL` else prints `error_message` with status 1
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 2\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_true()
`description`:  exits with `success_message` and status 0 if `value` is `$TRUE` else prints `error_message` with status 1
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 2\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_false()
`description`:  exits with `success_message` and status 0 if `value` is `$FALSE` else prints `error_message` with status 1
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 2\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_string_is_empty()
`description`:  exits with `success_message` and status 0 if `value` expands to '' else prints `error_message` with status 1
#### Params:


`name`: value\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 2\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_strings_are_equal()
`description`:  exits with `success_message` and status 0 if `value_a` and `value_b` expand to same values else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_strings_are_different()
`description`:  exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_less_than_second()
`description`:  exits with `success_message` and status 0 if `value_a` is less than `value_b` else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_less_or_equal_than_second()
`description`:  exits with `success_message` and status 0 if `value_a` is less or equal than `value_b` else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_equals_second()
`description`:  exits with `success_message` and status 0 if `value_a` and `value_b` are equal else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_greater_or_equal_than_second()
`description`:  exits with `success_message` and status 0 if `value_a` is greater or equal than `value_b` else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_greater_than_second()
`description`:  exits with `success_message` and status 0 if `value_a` is greater than `value_b` else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_assert_numbers_first_is_not_equal_to_second()
`description`:  exits with `success_message` and status 0 if `value_a` and `value_b` expand to different values else prints `error_message` with status 1
#### Params:


`name`: value_a\
`position`: 1\
`required`\
`description`:  value to operate on


`name`: value_b\
`position`: 2\
`required`\
`description`:  value to operate on


`name`: success_message\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: error_message\
`position`: 4\
`optional`\
`default`: ''\
`description`:  self explanatory

### Function: utils_devices()
`description`:  returns all devices ids list or single device id if `device_index` passed
#### Params:


`name`: device_index\
`position`: 1\
`optional`\
`default`: ''\
`description`:  line number, which will be read as `device_id` from `adb devices` incremented by 1

### Function: utils_is_device_connected()
`description`:  checks if device with `device_id` is reachable from ADB, returns `$TRUE`/ `$FALSE`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: utils_restart_server()
`description`:  restarts ADB server
#### Params:

### Function: utils_reboot()
`description`:  reboots device by its `device_id`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`

### Function: utils_set_display()
`description`:  sets resolution and density by provoding named params of deivce by `device_id`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: resolution\
`position`: 2\
`required`\
`description`:  new screen resolution matching regexp [0-9]{1,4}x[0-9]{1,4}, non positional parameter


`name`: density\
`position`: 3\
`required`\
`description`:  new screen resolution matching regexp [0-9]{1,4}, non positional parameter

### Function: utils_install_and_start()
`description`:  starts `package_name` on device with `device_id`, allows to install apk and force reinstall
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: package_name\
`position`: 2\
`required`\
`description`:  self explanatory


`name`: apkpath\
`position`: 3\
`optional`\
`default`: ''\
`description`:  self explanatory


`name`: force\
`position`: 4\
`optional`\
`default`: ''\
`description`:  if not bash-like-empty then it will force to reinstall

### Function: utils_stop_app()
`description`:  stops app with `package_name` on device with `device_id`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: package_name\
`position`: 2\
`required`\
`description`:  self explanatory

### Function: utils_uninstall()
`description`:  uninstalls app with `package_name` on device with `device_id`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: package_name\
`position`: 2\
`required`\
`description`:  self explanatory

### Function: utils_clear_data()
`description`:  clears app data of `package_name` on device with `device_id`
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: package_name\
`position`: 2\
`required`\
`description`:  self explanatory

### Function: utils_record()
`description`:  records video from device with `device_id`, for now this probably locks device blockick possibility to execute other functions
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: filepath\
`position`: 2\
`required`\
`description`:  self explanatory

### Function: utils_wait_to_see()
`description`:  search for element on device's screen by `device_id`, dumps hierarchy until element appeared or attempts exhaust
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: filter\
`position`: 2\
`required`\
`description`:   


`name`: index\
`position`: 3\
`optional`\
`default`: 1\
`description`:  instance number counting from 1


`name`: attempts\
`position`: 4\
`optional`\
`default`: 30\
`description`:  dumps to execute before return `$NULL`

### Function: utils_search_node()
`description`:  searches for element in advanced way, it scrolls horizontally or vertically through given element and searches for other element inside, moved by configurable steps, repeats `cycles` times
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: object_to_search_in\
`position`: 2\
`required`\
`description`:  XML-string-like element (container) to search in


`name`: filter\
`position`: 3\
`required`\
`description`:  simple bash-grep-like expression passed with -oE options


`name`: index\
`position`: 4\
`optional`\
`default`: 1\
`description`:  instance number counting from 1


`name`: swiping_direction\
`position`: 5\
`optional`\
`default`: "$DIRECTION_VERTICAL"\
`description`:  self explanatory


`name`: cycles\
`position`: 6\
`optional`\
`default`: 1\
`description`:  number of repeats (scroll back and forth) when scroll limit reached


`name`: swipe_length\
`position`: 7\
`optional`\
`default`: '50%'\
`description`:  self explanatory


`name`: swipes_count_left\
`position`: 8\
`optional`\
`default`: 50\
`description`:  general number of swipes before completely stop (returning `$NULL`), global limit unrelated with cycles

### Function: utils_wait_to_gone()
`description`:  search for element on device's screen by `device_id`, dumps hierarchy until element gone or attempts exhaust
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`


`name`: filter\
`position`: 2\
`required`\
`description`:  simple bash-grep-like expression passed with -oE options


`name`: index\
`position`: 3\
`optional`\
`default`: 1\
`description`:  instance number counting from 1


`name`: attempts\
`position`: 4\
`optional`\
`default`: 30\
`description`:  dumps to execute before return `$NULL`

### Function: utils_get_device_orientation()
`description`:  gets device's orientation as number 0 to 3
#### Params:


`name`: device_id\
`position`: 1\
`required`\
`description`:  device id taken from `adb devices`
