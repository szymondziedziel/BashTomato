#!/bin/bash

SCRIPT_PATH=`dirname ${BASH_SOURCE[0]}`

source "${SCRIPT_PATH}/../../dist/bashtomato.sh"

function setUp() {
  logs_clear
}

function test_logs_clear() {
  BASHTOMATO_LOGS="BASHTOMATO_LOGS"
  assertEquals "$BASHTOMATO_LOGS" 'BASHTOMATO_LOGS'
  logs_clear 
  assertEquals "$BASHTOMATO_LOGS" ''
}

function test_logs_append() {
  logs_append '1'
  logs_append '2'
  logs_append '3'
  assertEquals "$BASHTOMATO_LOGS" '
1
2
3'
}

function test_validators_exit() {
  validators_exit '1' ''
  local actual_exit_status="$?"
  local expected_exit_status='0'
  assertEquals "$expected_exit_status" "$actual_exit_status"
  assertEquals "$BASHTOMATO_LOGS" ''
  result=`validators_exit '2' 'fail_fast'`
  local actual_exit_status="$?"
  local expected_exit_status='1'
  assertEquals "$expected_exit_status" "$actual_exit_status"
  assertEquals "$result" '
2'
}

function remove_logs_time() {
  logs="$1"

  echo "$logs" | cut -d'|' -f2- | sed 's/ //' | sed 's/$/||/' | tr -d '\n'
}



function test_validators_filename_with_extension_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local filename=`echo "$gwtline" | cut -d'&' -f1`
    local extension=`echo "$gwtline" | cut -d'&' -f2`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f3`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f4`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f5`
    validators_filename_with_extension "$filename" "$extension" "$fail_fast" > /dev/null
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"proper-filename_123.test&test&fail_fast&0&||OK | INPUT | function=<validators_filename_with_extension> | filename=<proper-filename_123.test>, extension=<test>, exit=<fail_fast>||OK | OUTPUT | function=<validators_filename_with_extension> | test=<proper-filename_123.test>||
proper-filename_123.test&test&&0&||OK | INPUT | function=<validators_filename_with_extension> | filename=<proper-filename_123.test>, extension=<test>, exit=<>||OK | OUTPUT | function=<validators_filename_with_extension> | test=<proper-filename_123.test>||
proper-/filename._123.test&test&&0&||WARNING | INPUT | function=<validators_filename_with_extension> | filename=<proper-/filename._123.test>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filename=<proper-/filename._123.test> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||
proper-filename_123.tast&test&&0&||WARNING | INPUT | function=<validators_filename_with_extension> | filename=<proper-filename_123.tast>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filename=<proper-filename_123.tast> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||
proper-/filename._123.trst&test&&0&||WARNING | INPUT | function=<validators_filename_with_extension> | filename=<proper-/filename._123.trst>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filename=<proper-/filename._123.trst> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||"
}

function test_validators_filename_with_extension_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local filename=`echo "$gwtline" | cut -d'&' -f1`
    local extension=`echo "$gwtline" | cut -d'&' -f2`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f3`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f4`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f5`
    result=`validators_filename_with_extension "$filename" "$extension" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"proper-/filename._123.test&test&fail_fast&1&||ERROR | INPUT | function=<validators_filename_with_extension> | filename=<proper-/filename._123.test>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filename=<proper-/filename._123.test> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||
proper-filename_123.teest&test&fail_fast&1&||ERROR | INPUT | function=<validators_filename_with_extension> | filename=<proper-filename_123.teest>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filename=<proper-filename_123.teest> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||
proper-/filename._123.tist&test&fail_fast&1&||ERROR | INPUT | function=<validators_filename_with_extension> | filename=<proper-/filename._123.tist>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filename=<proper-/filename._123.tist> does not have extension=<test> or contains not valid characters. Must match /^[a-zA-Z0-9_-]+\.test$/||"
}




function test_validators_directory_invalid_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local directory=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_directory "$directory" "$fail_fast" > /dev/null
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"/valid/path/&fail_fast&0&||OK | INPUT | function=<validators_directory> | directory=</valid/path/>, exit=<fail_fast>||OK | OUTPUT | function=<validators_directory> | test=</valid/path/>||
valid/path/&&0&||OK | INPUT | function=<validators_directory> | directory=<valid/path/>, exit=<>||OK | OUTPUT | function=<validators_directory> | test=<valid/path/>||
/path/to/sth else/&&0&||WARNING | INPUT | function=<validators_directory> | directory=</path/to/sth else/>, exit=<>||WARNING | OUTPUT | Given directory=</path/to/sth else/> is not valid. Must match /^/?([a-zA-Z0-9_\.-]+/?)+$/||"
}

function test_validators_directory_invalid_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local directory=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_directory "$directory" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"/not valid/path/&fail_fast&1&||ERROR | INPUT | function=<validators_directory> | directory=</not valid/path/>, exit=<fail_fast>||ERROR | OUTPUT | Given directory=</not valid/path/> is not valid. Must match /^/?([a-zA-Z0-9_\.-]+/?)+$/||"
}



function test_validators_filepath_with_extension_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local extension=`echo "$gwtline" | cut -d'&' -f2`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f3`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f4`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f5`
    validators_filepath_with_extension "$filepath" "$extension" "$fail_fast" > /dev/null
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"/valid/path/proper-path_123.test&test&fail_fast&0&||OK | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper-path_123.test>, extension=<test>, exit=<fail_fast>||OK | OUTPUT | function=<validators_filepath_with_extension> | test_a=<proper-path_123.test>, test_b=</valid/path>||
/valid/path/proper-path_123.test&test&&0&||OK | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper-path_123.test>, extension=<test>, exit=<>||OK | OUTPUT | function=<validators_filepath_with_extension> | test_a=<proper-path_123.test>, test_b=</valid/path>||
/valid/path/proper/-path _123.test&test&&0&||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper/-path _123.test>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filepath=</valid/path/proper/-path _123.test>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/not valid/path/proper-/path._123.test&test&&0&||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=</not valid/path/proper-/path._123.test>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filepath=</not valid/path/proper-/path._123.test>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/not valid/path/proper-path_123.tast&test&&0&||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=</not valid/path/proper-path_123.tast>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filepath=</not valid/path/proper-path_123.tast>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/valid/path/proper-/path._123.trst&test&&0&||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper-/path._123.trst>, extension=<test>, exit=<>||WARNING | OUTPUT | Given filepath=</valid/path/proper-/path._123.trst>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||"
}

