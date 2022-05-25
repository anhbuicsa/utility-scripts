#!/bin/bash
usage() {                                  
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [organization_ID] [BucketName]" 1>&2 
  echo "Get project of bucket"
}
usage;
projectNumber="$1"
if [ -z "$projectNumber" ]; then
  echo "Insert projectNumber:"
  read projectNumber
fi;
gcloud projects list  --format="json" | jq -r '.[] | select(.projectNumber == '\"$projectNumber\"')|{projectNumber:.projectNumber,projectId:.projectId}'

