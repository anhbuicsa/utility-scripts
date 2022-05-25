#!/bin/bash
host_project="$1"
project_list=`gcloud compute shared-vpc list-associated-resources  "$host_project" | awk -F':' '$1 ~ /RESOURCE_ID/ {gsub(/[ \t]/,"",$2);print $2}'`
for project_id in $project_list
do
#echo "--------" $project_id
gcloud compute instances list -q --project=${project_id} \
--format="csv[no-heading](networkInterfaces.subnetwork,networkInterfaces.aliasIpRanges.subnetworkRangeName)" | \
awk -F',' '$1 ~ /\/'"$host_project"'\// {gsub(/^.+\//,"",$1);print $0}' | tr -d \'\"\[\]
done | sort -u 
