#!/bin/sh
echo "update software repositry"
apt-get -y update
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
echo "install docker repo"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get -y update
echo "Installing docker"
apt-get -y install docker-ce
#docker run hello-world
groupadd docker
echo "installing kubernetes"
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main"  > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
sed '10 i\Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"'  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
echo " Installation complete !!!! Reboot the system"
