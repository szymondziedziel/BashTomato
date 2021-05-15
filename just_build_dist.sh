#!/bin/bash

src_path=src
dist_path=dist

# Build
# Build keycodes sh file for bash 3.2
mkdir -p $dist_path
chmod -R 777 $dist_path

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
BASHTOMATO_VERSION='0.1.0'
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