function test_validators_filepath_with_extension_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local extension=`echo "$gwtline" | cut -d'&' -f2`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f3`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f4`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f5`
    result=`validators_filepath_with_extension "$filepath" "$extension" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"/valid/path/proper/-path _123.test&test&fail_fast&1&||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper/-path _123.test>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=</valid/path/proper/-path _123.test>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/not valid/path/proper-/path._123.test&test&fail_fast&1&||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=</not valid/path/proper-/path._123.test>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=</not valid/path/proper-/path._123.test>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/not valid/path/proper-path_123.tast&test&fail_fast&1&||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=</not valid/path/proper-path_123.tast>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=</not valid/path/proper-path_123.tast>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||
/valid/path/proper-/path._123.trst&test&fail_fast&1&||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=</valid/path/proper-/path._123.trst>, extension=<test>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=</valid/path/proper-/path._123.trst>, extension=<test> is not valid. Path must be build from valid directory, filename and extension||"
}



function test_validators_filepath_png_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_filepath_png "$filepath" "$fail_fast" > /dev/null
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"valid/path/to/png/image.png&fail_fast&0&||UNKNOWN | INPUT | function=<validators_filepath_png> | filepath=<valid/path/to/png/image.png>, exit=<fail_fast>||OK | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/png/image.png>, extension=<png>, exit=<fail_fast>||OK | OUTPUT | function=<validators_filepath_with_extension> | test_a=<image.png>, test_b=<valid/path/to/png>||
valid/path/to/png/image.gif&&0&||UNKNOWN | INPUT | function=<validators_filepath_png> | filepath=<valid/path/to/png/image.gif>, exit=<>||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/png/image.gif>, extension=<png>, exit=<>||WARNING | OUTPUT | Given filepath=<valid/path/to/png/image.gif>, extension=<png> is not valid. Path must be build from valid directory, filename and extension||"
}

