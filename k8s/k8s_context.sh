#!/bin/bash
usage() {                                  
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [key_word_1] [key_word_2]" 1>&2 
  echo "Switch Context"
}
usage;
K8S_CONTEXT="$1"
if [[ $K8S_CONTEXT == *"/"* ]]; then
    K8S_CONTEXT=${K8S_CONTEXT::-1}
fi

K8S_CONTEXTS=`kubectl config get-contexts | tr ' ' '\n' | sort -u`
for FILE_CONF in "$@"; do
    #echo "FILE_CONF $FILE_CONF"
    if [ -n "$FILE_CONF" ]; then
     K8S_CONTEXTS=`echo -e "$K8S_CONTEXTS" | egrep -i "$FILE_CONF"`
    fi;
done
K8S_CONTEXT="$K8S_CONTEXTS"
LIST_K8S_CONTEXT=`echo -e "$K8S_CONTEXTS"  | awk '{print $0 ":  "NR}'`
NUMBER_FILES=`echo "$LIST_K8S_CONTEXT" | wc -l`
if [ "$NUMBER_FILES" -gt 1 ]; then
    echo -e "$LIST_K8S_CONTEXT" 
	echo ""
    echo "select a line number:"
	read NUMBER
    echo "You've done with:"
    if [ -z "$NUMBER" ]; then
	   NUMBER=1
	   echo $NUMBER
	fi;
	echo $NUMBER
  K8S_CONTEXT=`echo "$LIST_K8S_CONTEXT" | awk -F':' -v NUMBER="$NUMBER" ' $2 == NUMBER {print $1}'`
fi;
if [ -n "$K8S_CONTEXT" ]; then
    echo -e "switch context [$K8S_CONTEXT]"
    kubectl config use-context "$K8S_CONTEXT" 
else
    echo "Please input the cluster information [name]"
fi;