## Metallb_ON_PREMISE with Cilium and Nginx ingress controller 

### MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.

   MetalLB requires the following to function:

1) A Kubernetes cluster, running Kubernetes 1.13.0 or later, that does not already have network load-balancing functionality.

2) A cluster network configuration that can coexist with MetalLB.

3)  IPv4 addresses for MetalLB .

4) Depending on the operating mode, you may need one or more routers capable of speaking BGP.


### FOR EXAMPLE we have following setup 

1) A Kubernetes cluster: v1.15.1 (3 node cluster)

2)cluster network configuration : cilium 

kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/kubernetes/1.14/cilium.yaml



### Installing Metallb 

1) kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

(note: reference https://metallb.universe.tf/installation/)

This will deploy MetalLB to your cluster, under the metallb-system namespace. 

####The components in the manifest are:

1) The metallb-system/controller deployment.( This is the cluster-wide controller that handles IP address assignments.)

2) The metallb-system/speaker daemonset. (This is the component that speaks the protocol(s) of your choice to make the services reachable)

3)Service accounts for the controller and speaker, along with the RBAC permissions that the components need to function.

![Screenshot from 2019-07-30 11-12-16](https://user-images.githubusercontent.com/30106168/62108245-35102f80-b2c7-11e9-996e-4542a9d6d607.png)

verify the speaker and controller are running state:

![Screenshot from 2019-07-30 11-12-40](https://user-images.githubusercontent.com/30106168/62108461-b962b280-b2c7-11e9-97fc-5ace03d32aef.png)

### NOW add configMap
 MetalLB’s components  will remain idle until you define and deploy a configmap.(for demo we will be using layer2 configuration)
 
kubectl apply -f  https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/metallb_install/configMap_example.yml

### Installing Nginx Ingress Controller

1) kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/nginx-ingress/nginx_controller_install.yml


2)kubectl create https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/nginx-ingress/nginx_ingress_svc.yml

![Screenshot from 2019-07-30 11-20-44](https://user-images.githubusercontent.com/30106168/62110414-f6c93f00-b2cb-11e9-8cea-310aff24eb37.png)


### Creating demo of hello-world
1) create a namespace  helloworld

kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/helloworld_example/hello-world-ns.yml

2) create a pod 

kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/helloworld_example/hello-pod.yml

3) create a cluster ip svc 

kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/helloworld_example/hello-svc.yml



4) create a  ingress 




