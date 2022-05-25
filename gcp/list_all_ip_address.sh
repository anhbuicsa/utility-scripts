#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List primary, secondary ranges of vpc"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
    gcloud compute addresses list --project=$Project_ID
fi;