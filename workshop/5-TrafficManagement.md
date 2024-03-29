---
title: 5 - Traffic Management
layout: default
---

# 5 - Knative Traffic Management

In the last section you have replaced revision v1 of the helloworld app with revision v2.

What if you want to do a canary release and test the new revision/version on a subset of your users?  

This is something you can easily do with Istio. But it requires additional VirtualService and DestinationRule definitions.

Here is the Knative way, *service-v2-canary.yaml*:

```
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: helloworld
spec:
  template:
    metadata:
      name: helloworld-v2-canary
    spec:
      containers:
        - image: docker.io/ibmcom/kn-helloworld
          env:
            - name: TARGET
              value: "HelloWorld Sample v2 -- UPDATED"
  traffic:
    - tag: v1
      revisionName: helloworld-v1
      percent: 75
    - tag: v2
      revisionName: helloworld-v2
      percent: 25
```
Those additional 7 lines of code will create a 75% / 25% distribution between revisions -v1 / -v2.

1. Open a second terminal session and start this command, this may still be open from a previous exercise:
   ```
   watch kubectl get pod
   ```

1. In the first terminal session deploy the change:
   ```
   kubectl apply -f service-v2-canary.yaml
   ```
   
1. Still in the first terminal session, execute the `curl` within a `watch`, but of course you need to use the IP address of your environment!
   ```
   watch curl http://helloworld.kntest.10.103.104.209.sslip.io  
   ```
   
   Check the second terminal session. There are now two pods, one for each revision:
   ```
   NAME                                        READY   STATUS    RESTARTS   AGE
   helloworld-v1-deployment-655d7dc89-vw6rl    2/2     Running   0          29s
   helloworld-v2-deployment-5456b55564-6zrvc   2/2     Running   0          34s
   ```
   
   In the first terminal session, you can see output from v1 and v2, but v1 output will be more often than v2 (75 % vs. 25 %).
   

   If you terminate the `watch curl` in session one, you can observe in session two how the two pods will terminate eventually.
   
---

__Continue with the next part [6 - Knative Auto-Scaling](6-Scaling)__
