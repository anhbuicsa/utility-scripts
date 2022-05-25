#!/bin/bash
#!/bin/bash
usage() {                                  
  scriptname=`basename $0`  
  echo "Usage: $scriptname" 1>&2 
  echo "K8s Context IP"
}
usage;
CLUSTER=`kubectl config current-context`
CLUSTER_IP=`kubectl config view -o json | jq --arg CLUSTER "$CLUSTER" '.clusters[]| select(.name==$CLUSTER)'`
if [ -n "$CLUSTER" ]; then
   echo "$CLUSTER_IP"
else
  echo "[$CLUSTER] context has been not get."
fi;
