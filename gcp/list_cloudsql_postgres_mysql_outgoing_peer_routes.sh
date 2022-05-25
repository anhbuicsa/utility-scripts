#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List peering outgoing in the projects"

}
regions=("asia-east1" "asia-southeast1")
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    #echo $Config_File
  Project_ID="$1"
    for region in "${regions[@]}"; do                      
       gcloud compute networks peerings list-routes cloudsql-postgres-googleapis-com --network=main --region=$region --project=${Project_ID}  --direction outgoing
    done 
  fi;


