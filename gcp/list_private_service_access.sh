#!/bin/bash
usage() {
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name] [vpc name]" 1>&2 
  echo "List peer dns domain, e.g cloud build worker"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    Project_ID="$1"
    network="$2"
    gcloud services vpc-peerings list --network=main --project=$Project_ID --format json
fi;
