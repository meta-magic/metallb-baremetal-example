#!/bin/bash
echo " installing fannel driver"
kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
echo " Run kubectl get pods --all-namespaces to check and verify the pods status"