function test_validators_filepath_png_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_filepath_png "$filepath" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"valid/path/to/png/image.jpeg&fail_fast&1&||UNKNOWN | INPUT | function=<validators_filepath_png> | filepath=<valid/path/to/png/image.jpeg>, exit=<fail_fast>||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/png/image.jpeg>, extension=<png>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=<valid/path/to/png/image.jpeg>, extension=<png> is not valid. Path must be build from valid directory, filename and extension||"
}



function test_validators_filepath_xml_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_filepath_xml "$filepath" "$fail_fast" > /dev/null
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"valid/path/to/xml/image.xml&fail_fast&0&||UNKNOWN | INPUT | function=<validators_filepath_xml> | filepath=<valid/path/to/xml/image.xml>, exit=<fail_fast>||OK | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/xml/image.xml>, extension=<xml>, exit=<fail_fast>||OK | OUTPUT | function=<validators_filepath_with_extension> | test_a=<image.xml>, test_b=<valid/path/to/xml>||
valid/path/to/xml/image.gif&&0&||UNKNOWN | INPUT | function=<validators_filepath_xml> | filepath=<valid/path/to/xml/image.gif>, exit=<>||WARNING | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/xml/image.gif>, extension=<xml>, exit=<>||WARNING | OUTPUT | Given filepath=<valid/path/to/xml/image.gif>, extension=<xml> is not valid. Path must be build from valid directory, filename and extension||"
}

function test_validators_filepath_xml_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local filepath=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_filepath_xml "$filepath" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"valid/path/to/xml/image.jpeg&fail_fast&1&||UNKNOWN | INPUT | function=<validators_filepath_xml> | filepath=<valid/path/to/xml/image.jpeg>, exit=<fail_fast>||ERROR | INPUT | function=<validators_filepath_with_extension> | filepath=<valid/path/to/xml/image.jpeg>, extension=<xml>, exit=<fail_fast>||ERROR | OUTPUT | Given filepath=<valid/path/to/xml/image.jpeg>, extension=<xml> is not valid. Path must be build from valid directory, filename and extension||"
}



# function test_validators_device_id() {
#   res=``
#   actual=``
#   expected=``
# }



function test_validators_node() {
  assertEquals 0 1
}

function test_validators_unsigned_integer_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local unsigned_integer=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_unsigned_integer "$unsigned_integer" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"123&fail_fast&0&||OK | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<123>, exit=<fail_fast>||OK | OUTPUT | function=<validators_unsigned_integer> | test=<123>||
0&&0&||OK | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<0>, exit=<>||OK | OUTPUT | function=<validators_unsigned_integer> | test=<0>||
-45&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<-45>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<-45> is not unsigned integer||
1b1&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1b1>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1b1> is not unsigned integer||
a1a&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<a1a>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<a1a> is not unsigned integer||
000123&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<000123>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<000123> is not unsigned integer||
1e14000123&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1e14000123>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1e14000123> is not unsigned integer||
1.25&&0&||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1.25> is not unsigned integer||"
}

function test_validators_unsigned_integer_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local unsigned_integer=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_unsigned_integer "$unsigned_integer" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"1b1&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1b1>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1b1> is not unsigned integer||
-45&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<-45>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<-45> is not unsigned integer||
a1a&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<a1a>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<a1a> is not unsigned integer||
000123&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<000123>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<000123> is not unsigned integer||
1e14000123&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1e14000123>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1e14000123> is not unsigned integer||
1.25&fail_fast&1&||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1.25> is not unsigned integer||"
}



