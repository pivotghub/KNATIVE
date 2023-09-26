#!/bin/bash
kubectl -n eventing-test apply -f event-producer.yaml
kubectl get pods -n eventing-test
