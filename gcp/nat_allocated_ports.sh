#!/bin/bash

PROJECT=$1
usage() {  
  scriptname=`basename $0`                                     
  echo "Usage: $scriptname [ projectname ]" 1>&2
  echo "check number of port per IPs" 
}
usage;
echo $PROJECT
gcloud compute routers get-nat-mapping-info nat --project $PROJECT --region asia-east1 --format json | jq -r '.[].interfaceNatMappings[] | (.natIpPortRanges )'  | tr ',"' '\n' | sort -u| awk -F':' '$0 ~ /[0-9]/ {split($2,a,"-"); print $1 , a[2]-a[1]+1}' | awk 'NR>0{portnumber[$1]+=$2; next} END{for (i in portnumber) print "    ",i,portnumber[i]}' | sort -k2 -r