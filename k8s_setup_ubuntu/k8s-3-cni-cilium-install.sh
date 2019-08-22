#!/bin/bash
echo " installing cilium driver"
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/kubernetes/1.14/cilium.yaml
echo " Run kubectl get pods --all-namespaces to check and verify the pods status"
