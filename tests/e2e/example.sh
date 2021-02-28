#!/bin/bash

echo "***** TEST STARTED"

SCRIPT_PATH=`dirname ${BASH_SOURCE[0]}`

source "${SCRIPT_PATH}/../../dist/bashtomato.sh"

utils_restart_server

device_id=`utils_devices 1`
is_device_connected=`utils_is_device_connected "$device_id"`

if [ "$is_device_connected" == "$FALSE" ]
then
  echo "***** NO DEVICE CONNECTED, I WILL NOT CONTINUE E2E CHECKS"
  echo "***** BUT ./dist/bashtomato.sh SHOULD BE BUILT AND AVAILABLE TO USE"
  exit 1
fi

utils_assert_true "$is_device_connected" 'Device is connected' 'Could execute command, unknown device provided'
package_name='com.example.bashtomatotester'

utils_stop_app "$device_id" "$package_name"
utils_clear_data "$device_id" "$package_name"
utils_uninstall "$device_id" "$package_name"

uid_sleep "$device_id"
uid_wake_up "$device_id"
uid_open_notification "$device_id"
uid_swipe "$device_id" 50 50 50 1000 400
uid_freeze_rotation "$device_id"
temp_xml_filename='temp.xml'
uid_dump_window_hierarchy "$device_id" "$temp_xml_filename"
if [ ! -f "$temp_xml_filename" ]; then exit 1; fi
rotation_state=`utils_wait_to_see "$device_id" 'Portrait' 1 5`
point=`calc_point_on_surface "$rotation_state"`
uid_click "$device_id" "$point"
rotation_state=`utils_wait_to_gone "$device_id" 'Portrait' 1 5`
rm -rf "$temp_xml_filename"
uid_press_key_code "$device_id" $KEYCODE_HOME

height=`uid_get_display_height "$device_id"`
utils_assert_numbers_first_less_than_second "$height" 2561
utils_assert_numbers_first_greater_than_second "$height" 2559

width=`uid_get_display_width "$device_id"`
utils_assert_numbers_first_less_or_equal_than_second "$width" 1440
utils_assert_numbers_first_greater_or_equal_than_second "$width" 1440

size_dp=`uid_get_display_size_dp "$device_id"`
utils_assert_numbers_first_is_not_equal_to_second "$size_dp" 561
utils_assert_numbers_first_equals_second "$size_dp" 560

orientation=`utils_get_device_orientation  "$device_id"`
utils_assert_numbers_first_equals_second "$orientation" 0

uid_set_orientation_left "$device_id"
orientation=`utils_get_device_orientation "$device_id"`
utils_assert_numbers_first_equals_second "$orientation" 1

uid_set_orientation_natural "$device_id"
orientation=`utils_get_device_orientation "$device_id"`
utils_assert_numbers_first_equals_second "$orientation" 0

uid_set_orientation_right "$device_id"
orientation=`utils_get_device_orientation "$device_id"`
utils_assert_numbers_first_equals_second "$orientation" 3

temp_png_filename='temp.png'
uid_take_screenshot "$device_id" "$temp_png_filename"
if [ ! -f "$temp_png_filename" ]; then exit 1; fi
rm -rf "$temp_png_filename"

uid_unfreeze_rotation "$device_id"

utils_install_and_start "$device_id" "$package_name" "${SCRIPT_PATH}/bashtomatotester-debug.apk"

utils_wait_to_see "$device_id" 'Home' > /dev/null
curr_activity=`uid_get_current_activity_name "$device_id"`
utils_assert_strings_are_equal "$curr_activity" 'com.example.bashtomatotester.MainActivity'

toolbar=`utils_wait_to_see "$device_id" 'resource-id="com.example.bashtomatotester:id/toolbar"'`

toolbar_resid=`uio2_get_resource_id "$toolbar"`
utils_assert_strings_are_equal "$toolbar_resid" 'com.example.bashtomatotester:id/toolbar'

toolbar_class=`uio2_get_class_name "$toolbar"`
utils_assert_strings_are_equal "$toolbar_class" 'android.view.ViewGroup'

toolbar_content_description=`uio2_get_content_description "$toolbar"`
utils_assert_string_is_empty "$toolbar_content_description"

xml_name='temporary_xml_dump.xml'
xml=`cat "$xml_name"`
toolbar_parent_found=`uio2_find_object "$xml" 'class="android.widget.LinearLayout"' 3`

toolbar_parent=`uio2_get_parent "$xml" "$toolbar"`

parents_equal=`uio2_equals "$toolbar_parent" "$toolbar_parent_found"`
utils_assert_true "$parents_equal"

toolbar_text=`uio2_get_text "$toolbar"`
utils_assert_strings_are_equal "$toolbar_text" ''

toolbar_bounds=`uio2_get_bounds "$toolbar"`
utils_assert_strings_are_equal "$toolbar_bounds" 'left=0,top=84,right=1440,bottom=280'

toolbar_visible_center=`uio2_get_visible_center "$toolbar"`
utils_assert_strings_are_equal "$toolbar_visible_center" '720 182'

toolbar_children_count=`uio2_get_children_count "$xml" "$toolbar"`
utils_assert_numbers_first_equals_second "$toolbar_children_count" 3

