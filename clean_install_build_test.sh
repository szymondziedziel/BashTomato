#!/bin/bash

src_path=src
dist_path=dist
_3rd_path=3rd
unit_tests_path=tests/unit
e2e_tests_path=tests/e2e

# Clean
rm -rf $_3rd_path
mkdir -p $_3rd_path
chmod -R 777 $_3rd_path

rm -rf $dist_path
mkdir -p $dist_path
chmod -R 777 $dist_path

rm -f $e2e_tests_path/temporary_xml_dump.xml


# Install
if [ -f "$_3rd_path/shunit2" ]
then
  mkdir -p $_3rd_path/shunit2
  chmod -R 777 $_3rd_path/shunit2
  echo "shunit2 bash unit tests framework already installed"
else
  git clone https://github.com/kward/shunit2.git $_3rd_path/shunit2
fi


# Build
# Build keycodes sh file for bash 3.2
touch $src_path/keycodes_for_bash_3_2.sh
chmod 777 $src_path/keycodes_for_bash_3_2.sh
echo '#!/bin/bash
' > $src_path/keycodes_for_bash_3_2.sh
cat $src_path/keycodes.sh | grep -E 'KEYCODE\[.+?=' | tr '[]=' ' ' | cut -d ' ' -f 1,2,4 | awk '{printf("%s_%s=%s\n", $1, $2, $3)}' >> $src_path/keycodes_for_bash_3_2.sh

# Build distribution script
touch $dist_path/bashtomato.sh
chmod 777 $dist_path/bashtomato.sh
echo '#!/bin/bash
' > $dist_path/bashtomato.sh

echo "
BASHTOMATO='BASHTOMATO'
BASHTOMATO_LOGS_COUNT=0
BASHTOMATO_LOGS_BUFFER=''
BASHTOMATO_LOGS=\"\`mktemp\`\"
" >> $dist_path/bashtomato.sh

files=(validators helpers keycodes_for_bash_3_2 uidevice uiobject2 utils extensions)
for file in "${files[@]}"
do
  echo "# File: $src_path/$file.sh" >> $dist_path/bashtomato.sh
  cat $src_path/$file.sh | grep '^[^#]' >> $dist_path/bashtomato.sh
  echo "" >> $dist_path/bashtomato.sh
  echo "" >> $dist_path/bashtomato.sh
done

# Build README.md
sh ./generate_readme.sh


# Tests
# Units
echo 'UNIT TESTING utils.sh'
sh ./$unit_tests_path/utils.sh
# echo 'UNIT TESTING validators.sh'
# sh ./$unit_tests_path/validators.sh
# Check if all bashtomato functions has been used
sh ./check_functions_usage.sh
# Run E2E
sh ./tests/e2e/example.sh
# Clean up after build and tests
rm -f $src_path/keycodes_for_bash_3_2.sh
rm -f temporary_xml_dump.xml
