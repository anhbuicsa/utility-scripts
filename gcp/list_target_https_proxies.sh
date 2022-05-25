#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name] [vpc name]" 1>&2 
  echo "List target-https-proxies"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
    gcloud beta compute target-https-proxies list --project=$Project_ID --format json
fi;
