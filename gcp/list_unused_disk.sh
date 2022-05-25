
#!/bin/bash
usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [project name]" 1>&2 
  echo "List unused disk"

}
if [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "" ]; then
  usage;
else
    Project_ID="$1"
    gcloud compute disks list --filter="-users:*" --format "value(name,sizeGb,zone,region)"  --project $Project_ID | awk '{gsub(/.+'\\/'/,"",$2);print $0}' | column -s ' ' -t
fi;

