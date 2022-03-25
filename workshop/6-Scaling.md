---
title: 6 - Auto-Scaling
layout: default
---

# 6 - Knative Auto-Scaling

**Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note** 

To complete this lab, you need `bombardier`, a command line HTTP benchmarking tool. You can find it [here](https://github.com/codesenberg/bombardier/releases){:target="_blank"}. Download the version that goes with your OS into your current directory. Rename it to something simpler, e.g. 

```
$ mv bombardier-linux-amd64 bombardier
```

On **bwLehrpool** you can create a directory /home/student/PERSISTENT/bin and move the bombardier executable there. This directory is in the PATH.

**/Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note-Note**

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
      # This is the name of our new "Revision," it must follow the convention {service-name}-{revision-name}
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
        - image: gcr.io/knative-samples/helloworld-go
          ports:
            - containerPort: 8080
          env:
            - name: TARGET
              value: "World V3 -- Scaling"
```
* `minScale: "1"` prevents scale to zero, there will always be at least 1 pod active.
* `maxScale: "5"` will allow to start a maximum of 5 pods.
* `target: "1"` limits every started pod to 1 concurrent request at a time, this is just to make it easier to demo. 

You can also [scale based on CPU usage or number of requests](https://knative.dev/docs/serving/autoscaling/autoscaling-metrics/){:target="_blank"}.

1. Deploy as usual (`kubectl apply ...`) and test if it works (`curl ...`).

1. In a second terminal session, watch the pods:
   ```
   watch kubectl get pod
   ```
   You should notice that 1 pod is running, and running longer than 60 seconds. This is the result of `minScale: "1"`. Scale to zero has been turned off.
   
2. In the first terminal session generate some load. The `bombardier` benchmarking tool must be in your current directory (see top of this section). Remember to use your own IP address here!
3. 
   ```
   $ kn service list helloworld
    NAME         URL                                              LATEST          AGE   CONDITIONS   READY   REASON
    helloworld   http://helloworld.kntest.10.104.55.31.sslip.io   helloworld-v3   31m   3 OK / 3     True   

   $ ./bombardier -c 50 -d 60s http://helloworld.kntest.10.104.55.31.sslip.io/
    Bombarding http://helloworld.kntest.10.104.55.31.sslip.io:80/ for 1m0s using 50 connection(s)
    [=========================================================================] 1m0s
    Done!
    Statistics        Avg      Stdev        Max
      Reqs/sec       462.21     552.42    5196.67
      Latency      108.29ms    65.62ms   527.32ms
      HTTP codes:
        1xx - 0, 2xx - 27726, 3xx - 0, 4xx - 0, 5xx - 0
        others - 0
      Throughput:   127.96KB/s
   ```

  `bombardier` is a simple HTTP load generator, `-d 60s` means 'run for 60 seconds' and `-c 50` starts 50 concurrent sessions.

   
   Switch over to session 2 and watch 4 more pods being started.
   ```
   NAME                                         READY   STATUS    RESTARTS   AGE
   helloworld-v3-deployment-7c6bd88f95-7kd86    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-96z75    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-dkjdr    2/2     Running   0          48s
   helloworld-v3-deployment-7c6bd88f95-m75x4    2/2     Running   0          9m50s
   helloworld-v3-deployment-7c6bd88f95-zftw5    2/2     Running   0          48s
   ```

  
**This concludes the main part of the Knative workshop.**   
 
---

__Continue with the optional last part [7 - Knative Debugging Tips](7-Debugging)__