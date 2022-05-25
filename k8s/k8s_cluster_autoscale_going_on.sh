kubectl get configmap cluster-autoscaler-status -n kube-system -o yaml
#kubectl annotate node <nodename> cluster-autoscaler.kubernetes.io/scale-down-disabled=true prevent nodescale down