toolbar_class=`uio2_get_class_name "$toolbar"`
utils_assert_strings_are_equal "$toolbar_class" 'android.view.ViewGroup'

toolbar_class=`uio2_get_class_name "$toolbar"`
utils_assert_strings_are_equal "$toolbar_class" 'android.view.ViewGroup'

toolbar_is_checkable=`uio2_is_checkable "$toolbar"`
utils_assert_false "$toolbar_is_checkable"

toolbar_is_checked=`uio2_is_checked "$toolbar"`
utils_assert_false "$toolbar_is_checked"

toolbar_is_clickable=`uio2_is_clickable "$toolbar"`
utils_assert_false "$toolbar_is_clickable"

toolbar_is_enabled=`uio2_is_enabled "$toolbar"`
utils_assert_true "$toolbar_is_enabled"

toolbar_is_focusable=`uio2_is_focusable "$toolbar"`
utils_assert_false "$toolbar_is_focusable"

toolbar_is_focused=`uio2_is_focused "$toolbar"`
utils_assert_false "$toolbar_is_focused"

toolbar_is_long_clickable=`uio2_is_long_clickable "$toolbar"`
utils_assert_false "$toolbar_is_long_clickable"

toolbar_is_scrollable=`uio2_is_scrollable "$toolbar"`
utils_assert_false "$toolbar_is_scrollable"

toolbar_is_selected=`uio2_is_selected "$toolbar"`
utils_assert_false "$toolbar_is_selected"

empty=`uio2_find_object "$xml" 'resource-id="com.example.bashtomatotester:id/empty"'`
uio2_set_text "$device_id" "$empty" '1234567890qwertyuiopasdfghjklzxcvbnm!@#$%^&*()_+{}:'\''"|<>?-=[];\,/'

filled=`uio2_find_object "$xml" 'resource-id="com.example.bashtomatotester:id/filled"'`
uio2_clear "$device_id" "$filled"

drawer_opener=`utils_wait_to_see "$device_id" 'content-desc="Open navigation drawer"'`
uio2_click "$device_id" "$drawer_opener"

o=`utils_wait_to_see "$device_id" 'resource-id="com.example.bashtomatotester:id/design_menu_item_text"' 2`
o_text=`uio2_get_text "$o"`
utils_assert_strings_are_equal "$o_text" 'Gallery'
uio2_click "$device_id" "$o"

o=`utils_wait_to_see "$device_id" 'resource-id="com.example.bashtomatotester:id/gallery"'`
xml=`cat temporary_xml_dump.xml`
o=`uio2_find_objects "$xml" 'class="android.widget.Button"'`
o_count=`helper_objects_count "$o"`
utils_assert_numbers_first_equals_second "$o_count" 12

uio2_click "$device_id" "$drawer_opener"

o=`utils_wait_to_see "$device_id" 'resource-id="com.example.bashtomatotester:id/design_menu_item_text"' 3`

o_text=`uio2_get_text "$o"`
utils_assert_strings_are_equal "$o_text" 'ScrollVH'
uio2_click "$device_id" "$o"

o=`utils_wait_to_see "$device_id" 'text="TOP_LEFT"'`
utils_assert_not_null "$o"

uid_dump_window_hierarchy "$device_id" "$xml_name"
xml=`cat "$xml_name"`
scroll_view_v=`uio2_find_object "$xml" 'resource-id="com.example.bashtomatotester:id/scroll_view_v"'`
scroll_view_h=`uio2_find_object "$xml" 'resource-id="com.example.bashtomatotester:id/scroll_view_h"'`

scroll_view_v_has_scroll_view_h=`uio2_has_object "$xml" "$scroll_view_v" 'resource-id="com.example.bashtomatotester:id/scroll_view_h"'`

package_from_object=`uio2_get_application_package "$device_id"`
package_from_object_by_prop=`get_prop "$scroll_view_v" 'package'`

utils_assert_strings_are_equal "$package_from_object" "$package_from_object_by_prop"
utils_assert_true "$scroll_view_v_has_scroll_view_h"

uio2_swipe "$device_id" "$scroll_view_h" "$DIRECTION_LEFT" '80%' 50
o=`utils_wait_to_see "$device_id" 'text="TOP_RIGHT"'`
utils_assert_strings_are_different "$o" ''

uio2_click_with_duration "$device_id" "$o" 5000
uio2_click_and_wait "$device_id" "$o" 5

uio2_swipe "$device_id" "$scroll_view_v" "$DIRECTION_DOWN" '80%' 50
o=`utils_wait_to_see "$device_id" 'text="BOTTOM_RIGHT"'`
utils_assert_strings_are_different "$o" ''

uio2_swipe "$device_id" "$scroll_view_h" "$DIRECTION_RIGHT" '80%' 50
o=`utils_wait_to_see "$device_id" 'text="BOTTOM_LEFT"'`
utils_assert_strings_are_different "$o" ''

uio2_swipe "$device_id" "$scroll_view_v" "$DIRECTION_UP" '80%' 50
o=`utils_wait_to_see "$device_id" 'text="TOP_LEFT"'`
utils_assert_strings_are_different "$o" ''

echo "LOGS"
echo "$BASHTOMATO_LOGS"

echo "***** TEST REACHED END :)"
