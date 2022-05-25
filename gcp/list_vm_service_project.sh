#!/bin/bash
HPROJECT="$1"
for x in $(gcloud compute shared-vpc list-associated-resources $HPROJECT --format="csv(RESOURCE_ID)" | tail +2)
do 
  gcloud compute instances list --project $x --format="csv(NAME,INTERNAL_IP)" | tail +2 | sed s/^/$x\,/g
done