function test_validators_integer_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local integer=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_integer "$integer" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"123&fail_fast&0&||OK | INPUT | function=<validators_integer> | integer=<123>, exit=<fail_fast>||OK | OUTPUT | function=<validators_integer> | test=<123>||
-45&&0&||OK | INPUT | function=<validators_integer> | integer=<-45>, exit=<>||OK | OUTPUT | function=<validators_integer> | test=<-45>||
0&&0&||OK | INPUT | function=<validators_integer> | integer=<0>, exit=<>||OK | OUTPUT | function=<validators_integer> | test=<0>||
1b1&&0&||WARNING | INPUT | function=<validators_integer> | integer=<1b1>, exit=<>||WARNING | OUTPUT | Given integer=<1b1> is not integer||
a1a&&0&||WARNING | INPUT | function=<validators_integer> | integer=<a1a>, exit=<>||WARNING | OUTPUT | Given integer=<a1a> is not integer||
000123&&0&||WARNING | INPUT | function=<validators_integer> | integer=<000123>, exit=<>||WARNING | OUTPUT | Given integer=<000123> is not integer||
1e14000123&&0&||WARNING | INPUT | function=<validators_integer> | integer=<1e14000123>, exit=<>||WARNING | OUTPUT | Given integer=<1e14000123> is not integer||
1.25&&0&||WARNING | INPUT | function=<validators_integer> | integer=<1.25>, exit=<>||WARNING | OUTPUT | Given integer=<1.25> is not integer||"
}

function test_validators_integer_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local integer=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_integer "$integer" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"1b1&fail_fast&1&||ERROR | INPUT | function=<validators_integer> | integer=<1b1>, exit=<fail_fast>||ERROR | OUTPUT | Given integer=<1b1> is not integer||
a1a&fail_fast&1&||ERROR | INPUT | function=<validators_integer> | integer=<a1a>, exit=<fail_fast>||ERROR | OUTPUT | Given integer=<a1a> is not integer||
000123&fail_fast&1&||ERROR | INPUT | function=<validators_integer> | integer=<000123>, exit=<fail_fast>||ERROR | OUTPUT | Given integer=<000123> is not integer||
1e14000123&fail_fast&1&||ERROR | INPUT | function=<validators_integer> | integer=<1e14000123>, exit=<fail_fast>||ERROR | OUTPUT | Given integer=<1e14000123> is not integer||
1.25&fail_fast&1&||ERROR | INPUT | function=<validators_integer> | integer=<1.25>, exit=<fail_fast>||ERROR | OUTPUT | Given integer=<1.25> is not integer||"
}



# 
# function test_validators_percent() {
#   res=``
#   actual=``
#   expected=``
# }
# 



function test_validators_seconds_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local seconds=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_seconds "$seconds" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"1&fail_fast&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1>, exit=<fail_fast>||OK | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1>, exit=<fail_fast>||OK | OUTPUT | function=<validators_unsigned_integer> | test=<1>||
0&fail_fast&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<0>, exit=<fail_fast>||OK | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<0>, exit=<fail_fast>||OK | OUTPUT | function=<validators_unsigned_integer> | test=<0>||
-45&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<-45>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<-45>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<-45> is not unsigned integer||
1s&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1s>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1s>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1s> is not unsigned integer||
time1&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<time1>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<time1>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<time1> is not unsigned integer||
000123&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<000123>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<000123>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<000123> is not unsigned integer||
1sec&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1sec>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1sec>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1sec> is not unsigned integer||
1second&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1second>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1second>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1second> is not unsigned integer||
2seconds&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<2seconds>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<2seconds>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<2seconds> is not unsigned integer||
1.25&&0&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1.25>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1.25> is not unsigned integer||"
}

function test_validators_seconds_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local seconds=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_seconds "$seconds" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"-45&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<-45>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<-45>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<-45> is not unsigned integer||
1s&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1s>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1s>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1s> is not unsigned integer||
time1&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<time1>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<time1>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<time1> is not unsigned integer||
000123&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<000123>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<000123>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<000123> is not unsigned integer||
1sec&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1sec>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1sec>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1sec> is not unsigned integer||
1second&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1second>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1second>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1second> is not unsigned integer||
2seconds&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<2seconds>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<2seconds>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<2seconds> is not unsigned integer||
1.25&fail_fast&1&||UNKNOWN | INPUT | function=<validators_seconds> | seconds=<1.25>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1.25> is not unsigned integer||"
}



