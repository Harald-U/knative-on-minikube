---
title: 2 - Install Knative
layout: default
---

# 2 - Installing Knative

A Minikube "cluster" has been created in th eprevious section.

Installation of Knative is covered in the [Knative documentation](https://knative.dev/docs/install/any-kubernetes-cluster/). We will install Knative Serving in this section using Kourier as networking layer.

### Installing the Serving component 

1. Install the Knative Serving Custom Resource Definitions (aka CRDs):

      ```sh
      kubectl apply --filename https://github.com/knative/serving/releases/download/v0.21.0/serving-crds.yaml
      ```

1. Install the core components of Knative Serving:

      ```sh
      kubectl apply --filename https://github.com/knative/serving/releases/download/v0.21.0/serving-core.yaml
      ```

### Installing Kourier as networking layer

Knative [requires a networking layer with an Ingress](https://knative.dev/docs/install/any-kubernetes-cluster/) that is not part of the Knative installation itself. There are several options, Istio is one of them, another one is [Kourier](https://github.com/knative/net-kourier) which was developed originally by 3Scale which is now a part of Red Hat. Kourier is now maintained by the Knative project itself. Other networking options are Ambassador, Contour, Glue, and Kong. 

We will use Kourier in this lab, you can find more information about Kourier in this [Red Hat blog](https://developers.redhat.com/blog/2020/06/30/kourier-a-lightweight-knative-serving-ingress/).

![Kourier](../images/Kourier_diagram.png)

The following commands install Kourier and enable its Knative integration.

1. Install the Knative Kourier controller:

      ```
      kubectl apply --filename https://github.com/knative/serving/releases/download/v0.21.0/serving-default-domain.yaml
      ```

1. Configure Knative Serving to use Kourier by default:

      ```
      kubectl patch configmap/config-network \
      --namespace knative-serving \
      --type merge \
      --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
      ```

1. Check the External IP:

      ```
      kubectl --namespace kourier-system get service kourier
      ```

      Result should show the external IP as `<pending>` which is normal for Minikube.

### Configure DNS

Knative ships a simple Kubernetes Job called “default domain” that will configure Knative Serving to use [xip.io](http://xip.io/){:target="_blank"} as the default DNS suffix.

1. Apply the Kubernetes job:

      ```
      kubectl apply --filename https://github.com/knative/serving/releases/download/v0.21.0/serving-default-domain.yaml
      ```

1. Create a Minikube tunnel. Enter the following command in another terminal session:

      ```
      minikube tunnel
      ```

      This requires sudo rights.

1. Check the External IP again:

      ```
      kubectl --namespace kourier-system get service kourier
      ```

      Result should show the external IP equal to the Cluster IP of the service, e.g. `10.103.104.209`. 

      This makes the Knative services reachable on your notebook via the DNS entry `*.10.103.104.209.xip.io`.

      Test if this works (with your own external IP address!):

      ```
      ping 10.103.104.209.xip.io
      ```

      Result, e.g.:

      ```
      PING 10.103.104.209.xip.io (10.103.104.209) 56(84) bytes data.
      From 192.168.49.2 (192.168.49.2) icmp_seq=2 Host redirect (New nexthop: 1.49.168.192 (1.49.168.192))
      ```

      How does this work: A DNS request for e.g. helloworld.10.103.104.209.xip.io will resolve to IP address 10.103.104.209. This IP address is made available by `minikube tunnel` and is answered via the Kourier ingress gateway. It's magic :-)


---

__Continue with the next part [3 - Deploy a Knative Service](../workshop/3-DeployKnativeService.md)__      

