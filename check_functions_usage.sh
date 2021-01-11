functions=`cat ./dist/bashtomato.sh | grep '^function ' | tr '()' ' ' | cut -d ' ' -f2`
all_count=`echo -e "$functions" | wc -l`
functions=($functions)

unused=''
for f in "${functions[@]}"
do
  is_used=`cat ./tests/e2e/example.sh | grep "$f"`

  if [ -z "$is_used" ]
  then
    if [ -z "$unused" ]
    then
      unused="$f"
    else
      unused="$unused
$f"
    fi
  fi
done

echo "$unused"
unused_count=`echo -e "$unused" | wc -l`

echo "Unused functions $unused_count of $all_count."
