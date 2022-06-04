#!/bin/bash
FILE_CONFIG="$1"
if [[ $FILE_CONFIG == *"/"* ]]; then
    FILE_CONFIG=${FILE_CONFIG::-1}
fi

FILE_CONFIGS=`ls`
for FILE_CONF in "${@:1}"; do
    #echo "FILE_CONF $FILE_CONF"
    if [ -n "$FILE_CONF" ]; then
     FILE_CONFIGS=`echo -e "$FILE_CONFIGS" | egrep -i "$FILE_CONF"`
    fi;
done
FILE_CONFIG="$FILE_CONFIGS"
LIST_FILES=`echo -e "$FILE_CONFIGS"  | awk '{print $0 ":  "NR}'`
NUMBER_FILES=`echo "$LIST_FILES" | wc -l`
if [ "$NUMBER_FILES" -gt 1 ]; then
    echo "$LIST_FILES" | awk -F'/' '{print $(NF-1) ": " NR}'
		echo ""
    echo "select a line number:"
	read NUMBER
    echo "You've done with:"
    if [ -z "$NUMBER" ]; then
	   NUMBER=1
	   echo $NUMBER
	fi;
	echo $NUMBER
  FILE_CONFIG=`echo "$LIST_FILES" | awk -F':' -v NUMBER="$NUMBER" ' $2 == NUMBER {print $1}'`
fi;
if [ -n "$FILE_CONFIG" ]; then
    echo "open folder [$FILE_CONFIG]"
    code $FILE_CONFIG
else
    echo "Folder not found! Please input the folder information [name]"
fi;