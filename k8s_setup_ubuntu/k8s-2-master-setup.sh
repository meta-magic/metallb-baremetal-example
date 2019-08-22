#!/bin/bash
echo " enter the name of the Container Network Driver Name [calico | flannel | cilium | other]"
read podntwk
podnetwork="--pod-network-cidr=10.217.0.0/16"
if [ "$podntwki" == "calico" ]; then
	podnetwork="--pod-network-cidr=192.168.0.0/16"
elif  [ "$podntwk" == "flannel" ]; then
	podnetwork="--pod-network-cidr=10.244.0.0/16"
elif  [ "$podntwk" == "cilium" ]; then
	podnetwork="--pod-network-cidr=10.217.0.0/16"
fi

echo "Installing K8s Master with $podnetwork for the CNI Driver $podntwk" 
kubeadm init $podnetwork > k8s-master.log
cat k8s-master.log
echo " create folder structure on home dir"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "Before you joing the K8s Worker Node - Install the appropriate CNI Driver using CNI Driver setup script"


