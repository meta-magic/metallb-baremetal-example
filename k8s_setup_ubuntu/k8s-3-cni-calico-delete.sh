#!/bin/bash
echo " installing calico driver"
kubectl delete -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
echo " Run kubectl get pods --all-namespaces to check and verify the pods status"