function test_validators_milliseconds_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local milliseconds=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_milliseconds "$milliseconds" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"1000&fail_fast&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1000>, exit=<fail_fast>||OK | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1000>, exit=<fail_fast>||OK | OUTPUT | function=<validators_unsigned_integer> | test=<1000>||
1500a&&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1500a>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1500a>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1500a> is not unsigned integer||
1500ms&&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1500ms>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1500ms>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1500ms> is not unsigned integer||
1E50millis&&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1E50millis>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1E50millis>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1E50millis> is not unsigned integer||
0001000&&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<0001000>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<0001000>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<0001000> is not unsigned integer||
1.25s&&0&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1.25s>, exit=<>||WARNING | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25s>, exit=<>||WARNING | OUTPUT | Given unsigned_integer=<1.25s> is not unsigned integer||"
}

function test_validators_milliseconds_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local milliseconds=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_milliseconds "$milliseconds" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"1500a&fail_fast&1&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1500a>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1500a>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1500a> is not unsigned integer||
1500ms&fail_fast&1&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1500ms>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1500ms>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1500ms> is not unsigned integer||
1E50millis&fail_fast&1&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1E50millis>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1E50millis>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1E50millis> is not unsigned integer||
0001000&fail_fast&1&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<0001000>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<0001000>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<0001000> is not unsigned integer||
1.25s&fail_fast&1&||UNKNOWN | INPUT | function=<validators_milliseconds> | milliseconds=<1.25s>, exit=<fail_fast>||ERROR | INPUT | function=<validators_unsigned_integer> | unsigned_integer=<1.25s>, exit=<fail_fast>||ERROR | OUTPUT | Given unsigned_integer=<1.25s> is not unsigned integer||"
}



function test_validators_bounds_name_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local bound_name=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_bounds_name "$bound_name" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"top&fail_fast&0&||OK | INPUT | function=<validators_bounds_name> | bound_name=<top>, exit=<fail_fast>||OK | OUTPUT | function=<validators_bounds_name> | test=<top>||
right&fail_fast&0&||OK | INPUT | function=<validators_bounds_name> | bound_name=<right>, exit=<fail_fast>||OK | OUTPUT | function=<validators_bounds_name> | test=<right>||
bottom&fail_fast&0&||OK | INPUT | function=<validators_bounds_name> | bound_name=<bottom>, exit=<fail_fast>||OK | OUTPUT | function=<validators_bounds_name> | test=<bottom>||
left&fail_fast&0&||OK | INPUT | function=<validators_bounds_name> | bound_name=<left>, exit=<fail_fast>||OK | OUTPUT | function=<validators_bounds_name> | test=<left>||
aright&&0&||WARNING | INPUT | function=<validators_bounds_name> | bound_name=<aright>, exit=<>||WARNING | OUTPUT | Given bound_name=<aright> is not valid. Only top, right, bottom, left are allowed||
center&&0&||WARNING | INPUT | function=<validators_bounds_name> | bound_name=<center>, exit=<>||WARNING | OUTPUT | Given bound_name=<center> is not valid. Only top, right, bottom, left are allowed||
middle&&0&||WARNING | INPUT | function=<validators_bounds_name> | bound_name=<middle>, exit=<>||WARNING | OUTPUT | Given bound_name=<middle> is not valid. Only top, right, bottom, left are allowed||
custom&&0&||WARNING | INPUT | function=<validators_bounds_name> | bound_name=<custom>, exit=<>||WARNING | OUTPUT | Given bound_name=<custom> is not valid. Only top, right, bottom, left are allowed||
other&&0&||WARNING | INPUT | function=<validators_bounds_name> | bound_name=<other>, exit=<>||WARNING | OUTPUT | Given bound_name=<other> is not valid. Only top, right, bottom, left are allowed||"
}

function test_validators_bounds_name_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local bound_name=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_bounds_name "$bound_name" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"aright&fail_fast&1&||ERROR | INPUT | function=<validators_bounds_name> | bound_name=<aright>, exit=<fail_fast>||ERROR | OUTPUT | Given bound_name=<aright> is not valid. Only top, right, bottom, left are allowed||
center&fail_fast&1&||ERROR | INPUT | function=<validators_bounds_name> | bound_name=<center>, exit=<fail_fast>||ERROR | OUTPUT | Given bound_name=<center> is not valid. Only top, right, bottom, left are allowed||
middle&fail_fast&1&||ERROR | INPUT | function=<validators_bounds_name> | bound_name=<middle>, exit=<fail_fast>||ERROR | OUTPUT | Given bound_name=<middle> is not valid. Only top, right, bottom, left are allowed||
custom&fail_fast&1&||ERROR | INPUT | function=<validators_bounds_name> | bound_name=<custom>, exit=<fail_fast>||ERROR | OUTPUT | Given bound_name=<custom> is not valid. Only top, right, bottom, left are allowed||
other&fail_fast&1&||ERROR | INPUT | function=<validators_bounds_name> | bound_name=<other>, exit=<fail_fast>||ERROR | OUTPUT | Given bound_name=<other> is not valid. Only top, right, bottom, left are allowed||"
}



