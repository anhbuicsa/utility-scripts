#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List primary, secondary ranges of vpc"

}
regions=("asia-east1" "asia-southeast1")
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ] ; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
    for region in "${regions[@]}"; do                      
      gcloud beta redis instances list -q --region=${region} --project=${Project_ID} --format="csv[no-heading](displayName,locationId,redisVersion,host,reservedIpRange,tier,memorySizeGb)" | sed 's|^|'${project_id}',|g'
    done 

fi;
