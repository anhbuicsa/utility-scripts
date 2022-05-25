#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List Load balancer"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
    Project_ID="$1"
     gcloud compute forwarding-rules list -q --project=${Project_ID} --format="csv[no-heading](selfLink,REGION,IP_ADDRESS)" | awk -F'/' '{print $7","$8$(NF-1)","$NF}' | awk 'BEGIN{FS=OFS=","} {t = $2; $2 = $3; $3 = t; print;}'     
fi;





