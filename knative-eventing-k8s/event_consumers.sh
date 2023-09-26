#!/bin/bash
kubectl -n eventing-test apply -f hello-display.yaml
kubectl -n eventing-test apply -f goodbye-display.yaml
kubectl -n eventing-test get deployments hello-display goodbye-display
