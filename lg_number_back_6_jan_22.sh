#!/bin/bash
#SUFFIX=`date +%Y-%m-%d`
TMP_DIR="/Users/anhbv2/Documents/"
#FILEN="$TMP_DIR""$SUFFIX"".txt"
FILEN="$TMP_DIR""dirs"".txt"
FIND_DIRS=$(cat <<-END
	/Users/anhbv2/Documents/Workspace/Workings
	/Users/anhbv2/Documents/Workspace/notes
END
)
FIND_DIRS=`echo -e "$FIND_DIRS" | awk '{gsub(/^[[:space:]]+|[[:space:]]+$/,"",$0); print $0}'`
echo -e "$FIND_DIRS"
if [ ! -f "$FILEN" ]; then
  echo "[Warning] Library file not found! Creating library file"
	touch "$FILEN"
	mkdir -p "$TMP_DIR"
	for FIND_DIR in $FIND_DIRS; do
        find $FIND_DIR  \( -type d -name ".git" -or -type f -name "backend.tf" \) 2>/dev/null | awk -F"/" 'BEGIN{OFS="/"}{$NF="";print $0}' 2>/dev/null | egrep -v "\.terraform" |sed 's/\/$//g' >> 	"$FILEN"
	done
fi
FILE_CONFIG="$1"
if [[ $FILE_CONFIG == *"/"* ]]; then
    FILE_CONFIG=${FILE_CONFIG::-1}
fi

FILE_CONFIGS=`cat "$FILEN"`

#echo -e "$FILE_CONFIGS"
for FILE_CONF in "$@"; do
    #echo "FILE_CONF $FILE_CONF"
    if [ -n "$FILE_CONF" ]; then
     FILE_CONFIGS=`echo -e "$FILE_CONFIGS" | awk -F'/' -v FILE_CONF="$FILE_CONF" '$NF ~ FILE_CONF {print $0}' | sort -u`
    fi;
done
FILE_CONFIG="$FILE_CONFIGS"
LIST_FILES=`echo -e "$FILE_CONFIGS"  | awk '{print $0 ":  "NR}'`
NUMBER_FILES=`echo "$LIST_FILES" | wc -l`
if [ "$NUMBER_FILES" -gt 1 ]; then
    echo "$LIST_FILES" | awk -F'/' '{print $NF}'
		echo ""
    echo "select a line number:"
	read NUMBER
    if [ -z "$NUMBER" ]; then
	   NUMBER=1
	   echo $NUMBER
	fi;
	echo $NUMBER
  FILE_CONFIG=`echo "$LIST_FILES" | awk -F':' -v NUMBER="$NUMBER" ' $2 == NUMBER {print $1}'`
fi;
if [ -n "$FILE_CONFIG" ]; then
    echo -e "open folder [\033[0;96m $FILE_CONFIG\033[0m] "  
	open -a Visual\ Studio\ Code.app $FILE_CONFIG
else
	MESSAGE=$(cat <<-END
		[Warning] We cannot search the correct repo please follow the below steps:
		   - Delete \033[0;96m [ $FILEN ]\033[0m file  
		   - Ensure your searching reposiptory contains .git  directory
		   - Add more searched dir in [FIND_DIRS] environment as [$FIND_DIRS].
	END
	)
		echo -e "$MESSAGE"
fi;

