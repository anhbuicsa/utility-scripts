#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List subnet,... servicenetworking-googleapis-com in the project"

}
regions=("asia-east1" "asia-southeast1")
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
  Project_ID="$1"
    gcloud alpha compute networks list-ip-addresses main --project=${Project_ID} --format=json  
fi;


