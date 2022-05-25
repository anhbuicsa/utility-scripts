
#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [organization_ID] [BucketName]" 1>&2 
  echo "Get project of bucket"
}
usage;
organization_ID="$1"
BucketName="$2"
if [ -z "$BucketName" ]; then
  echo "Insert bucket name:"
  read BucketName
fi;
echo "Bucket: $BucketName"
projectNumber=$(gcloud beta asset search-all-resources --scope=organizations/$organization_ID --query=$BucketName --format json | jq '.[].project' | awk -F'/' '{gsub(/"/,"",$2);print $2}')
echo "projectNumber: $projectNumber"
if [ -n "$projectNumber" ]; then
  gcloud projects list  --format="json" | jq -r '.[] | select(.projectNumber == '\"$projectNumber\"')|{projectNumber:.projectNumber,projectId:.projectId}'
fi;
# gcloud config set project
