---
title: 1 - Setup the work environment
layout: default
---

# 1 - Setup the work environment with Minikube

The instructions will work on Linux and macOS, they have not been tested on Windows.

The [Minikube Getting Started](https://minikube.sigs.k8s.io/docs/start/) has detailled instructions on how to install Minikube for the different platforms. 

At the time of this writing, Minikube was at v1.24.0. This workshop is **based on Knative v1.1.0**.

## Step 1 - Install required tools:

To run the workshop completely off your own workstation you need the following tools:

Tool  |Source       
----------------|----
Minikube|[https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/){:target="_blank"}
git CLI|[https://git-scm.com/downloads](https://git-scm.com/downloads){:target="_blank"} 
kubectl|[https://kubernetes.io/docs/tasks/tools/install-kubectl/](https://kubernetes.io/docs/tasks/tools/install-kubectl/){:target="_blank"}
kn|[https://knative.dev/docs/install/install-kn/](https://knative.dev/docs/install/install-kn/){:target="_blank"}
bombardier (HTTP Load generator)|[https://github.com/codesenberg/bombardier/releases](https://github.com/codesenberg/bombardier/releases){:target="_blank"}

### Step 2: Download the code from this repository

```
git clone https://github.com/Harald-U/knative-on-minikube.git
cd knative-on-minikube/code/
```

### Step 3: Start a Minikube "cluster"

In this workshop we will use Minikube in a somewhat minimal configuration with 2 CPUs and 4 GB of memory. (It is intended to run on a notebook with only 8GB of RAM available.)

The Docker driver allows you to install Kubernetes into an existing Docker install. On Linux, this does not require any virtualization at all, on macOS this is using the virtualization of Docker Desktop (HyperKit). 

```
minikube start --cpus 2 --memory 4096 --driver=docker
```

### Step 3 on bwLehrpool

There may be a "leftover" (and damaged) Minikube instance that was present when the VMware image for the Linux environment was built.  This may cause problems. Enter the following command before you start this workshop:

```
$ minikube delete
```

Output will be most likely something like this:

```
🔥  minikube" in docker wird gelöscht...
🔥  /home/student/.minikube/machines/minikube wird entfernt...
💀  Removed all traces of the "minikube" cluster.
```

Please be aware that this command will delete any existing Minikube cluster!

**bwLehrpool has sufficient RAM to increase memory for Minikube**, you can use this command instead:

```
$ minikube start --cpus 2 --memory 6144 --driver docker
```

which will assign 6 GB of RAM.

---

**Continue with** [2 - Install Knative](../workshop/2-InstallKnative)