function test_validators_direction_no_exit() {
  while read -r gwtline
  do
    logs_clear
    local direction=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    validators_direction "$direction" "$fail_fast"
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$BASHTOMATO_LOGS"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"UP&fail_fast&0&||OK | INPUT | function=<validators_direction> | direction=<UP>, exit=<fail_fast>||OK | OUTPUT | function=<validators_direction> | test=<UP>||
RIGHT&fail_fast&0&||OK | INPUT | function=<validators_direction> | direction=<RIGHT>, exit=<fail_fast>||OK | OUTPUT | function=<validators_direction> | test=<RIGHT>||
DOWN&fail_fast&0&||OK | INPUT | function=<validators_direction> | direction=<DOWN>, exit=<fail_fast>||OK | OUTPUT | function=<validators_direction> | test=<DOWN>||
LEFT&fail_fast&0&||OK | INPUT | function=<validators_direction> | direction=<LEFT>, exit=<fail_fast>||OK | OUTPUT | function=<validators_direction> | test=<LEFT>||
aright&&0&||WARNING | INPUT | function=<validators_direction> | direction=<aright>, exit=<>||WARNING | OUTPUT | Given direction=<aright> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
center&&0&||WARNING | INPUT | function=<validators_direction> | direction=<center>, exit=<>||WARNING | OUTPUT | Given direction=<center> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
middle&&0&||WARNING | INPUT | function=<validators_direction> | direction=<middle>, exit=<>||WARNING | OUTPUT | Given direction=<middle> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
custom&&0&||WARNING | INPUT | function=<validators_direction> | direction=<custom>, exit=<>||WARNING | OUTPUT | Given direction=<custom> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
other&&0&||WARNING | INPUT | function=<validators_direction> | direction=<other>, exit=<>||WARNING | OUTPUT | Given direction=<other> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||"
}

function test_validators_direction_force_exit() {
  while read -r gwtline
  do
    logs_clear
    local direction=`echo "$gwtline" | cut -d'&' -f1`
    local fail_fast=`echo "$gwtline" | cut -d'&' -f2`
    local expected_exit_status=`echo "$gwtline" | cut -d'&' -f3`
    local expected_logs=`echo "$gwtline" | cut -d'&' -f4`
    result=`validators_direction "$direction" "$fail_fast"`
    local actual_exit_status="$?"

    local current_logs=`remove_logs_time "$result"`

    assertEquals "$expected_exit_status" "$actual_exit_status"
    assertEquals "$current_logs" "$expected_logs"
  done<<<"aright&fail_fast&1&||ERROR | INPUT | function=<validators_direction> | direction=<aright>, exit=<fail_fast>||ERROR | OUTPUT | Given direction=<aright> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
center&fail_fast&1&||ERROR | INPUT | function=<validators_direction> | direction=<center>, exit=<fail_fast>||ERROR | OUTPUT | Given direction=<center> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
middle&fail_fast&1&||ERROR | INPUT | function=<validators_direction> | direction=<middle>, exit=<fail_fast>||ERROR | OUTPUT | Given direction=<middle> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
custom&fail_fast&1&||ERROR | INPUT | function=<validators_direction> | direction=<custom>, exit=<fail_fast>||ERROR | OUTPUT | Given direction=<custom> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||
other&fail_fast&1&||ERROR | INPUT | function=<validators_direction> | direction=<other>, exit=<fail_fast>||ERROR | OUTPUT | Given direction=<other> is not valid. Only UP, RIGHT, DOWN, LEFT are allowed||"
}

# Load shUnit2.
. "${SCRIPT_PATH}/../../3rd/shunit2/shunit2"
