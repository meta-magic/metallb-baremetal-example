## setup used for demo in ubuntu 18.04

## Introduction
NFS, or Network File System, is a distributed file system protocol that allows you to mount remote directories on your server. This lets you manage storage space in a different location and write to that space from multiple clients. 



  # For Further reference 
 nfs: 192.168.2.13  ----------> nfs server
Client:  192.168.2.15 --------> nodes

note: replace these values with your own server and client ip addresses.

## nfs-server setup
1) install the nfs-kernel-server package 
```bash
$ sudo apt-get update
```
```bash
$ sudo apt-get install nfs-kernel-server
```
2) Create folder to be shared on the server
```bash

sudo mkdir -p /var/nfs-server/test 

sudo chown nobody:nogroup /var/nfs-server/test
```

note: NFS will translate any root operations on the client to the nobody:nogroup credentials as a security measure. Therefore, we need to change the directory ownership to match those credentials.

3)  NFS configuration file to set up the sharing of these resources.
 3.1) open file /etc/export and add  folder to be shaired with share option to client ip(directory_to_share    client(share_option1,...,share_optionN)

      example: /var/nfs-server/test    192.168.2.15 (rw,sync,no_subtree_check)
  3.2) sudo systemctl restart nfs-kernel-server

## Client Setup

1) install the nfs-common
```bash
$ sudo apt-get update
```
```bash
$ sudo apt-get install nfs-common
```
2) Create the folder on the Client for mounting point

```bash
sudo mkdir -p /nfs-client/test
```
3) Mounting server and client
```bash
sudo mount 192.168.2.13: /var/nfs-server/test  /nfs-client/test
```

4) Verify the path
```bash
  df -h
```
## Install NFS client provisioner
1) Clone the external-storage repository and switch to the nfs-client folder:

```bash
git clone https://github.com/kubernetes-incubator/external-storage

cd external-storage/nfs-client

```

2) EDIT deploy/deployment.yaml file, to specify the location and folder for your NFS server

example: 
           - name: NFS_SERVER 
             value: <<IP_OF_YOUR_NFS_SERVER>>  
           - name: NFS_PATH 
             value: <<PATH_TO_NFS_SHARED_FOLDER>>
     volumes: 
       - name: nfs-client-root 
         nfs: 
           server: <<IP_OF_YOUR_NFS_SERVER>>
           path: <<PATH_TO_NFS_SHARED_FOLDER>>

3) now, deploy 
kubectl create -f deploy/rbac.yaml
kubectl create -f deploy/class.yaml
kubectl create -f deploy/deployment.yaml
