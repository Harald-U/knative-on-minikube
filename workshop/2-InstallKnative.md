---
title: 2 - Install Knative
layout: default
---

# 2 - Installing Knative

A Minikube "cluster" has been created in the previous section.

Installation of Knative is covered in the [Knative Administartion guide](https://knative.dev/docs/admin/install/serving/install-serving-with-yaml/). We will install Knative Serving in this section using Kourier as networking layer.

**Important:** Check the output of every command that you executed for errors! Do not blindly run command after command.

### Installing the Serving component 

1. Install the Knative Serving Custom Resource Definitions (aka CRDs):

      ```sh
      kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-crds.yaml
      ```

1. Install the core components of Knative Serving:

      ```sh
      kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-core.yaml
      ```

### Installing Kourier as networking layer

Knative [requires a networking layer with an Ingress](https://knative.dev/docs/admin/install/serving/install-serving-with-yaml/#install-a-networking-layer) that is not part of the Knative installation itself. There are several options, Istio is one of them, another one is [Kourier](https://github.com/knative/net-kourier) which was developed originally by 3Scale which is now a part of Red Hat. Kourier is now maintained by the Knative project itself. Other networking options are Ambassador, Contour, Glue, and Kong. 

We will use Kourier in this lab, you can find more information about Kourier in this [Red Hat blog](https://developers.redhat.com/blog/2020/06/30/kourier-a-lightweight-knative-serving-ingress/).

![Kourier](../images/Kourier_diagram.png)

The following commands install Kourier and enable its Knative integration.

1. Install the Knative Kourier controller:

      ```
      kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.1.0/kourier.yaml
      ```

1. Configure Knative Serving to use Kourier by default:

      ```
      kubectl patch configmap/config-network \
      --namespace knative-serving \
       --type merge \
       --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'
      ```

1. Check the External IP:

      ```
      kubectl --namespace kourier-system get service kourier
      ```

      Result should show the external IP as `<pending>` which is normal for Minikube.

1. Verify the installation:

   List all pods in the knative-serving namespace:


   ```
   kubectl get pods -n knative-serving
   kubectl get pods -n kourier-system
   ```

   All pods should be in status "Running":

   ```
      NAME                                      READY   STATUS    RESTARTS   AGE
      activator-848b54764c-lf5tz                1/1     Running   0          5m14s
      autoscaler-6c9d98bfc7-5wbw6               1/1     Running   0          5m14s
      controller-74cffd4749-njgv7               1/1     Running   0          5m14s
      domain-mapping-5557d5d995-nq49r           1/1     Running   0          5m14s
      domainmapping-webhook-646496fddc-c7258    1/1     Running   0          5m13s
      net-kourier-controller-85657dfb57-7b7t5   1/1     Running   0          3m39s
      webhook-55868d7455-hng8l                  1/1     Running   0          5m13s

      NAME                                      READY   STATUS    RESTARTS   AGE
      3scale-kourier-gateway-77849dcc96-hqd99   1/1     Running   0          64s
   ```   

         

### Configure "Magic" DNS

Knative ships a simple Kubernetes Job called “default domain” that will configure Knative Serving to use [sslip.io](http://sslip.io/){:target="_blank"} as the default DNS suffix.

*Note:* The default domain used to be 'xip.io' but this suddenly [stopped working](https://github.com/knative/serving/issues/11297).

1. Apply the Kubernetes job:

      ```
      kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-default-domain.yaml
      ```

2. Create a Minikube tunnel, this requires administrator rights on your workstation. 
   
   Enter the following command in **another** terminal session:

      ```
      minikube tunnel
      ```      

      **Keep this session open and 'minikube tunnel' running during the whole workshop!**

3. Check the External IP again:

      ```
      kubectl --namespace kourier-system get service kourier
      ```

      Result should show the external IP equal to the Cluster IP of the service, e.g. `10.103.104.209`. 

      This makes the Knative services reachable on your notebook via the DNS entry `*.10.103.104.209.sslip.io`.

      Test if this works (with your own external IP address!):

      ```
      ping 10.103.104.209.sslip.io
      ```

      Result, e.g.:

      ```
      PING 10.103.104.209.xip.io (10.103.104.209) 56(84) bytes data.
      From 192.168.49.2 (192.168.49.2) icmp_seq=2 Host redirect (New nexthop: 1.49.168.192 (1.49.168.192))
      ```

      How does this work: A DNS request for e.g. helloworld.10.103.104.209.sslip.io will resolve to IP address 10.103.104.209. This IP address is made available by `minikube tunnel` and is answered via the Kourier ingress gateway. It's magic :-)


**Note:** If you want/need to quickly install Knative into your Minikube cluster, use the `code/install/install-knative.sh` shell script.

---

__Continue with the next part [3 - Deploy a Knative Service](../workshop/3-DeployKnativeService)__      

