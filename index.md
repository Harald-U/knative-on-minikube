---
layout: default
---

_This workshop is an adaptation of the [Knative Hands-on Workshop](https://harald-u.github.io/knative-handson-workshop/) I created for IBM._

_The IBM Workshop uses preprovisioned Kubernetes or OpenShift clusters on the IBM Cloud based on IBM Cloud Kubernetes Service (IKS) or Red OpenShift on IBM Cloud (ROKS)._

_This version of the workshop is based on [Minikube](https://minikube.sigs.k8s.io/docs/) running on your own workstation._  

---

# Knative Hands-on Workshop

## Why is deploying a Knative service easier than a Kubernetess deployment? 

![Knative Logo](images/knative-logo.png)

Knative is a framework running on top of Kubernetes that makes it easier to perform common tasks such as scaling up and down, routing traffic, canary deployments, etc. According to the Knative web site it is "abstracting away the complex details and enabling developers to focus on what matters. It solves the 'boring but difficult' parts of deploying and managing cloud native services so you don't have to."

How is the experience of deploying an application on Kubernetes versus Knative?

## What is Knative? 

It is an additional layer installed on top of Kubernetes. 

It has two distinct components, originally it were three. The third was called Knative Build, it is now a project of its own: [Tekton](https://tekton.dev/). 

* __Knative Serving__ is responsible for deploying and running containers, also networking and auto-scaling. Auto-scaling allows scale to zero and is probably the main reason why Knative is referred to as Serverless platform.
* __Knative Eventing__ allows to connect Knative services (deployed by Knative Serving) or other Kubernetes deployments with events or streams of events.

This workshop will **focus on Knative Serving** and will cover the following topics, work through them in sequence:

- [1 - Setup the work environment](workshop/1-Prereqs.md)
- [2 - Install Knative](workshop/2-InstallKnative.md)
- [3 - Deploy a Knative Service](workshop/3-DeployKnativeService.md)
- [4 - Create a Knative Revision](workshop/4-Revision.md)
- [5 - Traffic Management](workshop/5-TrafficManagement.md)
- [6 - Auto-Scaling](workshop/6-Scaling.md)
- [7 - Debugging Tips](workshop/7-Debugging.md)

To complete this workshop, basic understanding of Kubernetes itself and application deployment on Kubernetes is instrumental!

## Resources:

You can find detailed information and learn more about Knative here:

1. [Knative documentation](https://knative.dev/docs)
2. [Red Hat Knative Tutorial](https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial/index.html)
4.  A series of blogs on Knative:
   - [Serverless and Knative – Part 1: Installing Knative on CodeReady Containers](https://haralduebele.blog/2020/06/02/serverless-and-knative-part-1-installing-knative-on-codeready-containers/)
   - [Serverless and Knative – Part 2: Knative Serving](https://haralduebele.blog/2020/06/03/serverless-and-knative-part-2-knative-serving/)
   - [Serverless and Knative – Part 3: Knative Eventing](https://haralduebele.blog/2020/06/10/serverless-and-knative-part-3-knative-eventing/)
   - [Knative Example: Deploying a Microservices Application](https://haralduebele.blog/2020/07/02/knative-example-deploying-a-microservices-application/) -- The YAML files for this example are in the `code/cloud-native-starter` directory

