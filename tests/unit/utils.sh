#!/bin/bash

SCRIPT_PATH=`dirname ${BASH_SOURCE[0]}`

source "${SCRIPT_PATH}/../../dist/bashtomato.sh"



function test_utils_assert_null_with_undeclared() {
  res=`utils_assert_null "$undeclared"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_null_with_empty_string() {
  value=''
  res=`utils_assert_null "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_null_with_non_empty_string() {
  value='<node attr="some">'
  res=`utils_assert_null "$value"`
  actual="$?"
  expected=1

  assertEquals $expected $actual
}

function test_utils_assert_null_with_zero_number() {
  value=0
  res=`utils_assert_null "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_null_with_non_zero_number() {
  value=100
  res=`utils_assert_null "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}



function test_utils_assert_not_null_with_undeclared() {
  res=`utils_assert_not_null "$undeclared"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_not_null_with_empty_string() {
  value=''
  res=`utils_assert_not_null "$value"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_not_null_with_non_empty_string() {
  value='<node attr="some">'
  res=`utils_assert_not_null "$value"`
  actual="$?"
  expected=0

  assertEquals $expected $actual
}

function test_utils_assert_not_null_with_zero_number() {
  value=0
  res=`utils_assert_not_null "$value"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_not_null_with_non_zero_number() {
  value=100
  res=`utils_assert_not_null "$value"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_true_with_undeclared() {
  res=`utils_assert_true "$undeclared"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_true_with_empty_string() {
  value=''
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_true_with_non_empty_string() {
  value='<node attr="some">'
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=1

  assertEquals $expected $actual
}

function test_utils_assert_true_with_zero_number() {
  value=0
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_true_with_non_zero_number() {
  value=100
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_true_with_string_true() {
  value="$TRUE"
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_true_with_string_false() {
  value="$FALSE"
  res=`utils_assert_true "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}



function test_utils_assert_false_with_undeclared() {
  res=`utils_assert_false "$undeclared"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_false_with_empty_string() {
  value=''
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_false_with_non_empty_string() {
  value='<node attr="some">'
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=1

  assertEquals $expected $actual
}

function test_utils_assert_false_with_zero_number() {
  value=0
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_false_with_non_zero_number() {
  value=100
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_false_with_string_true() {
  value="$TRUE"
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_false_with_string_false() {
  value="$FALSE"
  res=`utils_assert_false "$value"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_strings_are_equal_with_both_undeclared() {
  res=`utils_assert_strings_are_equal "$undeclared" "$undeclared2"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_equal_with_undeclared_and_empty() {
  value_a=''
  res=`utils_assert_strings_are_equal "$value_a" "$undeclared2"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_equal_with_same_strings() {
  value_a='test string'
  value_b=$value_a
  res=`utils_assert_strings_are_equal "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_equal_with_different_strings() {
  value_a='test string'
  value_b='test string2'
  res=`utils_assert_strings_are_equal "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_equal_with_same_string_and_number() {
  value_a='100'
  value_b=100
  res=`utils_assert_strings_are_equal "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_strings_are_different_with_both_undeclared() {
  res=`utils_assert_strings_are_different "$undeclared" "$undeclared2"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_different_with_undeclared_and_empty() {
  value_a=''
  res=`utils_assert_strings_are_different "$value_a" "$undeclared2"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_different_with_same_strings() {
  value_a='test string'
  value_b=$value_a
  res=`utils_assert_strings_are_different "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_different_with_different_strings() {
  value_a='test string'
  value_b='test string2'
  res=`utils_assert_strings_are_different "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_strings_are_different_with_same_string_and_number() {
  value_a='100'
  value_b=100
  res=`utils_assert_strings_are_different "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_less_than_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_less_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_less_than_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_less_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_less_than_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_less_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_less_or_equal_than_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_less_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_less_or_equal_than_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_less_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_less_or_equal_than_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_less_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_equals_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_equals_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_equals_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_equals_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_equals_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_equals_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_greater_or_equal_than_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_greater_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_greater_or_equal_than_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_greater_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_greater_or_equal_than_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_greater_or_equal_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_greater_than_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_greater_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_greater_than_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_greater_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_greater_than_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_greater_than_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}



function test_utils_assert_numbers_first_is_not_equal_to_second_ok() {
  value_a=0
  value_b=100
  res=`utils_assert_numbers_first_is_not_equal_to_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_is_not_equal_to_second_inverted() {
  value_a=100
  value_b=1
  res=`utils_assert_numbers_first_is_not_equal_to_second "$value_a" "$value_b"`
  actual="$?"
  expected=0
  assertEquals $expected $actual
}

function test_utils_assert_numbers_first_is_not_equal_to_second_same() {
  value_a=100
  value_b=100
  res=`utils_assert_numbers_first_is_not_equal_to_second "$value_a" "$value_b"`
  actual="$?"
  expected=1
  assertEquals $expected $actual
}

# Load shUnit2.
. "${SCRIPT_PATH}/../../3rd/shunit2/shunit2"
