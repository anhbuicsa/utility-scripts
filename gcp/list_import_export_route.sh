#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List import/export routes in the project"

}
regions=("asia-east1" "asia-southeast1")
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
  Project_ID="$1"
    gcloud compute networks peerings list --project=${Project_ID} --format=json  
fi;


