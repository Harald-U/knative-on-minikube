#!/bin/sh

# Knative version to be installed
knver="knative-v1.1.0"


echo "----------------------------------------------------------------------------------------------------------"
echo ">> Checking availability of cluster"
kubectl version > /dev/null 2>&1
if [ $? -ne 0 ] 
then 
  echo ">> Cannot access Minikube cluster ... maybe you need to start/create it first?" 
  echo "----------------------------------------------------------------------------------------------------------"
  exit
fi

echo "----------------------------------------------------------------------------------------------------------"
echo ">> Installing $knver onto your Kubernetes cluster"
echo "----------------------------------------------------------------------------------------------------------"

echo ">> Knative CRDs"
echo "----------------------------------------------------------------------------------------------------------"
kubectl apply -f https://github.com/knative/serving/releases/download/$knver/serving-crds.yaml

echo "----------------------------------------------------------------------------------------------------------"
echo ">> Knative Core"
echo "----------------------------------------------------------------------------------------------------------"
kubectl apply -f https://github.com/knative/serving/releases/download/$knver/serving-core.yaml

echo "----------------------------------------------------------------------------------------------------------"
echo ">> Wait for a moment for everything to settle ..."
echo ""
sleep 45

echo ""
echo ">> Knative Kourier networking layer"
echo "----------------------------------------------------------------------------------------------------------"
kubectl apply -f https://github.com/knative/net-kourier/releases/download/$knver/kourier.yaml
kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'

echo "----------------------------------------------------------------------------------------------------------"
echo ">> Configure sslip.io DNS"
echo "----------------------------------------------------------------------------------------------------------"
kubectl apply -f https://github.com/knative/serving/releases/download/$knver/serving-default-domain.yaml

echo "----------------------------------------------------------------------------------------------------------"
echo ">> Display Knative and Kourier pods"
echo "----------------------------------------------------------------------------------------------------------"
kubectl get pods -n knative-serving
kubectl get pods -n kourier-system

echo "----------------------------------------------------------------------------------------------------------"
echo ">> If some of the pods are not in 'Running' or 'Completed' status, keep chcking with these commands:"
echo ">> >> kubectl get pods -n knative-serving"
echo ">> >> kubectl get pods -n kourier-system"
echo " "
echo ">> When all pods are in 'Running' or 'Completed' status, continue:"
echo ">> Execute 'minikube tunnel' in a separate session"
echo " "
echo ">> Then check the Knative EXTERNAL-IP with this command:"
echo ">> kubectl --namespace kourier-system get service kourier"
echo "----------------------------------------------------------------------------------------------------------"

