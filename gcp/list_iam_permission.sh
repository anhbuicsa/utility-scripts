#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List instance in the project"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
  Project_ID="$1"
  gcloud projects get-iam-policy $Project_ID --flatten="bindings[].members" --format="csv(bindings.members,bindings.role)"  --project=${Project_ID} 
    
fi;
