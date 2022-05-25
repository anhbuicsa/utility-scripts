#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name] [vpc name]" 1>&2 
  echo "List peer dns domain, e.g cloud build worker"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
    gcloud beta services peered-dns-domains list --network=main --project=$Project_ID
fi;