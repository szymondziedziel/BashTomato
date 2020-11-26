#!/bin/bash

BASHTOMATO_PATH=`dirname ${BASH_SOURCE[0]}`

if [ -f "$BASHTOMATO_PATH/keycodes_for_bash_3_2.sh" ]
then
  source "$BASHTOMATO_PATH/keycodes_for_bash_3_2.sh"
else
  echo 'Unfortunalety bashtomato uses non-existing file keycodes_for_bash_3_2.sh from src directory. This file is autogenerated by executing "sh clean_install_build_test.sh" from root of project. The "sh clean_install_build_test.sh" will also execute tests and build other production needed things. You can use BashTomato without generating this file, but named KEYCODES will not be available. It is recommended to run "sh clean_install_build_test.sh" and use bashtopato.sh from dist.'
fi

source "$BASHTOMATO_PATH/helpers.sh"
source "$BASHTOMATO_PATH/uiobject2.sh"
source "$BASHTOMATO_PATH/uidevice.sh"
source "$BASHTOMATO_PATH/utils.sh"
source "$BASHTOMATO_PATH/extensions.sh"
