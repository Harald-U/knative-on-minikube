---
title: 6 - Auto-Scaling
layout: default
---

# 6 - Knative Auto-Scaling

Scale to zero is an interesting feature but without additional tricks (like pre-started containers or pods, which aren't available in Knative) it can be annoying because users may have to wait until a new pod is started and ready to receive requests. Or it can lead to problems like time-outs in a microservices architecture if a scaled-to-zero service is called by another service and has to be started first and takes some time to start (e.g. traditional Java based service). 

On the other hand, if our application / microservice is hit hard with many requests, a single pod may not be sufficient to serve them and we may need to scale up. And preferably scale up and down automatically.

Auto-scaling is accomplished by simply adding a few annotation statements to the Knative Service description, *service-v3-scaling.yaml*:
```
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: helloworld
spec:
  template:
    metadata:
      name: helloworld-v3
      annotations:
        # the minimum number of pods to scale down to
        autoscaling.knative.dev/minScale: "1"
        # the maximum number of pods to scale up to
        autoscaling.knative.dev/maxScale: "5"
        # Target in-flight-requests per pod.
        autoscaling.knative.dev/target: "1"
    spec:
      containers:
        - image: docker.io/ibmcom/kn-helloworld
          env:
            - name: TARGET
              value: "HelloWorld Sample v3 -- Scaling"
```
* `minScale: "1"` prevents scale to zero, there will always be at least 1 pod active.
* `maxScale: "5"` will allow to start a maximum of 5 pods.
* `target: "1"` limits every started pod to 1 concurrent request at a time, this is just to make it easier to demo. 

You can also [scale based on CPU usage or number of requests](https://knative.dev/docs/serving/autoscaling/autoscaling-metrics/).

1. Deploy as usual (`kubectl apply ...`) and test if it works (`curl ...`).

1. In a second terminal session, watch the pods:
   ```
   watch kubectl get pod
   ```
   You should notice that 1 pod is running, and running longer than 60 seconds. This is the result of `minScale: "1"`. Scale to zero has been turned off.
   
1. In the first terminal session generate some load:
   ```
   hey -z 30s -c 50 http://helloworld-....appdomain.cloud   
   ```
   Switch over to session 2 and watch 4 more pods being started.
   ```
   NAME                                         READY   STATUS    RESTARTS   AGE
   helloworld-v3-deployment-7c6bd88f95-7kd86    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-96z75    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-dkjdr    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-m75x4    2/2     Running   0          9m50s
   helloworld-v3-deployment-7c6bd88f95-zftw5    2/2     Running   0          48s
   ```
5. Check the output of the `hey`command, for example the histogram:
   ```
    Response time histogram:
      0.002 [1]     |
      0.039 [4079]  |■■■■■■■■■■■■■■■
      0.077 [66]    |
      0.114 [10744] |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
      0.151 [320]   |■
      0.189 [921]   |■■■
      0.226 [841]   |■■■
      0.263 [0]     |
      0.301 [97]    |
      0.338 [28]    |
      0.375 [1]     |

   ```
   All of the requests took less than half a second. Thats because one pod is always started and can take the initial brunt of the requests.
  
**This concludes the main part of the Knative workshop.**   

 
---

__Continue with the last part [7 - Knative Debugging Tips](7-Debugging.md)__