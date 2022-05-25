#!/bin/bash
# Static pods (kind == "Node")
kubectl get pods --all-namespaces -o json | jq -r '.items | map(select(.metadata.ownerReferences[]?.kind == "Node" ) | .metadata.name) | .[]'