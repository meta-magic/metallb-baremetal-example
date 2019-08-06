# Metallb ON-PREMISE with Cilium and Istio ingress controller 

Kubernetes implementation in the cloud services like Amazon (EKS), Google (GKE) or Azure (AKS) provides out of the box capabilities like Multi-Master High Availability, Ingress Load Balancer (to handle in the traffic from the internet), Network Storage, and launching worker nodes with different hardware requirements. 

All these facilities will NOT available if you install Kubernetes Clusters On-Premise if the infrastructure team uses an IaaS (Infrastructure as a Service) and builds the Kubnernetes cluster on bare metal. 

This section will focus on how to deploy an Ingress enabled Load Balancer (at the Gateway) to handing the incoming traffic to the cluster. 

Bare metal cluster operators have left with two lesser tools to bring user traffic into their clusters, “NodePort” and “externalIPs” services. Both of these options have significant downsides for production use, which makes bare metal clusters second class citizens in the Kubernetes ecosystem. (From metallb web site).

MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.


## MetalLB requires the following to function:

1) A Kubernetes cluster, running Kubernetes 1.13.0 or later, that does not already have network load-balancing functionality.

2) A cluster network configuration that can coexist with MetalLB.

3)  IPv4 addresses for MetalLB .

4) Depending on the operating mode, you may need one or more routers capable of speaking BGP.


## 1. Kubernetes Setup

A Kubernetes cluster: v1.15.1 (3 node cluster) is already set ready.


## 2. Install Cilium Network Driver 

cluster network configuration : cilium 

```bash
$ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/kubernetes/1.14/cilium.yaml
```

## 3. Install Metallb 

```bash
$ kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
```

(Reference https://metallb.universe.tf/installation/)

This will deploy MetalLB to your cluster, under the metallb-system namespace. 

### 3.1 Metal LB Components

1) The metallb-system/controller deployment. (This is the cluster-wide controller that handles IP address assignments.)

2) The metallb-system/speaker daemonset. (This is the component that speaks the protocol(s) of your choice to make the services reachable)

3) Service accounts for the controller and speaker, along with the RBAC permissions that the components need to function.

![Screenshot from 2019-07-30 11-12-16](https://user-images.githubusercontent.com/30106168/62108245-35102f80-b2c7-11e9-996e-4542a9d6d607.png)

### 3.2 Verify the speaker and controller are running state:

![Screenshot from 2019-07-30 11-12-40](https://user-images.githubusercontent.com/30106168/62108461-b962b280-b2c7-11e9-97fc-5ace03d32aef.png)

### 3.3 Add configMap

MetalLB’s components  will remain idle until you define and deploy a configmap.(for demo we will be using layer2 configuration)

```bash
$ kubectl apply -f  https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/metallb_install/configMap_example.yml
```

## 4. Install ISTIO

### 4.1 Download Istio

```bash
  curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.2.2 sh -
```

Move to the Istio package directory. For example, if the package is istio-1.2.2:

```bash
cd istio-1.2.2/
```


### 4.2  Install all the Istio Custom Resource Definitions (CRDs)

```bash
$ for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done

```

### 4.3 Create the demo variant

```bash
$ kubectl apply -f install/kubernetes/istio-demo.yaml

```


## 5. Deploy Shoppingportal Demo App with 3 services - UI Service, Product Service & Product Review Service

### 5.1 Create a namespace shoppingportal

```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/shopping-ns.yaml
```

### 5.2 Create Deployment, Service, Deployment Rule of Product Service

```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/product-v1.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/product-service.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/product-destination.yaml
```
### 5.3  Create Deployment, Service of ProductReview Service

```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/productreview-v1.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/productreview-service.yaml
```

### 5.4 Create Deployment, Service, Deployment Rule of UII service

```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/ui-v1.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/ui-v2.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/ui-service.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/ui-destination.yaml
```
## 5.5 Create Virtual Service and Gateway

```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/shoppingportal-virtualservice.yaml
```
```bash
$ kubectl create -f https://raw.githubusercontent.com/meta-magic/metallb-baremetal-example/master/istio/shoppingportal-gw.yaml
```
## 6 Verify Shopping Portal Installation

 ```bash
$ kubectl get pods,svc,vs,dr,gateway -n shoppingportal
```

![Screenshot from 2019-08-02 11-51-26](https://user-images.githubusercontent.com/30106168/62351383-ef4fa300-b522-11e9-9ef3-312065330e21.png)

## 7. GET the istio-ingress gateway ip address  

```bash
$ kubectl get svc -n istio-system
```
![Screenshot from 2019-08-02 11-57-09](https://user-images.githubusercontent.com/30106168/62351598-99c7c600-b523-11e9-9250-92a5d8e8cdc8.png) 

## 8. Access url http://192.168.2.7/ui/ (IP of ingress)


![Screenshot from 2019-08-02 11-43-42](https://user-images.githubusercontent.com/30106168/62351622-ab10d280-b523-11e9-94ba-2162558c6936.png)



