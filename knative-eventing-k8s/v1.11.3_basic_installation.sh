#!/bin/bash

kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.11.3/eventing-crds.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.11.3/eventing-core.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.11.3/in-memory-channel.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/knative-v1.11.3/mt-channel-broker.yaml

