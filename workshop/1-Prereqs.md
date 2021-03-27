---
title: 1 - Setup the work environment
layout: default
---

# 1 - Setup the work environment with Minikube

The instructions will work on Linux and macOS, they have not been tested on Windows.

The [Minikube Getting Started](https://minikube.sigs.k8s.io/docs/start/) has detailled instructions on how to install Minikube for the different platforms.

## Step 1 - Install required tools:

To run the workshop completely off your own workstation you need the following tools (depending on the track you select):

Tool  |Source       
----------------|----
Minikube|[https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)
git CLI|[https://git-scm.com/downloads](https://git-scm.com/downloads) 
kubectl|[https://kubernetes.io/docs/tasks/tools/install-kubectl/](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
kn|[https://knative.dev/docs/install/install-kn/](https://knative.dev/docs/install/install-kn/)
hey|(HTTP Load generator) [https://github.com/rakyll/hey](https://github.com/rakyll/hey)

### Step 2: Download the code from this repository

```
git clone git@github.com:Harald-U/knative-on-minikube.git
cd knative-on-minikube/code/
```

### Step 3: Start a Minikube "cluster"

In this workshop we will use Minikube in a somewhat minimal configuration with 2 CPUs and 4 GB of memory. (It is intended to run on a notebook with only 8GB of RAM available.)

The Docker driver allows you to install Kubernetes into an existing Docker install. On Linux, this does not require any virtualization at all, on macOS this is using the virtualization of Docker Desktop (HyperKit). 

```
minikube start --cpus 2 --memory 4096 --driver=docker
```

**Note:** _If you have an existing Minikube cluster (from a previous lab), you may want to delete it with_ `minikube delete` _first. Deleting and recreating a Minikube cluster is likely to be a lot faster than clean-up in the existing one._ 


Output:

```
😄  minikube v1.16.0 on Linuxmint 20.1
✨  Using the docker driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
💾  Downloading Kubernetes v1.20.0 preload ...
    > preloaded-images-k8s-v8-v1....: 491.00 MiB / 491.00 MiB  100.00% 3.41 MiB
🔥  Creating docker container (CPUs=2, Memory=4096MB) ...
🐳  Preparing Kubernetes v1.20.0 on Docker 20.10.0 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Initial start will take long because it downloads the Kubernetes preload image. 

The [Minikube Getting Started](https://minikube.sigs.k8s.io/docs/start/) has instructions on how to manage the Minikube cluster.

---

**Continue with** [2 - Install Knative](../workshop/2-InstallKnative.md)
