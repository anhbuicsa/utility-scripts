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
    gcloud compute networks subnets list --project="$Project_ID" --filter="secondaryIpRanges:*" --format=json | jq 'map( {selfLink} as $selfLink | .secondaryIpRanges[]? | select(.rangeName | startswith("gke-pods")) | $selfLink + . )' | jq '.[] | .selfLink + "," +.rangeName + "," + .ipCidrRange' | sed 's|https://www.googleapis.com/compute/v1/projects/||g' | sed 's|/regions/|,|g' | sed 's|/subnetworks/|,|g' | sed 's|"||g'

fi;
