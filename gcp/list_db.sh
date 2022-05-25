#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List db in the project"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
     gcloud sql instances list -q --project=${Project_ID} --format="csv[no-heading](selfLink,TIER,LOCATION,PRIMARY_ADDRESS,PRIVATE_ADDRESS)" | awk -F'/' '{print $7","$NF}' | sed 's|, |; |g' 
fi;



  
