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
  gcloud compute instances list -q --project=${Project_ID} --format="csv[no-heading](selfLink,MACHINE_TYPE,ZONE,EXTERNAL_IP,INTERNAL_IP,tags.items, STATUS)" | awk -F'/' '{print $7","$NF}' | sed 's|, |; |g' | sed 's|;|; |g'  
    
fi;


